import Foundation
import Alamofire

public class BeeSwift {
    var nodeUrl = "http://localhost:1633"

    public init() {

    }

    public init(_ nodeUrl: String) {
        self.nodeUrl = nodeUrl
    }

    public func setNodeUrl(url: String) {
        self.nodeUrl = url
    }

    public func getNodeUrl() -> String {
        return self.nodeUrl
    }

    public func getDownloadUrl(hash: String, path: String = "") -> URL {
        var url = URL(string: self.nodeUrl)!
        url.appendPathComponent("bzz:/\(hash)/\(path)")

        return url
    }

    public func getUploadUrl(defaultpath: String?) -> URL {
        //https://swarm-gateways.net/bzz:/?defaultpath=%D0%AD%D1%80%D0%B4%D0%BE%D0%B3%D0%B0%D0%BD,_%D0%A0%D0%B5%D0%B4%D0%B6%D0%B5%D0%BF_%D0%A2%D0%B0%D0%B8%CC%86%D0%B8%D0%BF.html
        var url = URL(string: self.nodeUrl)!
        url.appendPathComponent("bzz:/")

        return url
    }

    public func download(hash: String, path: String = "") -> DownloadRequest {
        return AF.download(self.getDownloadUrl(hash: hash, path: path))
    }

    public func upload(data: Data, defaultpath: String?) -> UploadRequest {
        return AF.upload(data, to: self.getUploadUrl(defaultpath: defaultpath))
    }
}
