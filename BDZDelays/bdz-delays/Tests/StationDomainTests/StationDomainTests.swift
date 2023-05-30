import XCTest
@testable import StationDomain
import StationRepository
import SharedModels
import ComposableArchitecture

@MainActor
final class StationDomainTests: XCTestCase {
    func test_refreshLoadsNewData_whenSuccess() async throws {
        let refreshDate = Self.dateOne
        let expected = Self.expectedOne

        let store = TestStore(
            initialState: .init(station: .sofia),
            reducer: StationReducer()
        ) {
            $0.stationRepository = StationRepository(
                fetchTrainsAtStation: { _ in expected }
            )
            $0.date.now = refreshDate
        }

        await store.send(.refresh) {
            $0.loadingState = .loading
        }
        await store.receive(.receive(.success(expected))) {
            $0.loadingState = .loaded
            $0.trains = expected
            $0.lastUpdateTime = refreshDate
        }
    }
    
    func test_refreshPersistsOldData_whenError() async throws {
        let error = StationRepositoryError.parseError
        
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                loadingState: .loaded,
                trains: Self.expectedOne,
                lastUpdateTime: Self.dateOne
            ),
            reducer: StationReducer()
        ) {
            $0.stationRepository = StationRepository(
                fetchTrainsAtStation: { _ in throw error }
            )
            $0.date.now = Self.dateTwo
        }

        await store.send(.refresh) {
            $0.loadingState = .loading
        }
        await store.receive(.receive(.failure(error))) {
            $0.loadingState = .failed
        }
    }
    
    func test_refreshReplacesOldData_whenSuccess() async throws {
        let expected = Self.expectedTwo
        let newDate = Self.dateTwo
        
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                loadingState: .loaded,
                trains: Self.expectedOne,
                lastUpdateTime: Self.dateOne
            ),
            reducer: StationReducer()
        ) {
            $0.stationRepository = StationRepository(
                fetchTrainsAtStation: { _ in expected }
            )
            $0.date.now = newDate
        }

        await store.send(.refresh) {
            $0.loadingState = .loading
        }
        await store.receive(.receive(.success(expected))) {
            $0.loadingState = .loaded
            $0.trains = expected
            $0.lastUpdateTime = newDate
        }
    }
    
    func test_refreshTwice_doesNotCancelOrDouble() async throws {
        let results = [Self.expectedOne, Self.expectedTwo]
        
        let clock = TestClock()
        let counter = Counter()
        
        let store = TestStore(
            initialState: .init(
                station: .sofia
            ),
            reducer: StationReducer()
        ) {
            $0.stationRepository = StationRepository(
                fetchTrainsAtStation: { _ in
                    let count = await counter.incremented()
                    // modelling first request to be taking a lot of time
                    // so that the second would complete before it if allowed to
                    let seconds = count == 2 ? 1 : 42
                    for await _ in clock.timer(interval: .seconds(seconds)) {
                        return results[count - 1]
                    }
                    return []
                }
            )
            $0.date = {
                let c = SendableCounter()
                return DateGenerator {
                    let i = c.incremented()
                    return Date(timeIntervalSinceReferenceDate: TimeInterval(i))
                }
            }()
        }

        await store.send(.refresh) {
            $0.loadingState = .loading
        }
        await store.send(.refresh)
        
        await clock.advance(by: .seconds(1)) // nothing should be received
        await clock.advance(by: .seconds(41)) // first request is now completed
        await store.receive(.receive(.success(Self.expectedOne))) {
            $0.loadingState = .loaded
            $0.trains = Self.expectedOne
            $0.lastUpdateTime = Date(timeIntervalSinceReferenceDate: 1)
        }
    }
    
    func test_tick_refreshesWhenInDifferrentMinute() async throws {
        let dateInNextMinute = Date(timeIntervalSinceReferenceDate: 61)
        
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                lastUpdateTime: Date(timeIntervalSinceReferenceDate: 51)
            ),
            reducer: StationReducer()
        ) {
            $0.date.now = dateInNextMinute
            $0.calendar = Calendar(identifier: .gregorian)
            $0.stationRepository.fetchTrainsAtStation = { _ in [] }
        }
        
        await store.send(.tick)
        
        await store.receive(.refresh) {
            $0.loadingState = .loading
        }
        
        await store.receive(.receive(.success([]))) {
            $0.trains = []
            $0.lastUpdateTime = dateInNextMinute
            $0.loadingState = .loaded
        }
    }
    
    func test_tick_doesNotRefreshWhenInSameMinute() async throws {
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                lastUpdateTime: Date(timeIntervalSinceReferenceDate: 51)
            ),
            reducer: StationReducer()
        ) {
            $0.date.now = Date(timeIntervalSinceReferenceDate: 52)
            $0.calendar = Calendar(identifier: .gregorian)
            $0.stationRepository.fetchTrainsAtStation = { _ in [] }
        }
        
        await store.send(.tick)
    }
    
    func test_tick_refreshesWhenNoPreviousUpdateTime() async throws {
        let dateInNextMinute = Date(timeIntervalSinceReferenceDate: 61)
        
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                lastUpdateTime: nil
            ),
            reducer: StationReducer()
        ) {
            $0.date.now = dateInNextMinute
            $0.calendar = Calendar(identifier: .gregorian)
            $0.stationRepository.fetchTrainsAtStation = { _ in [] }
        }
        
        await store.send(.tick)
        
        await store.receive(.refresh) {
            $0.loadingState = .loading
        }
        
        await store.receive(.receive(.success([]))) {
            $0.trains = []
            $0.lastUpdateTime = dateInNextMinute
            $0.loadingState = .loaded
        }
    }
    
    func test_tick_doesNotRefreshWhenErrored() async throws {
        let dateInNextMinute = Date(timeIntervalSinceReferenceDate: 61)
        
        let store = TestStore(
            initialState: .init(
                station: .sofia,
                loadingState: .failed,
                lastUpdateTime: Date(timeIntervalSinceReferenceDate: 51)
            ),
            reducer: StationReducer()
        ) {
            $0.date.now = dateInNextMinute
            $0.calendar = Calendar(identifier: .gregorian)
            $0.stationRepository.fetchTrainsAtStation = { _ in [] }
        }
        
        await store.send(.tick)
    }
    
    func test_finalize_cancelsEffects() async throws {
        let clock = TestClock()

        let store = TestStore(
            initialState: .init(station: .sofia),
            reducer: StationReducer()
        ) {
            $0.stationRepository = StationRepository(
                fetchTrainsAtStation: { _ in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        return []
                    }
                    return []
                }
            )
        }

        await store.send(.refresh) {
            $0.loadingState = .loading
        }
        
        // do not advance clock so that the task is still in flight
        
        await store.send(.finalize)
    }
}

// MARK: - Helpers

private extension StationDomainTests {
    static let dateOne = Date(timeIntervalSince1970: 1234567890)
    static let dateTwo = Date(timeIntervalSince1970: 1234567891)
    static let expectedOne: [TrainAtStation] = [
        .init(
            number: .init(type: .fast, number: 2112),
            from: .bulgarian(.dobrich),
            to: .bulgarian(.sofia),
            schedule: .arrivalOnly(Date(timeIntervalSince1970: 2234567890)),
            delay: nil,
            movement: .inOperation
        ),
    ]
    static let expectedTwo: [TrainAtStation] = [
        .init(
            number: .init(type: .suburban, number: 90125),
            from: .bulgarian(.sofia),
            to: .bulgarian(.dupnica),
            schedule: .departureOnly(Date(timeIntervalSince1970: 3234567890)),
            delay: nil,
            movement: .notYetOperating
        ),
    ]
}

private class SendableCounter: @unchecked Sendable {
    private(set) var count: Int = 0
    
    @discardableResult
    func incremented() -> Int {
        count += 1
        return count
    }
}

private actor Counter {
    private(set) var count: Int = 0
    
    @discardableResult
    func incremented() -> Int {
        count += 1
        return count
    }
}
