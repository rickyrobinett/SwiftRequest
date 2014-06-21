# SwiftRequest
============


## Sample GET Request
```swift
var swiftRequest = SwiftRequest()

swiftRequest.get(url: "http://news.ycombinator.com", {err, response, body in
                if( !err ) { 
                  println(body)
                }
            })
```

## Sample POST Request
```swift
var swiftRequest = SwiftRequest()

var data = [
    "Name" : "Ricky",
    "Favorite Band" : "Refused",
    "Age" : "29"
]

swiftRequest.post("http://requestb.in/ukfc8euk", payload: data, {err, response, body in
        if( !err ) {
            println(body)
        }
    })
```

## Sample GET image
```swift
var swiftRequest = SwiftRequest()

swiftRequest.get("http://graphics8.nytimes.com/images/2013/02/22/nyregion/KENTILE-01/KENTILE-01-articleLarge.jpg", {err, response, body in
                println(body)
                var image = UIImage(data: body as NSData)
                self.imageView.image = image
            })

```
