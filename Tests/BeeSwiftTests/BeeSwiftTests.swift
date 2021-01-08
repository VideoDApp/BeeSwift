import XCTest
import Alamofire
@testable import BeeSwift

final class BeeSwiftTests: XCTestCase {
    func testUrlContructor() {
        let url = "https://swarm-gateways.net/bzz:/0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d/AndroidFileTransfer.dmg"
        let bee = BeeSwift()
        bee.setNodeUrl(url: "https://swarm-gateways.net")
        var createdUrl = bee.getDownloadUrl(hash: "0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d", path: "AndroidFileTransfer.dmg").absoluteString
        XCTAssertEqual(createdUrl, url, "Url should be equal. Example 1")

        bee.setNodeUrl(url: "https://swarm-gateways.net/")
        createdUrl = bee.getDownloadUrl(hash: "0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d", path: "AndroidFileTransfer.dmg").absoluteString
        XCTAssertEqual(createdUrl, url, "Url should be equal. Example 1")
    }

    func testUploadAndDownload() {
        // download simple file, check size, store hash
        // upload swarm file, wait, download, check size/hash
        
        let bee = BeeSwift("https://swarm-gateways.net/")
        // download example file
        var exp = expectation(description: "DownloadExampleData")
        var exampleData: Data?
        // todo create dynamic file (as additinoal test?)
        AF.download("https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4")
            .responseData { response in
                // todo break test?
            XCTAssertNotNil(response.value, "No data was downloaded")
            XCTAssertEqual(response.value!.count, 1570024, "Incorrect file size")
            exampleData = response.value
            exp.fulfill()
        }

        waitForExpectations(timeout: 60)

//        exp = expectation(description: "UploadExampleData")
//        bee.upload()
//        waitForExpectations(timeout: 60)

        exp = expectation(description: "UploadAndDownload")
        
        bee.download(hash: "0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d", path: "AndroidFileTransfer.dmg")
            .responseData { response in
            XCTAssertNotNil(response.value, "No data was downloaded")
            exp.fulfill()
        }

        waitForExpectations(timeout: 60)
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
