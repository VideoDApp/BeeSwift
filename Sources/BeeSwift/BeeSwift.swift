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

    public func getUploadUrl(defaultpath: String? = nil) -> URL {
        var url = URL(string: self.nodeUrl)!
        url.appendPathComponent("bzz:/")
        let queryItems = [URLQueryItem(name: "defaultpath", value: defaultpath)]
        var urlComps = URLComponents(string: url.absoluteString)!
        if defaultpath != nil {
            urlComps.queryItems = queryItems
        }

        return urlComps.url!
    }

    public func download(hash: String, path: String = "") -> DownloadRequest {
        return AF.download(self.getDownloadUrl(hash: hash, path: path))
    }

    public func upload(_ data: Data, defaultpath: String?) -> UploadRequest {
        return AF.upload(data, to: self.getUploadUrl(defaultpath: defaultpath))
    }
}
