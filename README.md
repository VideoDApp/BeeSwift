# BeeSwift

Ethereum Swarm (Bee) web-client implementation.

Protocol description: https://swarm-gateways.net/bzz:/docs.swarm.eth/docs/

## Installation

In XCode click: File -> Swift Packages -> Add Package Dependency

Enter repo url: https://github.com/VideoDApp/BeeSwift.git

## Using
```swift
// define here public gateways or your node url
let bee = BeeSwift("https://swarm-gateways.net")

// set content data to exampleData and then you can upload data
// upload
bee.upload(exampleData, defaultpath: "hello.mp4")
.uploadProgress { progress in
    print("Upload Progress: \(progress.fractionCompleted)")
}
.responseString { response in
    print("Uploaded file/data hash: \(response.value!)")
}

// download
bee.download(hash: hash, path: "hello.mp4")
.downloadProgress { progress in
    print("Download test file progress: \(progress.fractionCompleted)")
}
.responseData { response in
    print("Binary data here: \(response.value!)")
}
```
