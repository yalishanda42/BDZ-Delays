import XCTest
@testable import SearchStationDomain
import SharedModels
import ComposableArchitecture

@MainActor
final class SearchStationDomainTests: XCTestCase {
    func test_filter_hasResults() async throws {
        let query = "соф"
        
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer(allStations: [.sofia, .dobrich])
        )
        
        await store.send(.updateQuery(query)) {
            $0.query = query
            $0.filteredStations = [.sofia]
        }
    }
    
    func test_filter_noResults() async throws {
        let query = "asdfg"
        
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer(allStations: [.sofia, .dobrich])
        )
        
        await store.send(.updateQuery(query)) {
            $0.query = query
            $0.filteredStations = []
        }
    }
    
    func test_filterClear_allStations() async throws {
        let query = ""
        let all: [BGStation] = [
            .aytos, .dobrich, .sofia
        ]
        
        let store = TestStore(
            initialState: SearchStationReducer.State(filteredStations: all),
            reducer: SearchStationReducer(allStations: all)
        )
        
        await store.send(.updateQuery(query)) // no modification expected
    }
    
    func test_locationAction_whenNotYetAsked_asksForPermisson() async throws {
        let serviceSpy = Spy()
        let store = TestStore(
            initialState: SearchStationReducer.State(
                locationStatus: .notYetAskedForAuthorization
            ),
            reducer: SearchStationReducer()
        ) {
            $0.locationService.requestAuthorization = {
                await serviceSpy.call()
            }
        }
        
        await store.send(.locationAction) {
            $0.locationStatus = .determining
        }
        
        let calls = await serviceSpy.calls
        XCTAssertEqual(calls, 1)
    }
    
    func test_locationAction_whenConnectionFailed_refreshes() async throws {
        let serviceSpy = Spy()
        let store = TestStore(
            initialState: SearchStationReducer.State(
                locationStatus: .authorized(nearestStation: nil)
            ),
            reducer: SearchStationReducer()
        ) {
            $0.locationService.manuallyRefreshStatus = {
                await serviceSpy.call()
            }
        }
        
        await store.send(.locationAction) {
            $0.locationStatus = .determining
        }
        
        let calls = await serviceSpy.calls
        XCTAssertEqual(calls, 1)
    }
    
    func test_locationAction_whenDenied_showsSettings() async throws {
        let serviceSpy = Spy()
        let store = TestStore(
            initialState: SearchStationReducer.State(
                locationStatus: .denied
            ),
            reducer: SearchStationReducer()
        ) {
            $0.settingsService.openSettings = {
                await serviceSpy.call()
            }
        }
        
        await store.send(.locationAction)
        
        let calls = await serviceSpy.calls
        XCTAssertEqual(calls, 1)
    }
    
    func test_task_observesLocation() async throws {
        let statuses: [LocationStatus] = [
            .notYetAskedForAuthorization,
            .authorized(nearestStation: .sofia),
            .denied,
            .authorized(nearestStation: nil),
            .authorized(nearestStation: .dobrich),
        ]
        
        let clock = TestClock()
        let counter = Spy()
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer()
        ) {
            $0.locationService.statusStream = {
                AsyncStream {
                    for await _ in clock.timer(interval: .seconds(1)) {
                        let count = await counter.call()
                        return statuses[count - 1]
                    }
                    return nil
                }
            }
            $0.favoritesService.loadFavorites = {[]}
        }
        
        let task = await store.send(.task)
        
        await store.receive(.loadSavedStations([]))
        
        for status in statuses {
            await clock.advance(by: .seconds(1))
            await store.receive(.locationStatusUpdate(status)) {
                $0.locationStatus = status
            }
        }
        
        await task.cancel()  // done by SwiftUI
    }
    
    func test_task_loadsPersistedInfo() async throws {
        let expected: [BGStation] = [.dobrich, .povelyanovo, .sofia]
        
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer()
        ) {
            $0.favoritesService.loadFavorites = { expected }
            $0.locationService.statusStream = { AsyncStream { _ in /* never */ } }
        }
        
        let task = await store.send(.task)
        await store.receive(.loadSavedStations(expected)) {
            $0.favoriteStations = expected
        }
        
        await task.cancel()  // done by SwiftUI
    }
    
    func test_toggleSave_savesAndThenUnsaves() async throws {
        let station = BGStation.dobrich
        let spy = Spy()
        
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer()
        ) {
            $0.favoritesService.saveFavorites = { _ in
                await spy.call()
            }
        }
        
        await store.send(.toggleSaveStation(station)) {
            $0.favoriteStations = [station]
        }
        
        let invocations1 = await spy.calls
        XCTAssertEqual(invocations1, 1)
        
        await store.send(.toggleSaveStation(station)) {
            $0.favoriteStations = []
        }
        
        let invocations2 = await spy.calls
        XCTAssertEqual(invocations2, 2)
    }
    
    func test_move_movesAndSaves() async throws {
        let initial: [BGStation] = [.dobrich, .povelyanovo, .sofia]
        let expected: [BGStation] = [.povelyanovo, .sofia, .dobrich]
        
        let spy = Spy()
        
        let store = TestStore(
            initialState: SearchStationReducer.State(
                favoriteStations: initial
            ),
            reducer: SearchStationReducer()
        ) {
            $0.favoritesService.saveFavorites = { _ in
                await spy.call()
            }
        }
        
        await store.send(.moveFavorite(from: [0], to: 3)) {
            $0.favoriteStations = expected
        }
        
        let invocations = await spy.calls
        XCTAssertEqual(invocations, 1)
    }
}

private actor Spy {
    private(set) var calls: Int = 0
    
    @discardableResult
    func call() -> Int {
        calls += 1
        return calls
    }
}
