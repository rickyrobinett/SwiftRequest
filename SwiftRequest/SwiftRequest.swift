//
//  SwiftRequest.swift
//  SwiftRequestTest
//
//  Created by Ricky Robinett on 6/20/14.
//  Copyright (c) 2014 Ricky Robinett. All rights reserved.
//

import Foundation

class SwiftRequest {
    var session = NSURLSession.sharedSession()
    
    init() {
        // we should probably be preparing something here...
    }
    
    // GET requests
    func get(url: String, auth: Dictionary<String, String> = Dictionary<String, String>(), params: Dictionary<String, String> = Dictionary<String, String>(), callback: ((err: NSError?, response: NSURLResponse?, body: AnyObject?)->())? = nil) {
        var qs = ""
        for (key, value) in params {
            qs += "\(key)=\(value)&"
        }
        request(["url" : url, "auth" : auth, "querystring": qs ], callback: callback )
    }
    
    // POST requests
    func post(url: String, payload: Dictionary<String, String> = Dictionary<String, String>(), auth: Dictionary<String, String> = Dictionary<String, String>(), callback: ((err: NSError?, response: NSURLResponse?, body: AnyObject?)->())? = nil) {
        var qs = ""
        for (key, value) in payload {
            qs += "\(key)=\(value)&"
        }
        request(["url": url, "method" : "POST", "body" : qs, "auth" : auth] , callback)
    }
    
    // Actually make the requests
    func request(options: Dictionary<String, Any>, callback: ((err: NSError?, response: NSURLResponse?, body: AnyObject?)->())?) {
        if( !options["url"] ) { return }
        
        var urlString = options["url"] as String
        if( options["querystring"] && (options["querystring"] as String) != "" ) {
            var qs = options["querystring"] as String
            urlString = "\(urlString)?\(qs)"
        }
        
        var url = NSURL.URLWithString(urlString)
        var urlRequest = NSMutableURLRequest(URL: url)
        
        if( options["method"]) {
            urlRequest.HTTPMethod = options["method"] as String
        }
        
        if( options["body"] && options["body"] as String != "" ) {
            var postData = (options["body"] as String).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            urlRequest.HTTPBody = postData
            urlRequest.setValue("\(postData!.length)", forHTTPHeaderField: "Content-length")
        }
        
        // is there a more efficient way to do this?
        if( options["auth"] && (options["auth"] as Dictionary<String,String>).count > 0) {
            var auth = options["auth"] as Dictionary<String,String>
            if( auth["username"] && auth["password"] ) {
                var username = auth["username"]
                var password = auth["password"]
                var authEncoded = "\(username!):\(password!)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
                println(authEncoded)
                var authValue = "Basic \(authEncoded!)"
                urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {body, response, err in
            // this is lame but want to not always send back NSData. Is it reasonable to intelligent about MIME types and send back a string when it makes sense?
            if(response.MIMEType == "text/html" || response.MIMEType == "application/json" ) {
                var bodyStr = NSString(data: body, encoding:NSUTF8StringEncoding)
                return callback!(err: err, response: response, body: bodyStr)
            }
            
            callback!(err: err, response: response, body: body)
        })
        
        task.resume()
    }
    
    func request(url: String, callback: ((err: NSError?, response: NSURLResponse?, body: AnyObject?)->())? = nil) {
        request(["url" : url ], callback: callback )
    }

}
