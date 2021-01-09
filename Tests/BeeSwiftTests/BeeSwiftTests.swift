import XCTest
import Alamofire
import CryptoKit
@testable import BeeSwift

enum TestError: Error {
    case randomDataIncorrect
}

final class BeeSwiftTests: XCTestCase {
    public func randomData(ofLength length: Int) throws -> Data {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(bytes)
        }

        throw TestError.randomDataIncorrect
    }

    func testUrlContructor() {
        let url = "https://swarm-gateways.net/bzz:/0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d/AndroidFileTransfer.dmg"
        let bee = BeeSwift()
        bee.setNodeUrl(url: "https://swarm-gateways.net")
        var createdUrl = bee.getDownloadUrl(hash: "0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d", path: "AndroidFileTransfer.dmg").absoluteString
        XCTAssertEqual(createdUrl, url, "Url should be equal. Example 1")

        bee.setNodeUrl(url: "https://swarm-gateways.net/")
        createdUrl = bee.getDownloadUrl(hash: "0a4c5bb36b6bc104970741b8734de29e45d874dab7e368e96b0633306139577d", path: "AndroidFileTransfer.dmg").absoluteString
        XCTAssertEqual(createdUrl, url, "Url should be equal. Example 2")

        createdUrl = bee.getUploadUrl(defaultpath: "hello.txt").absoluteString
        XCTAssertEqual(createdUrl, "https://swarm-gateways.net/bzz:/?defaultpath=hello.txt", "Url should be equal. Example 3")

        createdUrl = bee.getUploadUrl().absoluteString
        XCTAssertEqual(createdUrl, "https://swarm-gateways.net/bzz:/", "Url should be equal. Example 4")
    }

    func testUploadAndDownload() {
        continueAfterFailure = false
        
        let bee = BeeSwift("https://swarm-gateways.net/")
        let exampleData = try! self.randomData(ofLength: 1000000)
        let dataHash = SHA256.hash(data: exampleData)
//        print("data hash \(dataHash)")
        var hash: String?
        var exp = expectation(description: "UploadData")
        bee.upload(exampleData, defaultpath: "hello.mp4")
            .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
            .responseString { response in
//            print("response.value --- \(response.value)")
            XCTAssertEqual(response.value?.count, 64, "Incorrect hash size")
            hash = response.value!
            exp.fulfill()
        }
        waitForExpectations(timeout: 60)


        print("DownloadData start")
        exp = expectation(description: "DownloadData")
        bee.download(hash: hash!, path: "hello.mp4")
            .downloadProgress { progress in
            print("Download test file progress: \(progress.fractionCompleted)")
        }
            .responseData { response in
            XCTAssertEqual(response.value?.count, 1000000, "Incorrect file size")
            XCTAssertEqual(SHA256.hash(data: response.value!), dataHash, "Incorrect file hash")
            exp.fulfill()
        }

        waitForExpectations(timeout: 60)
    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
