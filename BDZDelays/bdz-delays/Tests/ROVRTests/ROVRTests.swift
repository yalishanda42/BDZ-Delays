import XCTest
@testable import ROVR

final class ROVRTests: XCTestCase {
    func test_allFiles_decodeOK() async throws {
        for file in TestFile.allCases {
            let fileData = loadFile(file)
            let _ = try RovrDecoder.decode(pageData: fileData)
        }
        // we reach here => we good
    }
    
    func test_locationResponse_decodesStationIdOK() async throws {
        let testResponse = "1683384235 18 2021.6069047926 1626 1059.1314442427".data(using: .utf8)!
        let expected = ROVRStation.sofia
        
        let result = try RovrDecoder.decodeStation(fromLocationData: testResponse)
        
        XCTAssertEqual(result.rawValue, expected.rawValue)
    }
    
    func test_fileOne_parsesOK() async throws {
        let fileString = try RovrDecoder.decode(pageData: loadFile(.test))
        let result = try RovrHTMLScraper.scrapeHTML(fileString)
        XCTAssertEqual(result, Self.expectedOne)
    }
    
    func test_fileTwo_parsesOK() async throws {
        let fileString = try RovrDecoder.decode(pageData: loadFile(.test2))
        let result = try RovrHTMLScraper.scrapeHTML(fileString)
        XCTAssertEqual(result, Self.expectedTwo)
    }
}

private extension ROVRTests {
    enum TestFile: String, CaseIterable {
        case test
        case test2
    }
    
    func loadFile(_ file: TestFile) -> Data {
        let url = Bundle.module.url(forResource: file.rawValue, withExtension: "html")!
        let result = try! Data(contentsOf: url)
        return result
    }
    
    static let expectedOne: [RovrHTMLScraper.TrainData] = [
        .init(
            type: "БВ",
            number: "6622",
            to: "София",
            from: "Кюстендил",
            isOperating: false,
            delayMinutes: 1,
            arrival: "21:08",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "2614",
            to: "София",
            from: "Варна",
            isOperating: false,
            delayMinutes: nil,
            arrival: "21:10",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "1614",
            to: "София",
            from: "Свиленград",
            isOperating: false,
            delayMinutes: nil,
            arrival: "21:11",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8657",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:15",
            isAboutToLeave: true,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "50213",
            to: "Перник",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:30",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "10213",
            to: "София",
            from: "Драгоман",
            isOperating: true,
            delayMinutes: nil,
            arrival: "21:41",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "20217",
            to: "Мездра",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:50",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "5624",
            to: "София",
            from: "Благоевград",
            isOperating: true,
            delayMinutes: 1,
            arrival: "22:10",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8602",
            to: "София",
            from: "Бургас",
            isOperating: true,
            delayMinutes: 4,
            arrival: "22:10",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "7625",
            to: "София",
            from: "Видин пътн.",
            isOperating: true,
            delayMinutes: nil,
            arrival: "22:22",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "50215",
            to: "Перник",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:30",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "3637",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:40",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "2627",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:45",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8627",
            to: "Бургас",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:55",
            isAboutToLeave: false,
            hasLeft: false
        ),
    ]
    static let expectedTwo: [RovrHTMLScraper.TrainData] = [
        .init(
            type: "БВ",
            number: "6622",
            to: "София",
            from: "Кюстендил",
            isOperating: false,
            delayMinutes: 1,
            arrival: "21:08",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "2614",
            to: "София",
            from: "Варна",
            isOperating: false,
            delayMinutes: nil,
            arrival: "21:10",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "1614",
            to: "София",
            from: "Свиленград",
            isOperating: false,
            delayMinutes: nil,
            arrival: "21:11",
            hasArrived: true,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8657",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:15",
            isAboutToLeave: false,
            hasLeft: true
        ),
        .init(
            type: "КПВ",
            number: "50213",
            to: "Перник",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:30",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "10213",
            to: "София",
            from: "Драгоман",
            isOperating: true,
            delayMinutes: nil,
            arrival: "21:41",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "20217",
            to: "Мездра",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "21:50",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "5624",
            to: "София",
            from: "Благоевград",
            isOperating: true,
            delayMinutes: 1,
            arrival: "22:10",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8602",
            to: "София",
            from: "Бургас",
            isOperating: true,
            delayMinutes: 4,
            arrival: "22:10",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "7625",
            to: "София",
            from: "Видин пътн.",
            isOperating: true,
            delayMinutes: nil,
            arrival: "22:22",
            hasArrived: false,
            departure: nil,
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "КПВ",
            number: "50215",
            to: "Перник",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:30",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "3637",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:40",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "2627",
            to: "Варна",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:45",
            isAboutToLeave: false,
            hasLeft: false
        ),
        .init(
            type: "БВ",
            number: "8627",
            to: "Бургас",
            from: nil,
            isOperating: false,
            delayMinutes: nil,
            arrival: nil,
            hasArrived: false,
            departure: "22:55",
            isAboutToLeave: false,
            hasLeft: false
        )
    ]
}
