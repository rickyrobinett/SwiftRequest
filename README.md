# SwiftRequest
============

SwiftRequest is a simple HTTP client for Swift. It was inspired by the [Node.js Request library](https://github.com/mikeal/request) and [Python Requests](http://docs.python-requests.org/en/latest/).

```swift
var swiftRequest = SwiftRequest()

swiftRequest.get(url: "https://en.wikipedia.org/wiki/Brooklyn", callback: {err, response, body in
  if( !err ) {
    println(body)
  }
})
```

## Getting Started

### GET Requests

#### Simple GET Request
```swift
var swiftRequest = SwiftRequest()

swiftRequest.get(url: "http://news.ycombinator.com", callback: {err, response, body in
  if( !err ) { 
    println(body)
  }
})
```

#### GET Request with Parameters
```swift
swiftRequest.get("http://pokeapi.co/api/v1/pokemon/", params: ["limit":"5"], callback: {err, response, body in
  if( !err ) {
    println(body)
  }
})
```

#### GET Request with Authentication
```swift
swiftRequest.get("https://api.github.com/user", auth: ["username" : "user", "password" : "pass"],callback: {err, response, body in
println(body)
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

swiftRequest.post("http://requestb.in/ukfc8euk", payload: data, callback: {err, response, body in
  if( !err ) {
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
