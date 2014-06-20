# SwiftRequest
============


## Sample GET Request
```swift
var request = SwiftRequest()

request.get(url: "http://news.ycombinator.com", {err, response, body in
                if( !err ) { 
                  println(body)
                }
            })
```

## Sample POST Request
```swift
var request = SwiftRequest()

var data = [
    "Name" : "Ricky",
    "Favorite Band" : "Refused",
    "Age" : "29"
]

request.post("http://requestb.in/ukfc8euk", payload: data, {err, response, body in
        if( !err ) {
            println(body)
        }
    })
```
