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
    
    func test_askForLocation_callsService() async throws {
        let serviceSpy = Spy()
        let store = TestStore(
            initialState: SearchStationReducer.State(),
            reducer: SearchStationReducer()
        ) {
            $0.locationService.requestAuthorization = {
                await serviceSpy.call()
            }
        }
        
        await store.send(.askForLocationPersmission) {
            $0.locationStatus = .determining
        }
        
        let calls = await serviceSpy.calls
        XCTAssertEqual(calls, 1)
    }
    
    func test_observesLocation() async throws {
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
        }
        
        let task = await store.send(.task)
        
        for status in statuses {
            await clock.advance(by: .seconds(1))
            await store.receive(.locationStatusUpdate(status)) {
                $0.locationStatus = status
            }
        }
        
        await task.cancel()  // done by SwiftUI
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
