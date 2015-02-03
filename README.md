# SwiftRequest

SwiftRequest is a simple HTTP client for Swift. It was inspired by the [Node.js Request library](https://github.com/mikeal/request) and [Python Requests](http://docs.python-requests.org/en/latest/).

```swift
var swiftRequest = SwiftRequest()

swiftRequest.get("https://en.wikipedia.org/wiki/Brooklyn", callback: {err, response, body in
  if( err == nil ) {
    println(body)
  }
})
```

## Installation

### Manual 

Drop the SwiftRequest folder into your Xcode project.

### CocoaPods

You can install SwiftRequest using [CocoaPods](http://cocoapods.org/).

Swift support is currently part of CocoaPods 0.36 beta. You can install it using the following command:
```
gem install cocoapods --pre
```

Add SwiftRequest to your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SwiftRequest', '0.0.3'
```

Install it by running:
```
pod install
```

Make sure you import SwiftRequest into any Swift files you're using it in with:
```
import SwiftRequest
```

## Getting Started

### GET Requests

#### Simple GET Request
```swift
var swiftRequest = SwiftRequest()

swiftRequest.get("http://news.ycombinator.com", callback: {err, response, body in
  if( err == nil ) { 
    println(body)
  }
})
```

#### GET Request with Parameters
```swift
swiftRequest.get("http://pokeapi.co/api/v1/pokemon/", params: ["limit":"5"], callback: {err, response, body in
  if( err == nil ) {
    println(body)
  }
})
```

#### GET Request with Authentication
```swift
swiftRequest.get("https://api.github.com/user", auth: ["username" : "user", "password" : "pass"],callback: {err, response, body in
    if( err == nil ) {
        println(body)
    }
})

```


### POST Requests
```swift
var swiftRequest = SwiftRequest()

var data = [
    "Name" : "Ricky",
    "Favorite Band" : "Refused",
    "Age" : "29"
]

swiftRequest.post("http://requestb.in/ukfc8euk", data: data, callback: {err, response, body in
  if( err == nil ) {
    println(body)
  }
})
```

### Sample GET image
```swift
var swiftRequest = SwiftRequest()

swiftRequest.get("http://graphics8.nytimes.com/images/2013/02/22/nyregion/KENTILE-01/KENTILE-01-articleLarge.jpg", {err, response, body in
  println(body)
  var image = UIImage(data: body as NSData)
  self.imageView.image = image
})

```
