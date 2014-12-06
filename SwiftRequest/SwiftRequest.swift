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
    public func get(url: String, auth: [String: String] = [String: String](), params: [String: String] = [String: String](), callback: ((err: NSError?, response: NSHTTPURLResponse?, body: AnyObject?)->())? = nil) {
        var qs = dictToQueryString(params)
        request(["url" : url, "auth" : auth, "querystring": qs ], callback: callback )
    }
    
    // POST requests
    public func post(url: String, data: [String: String] = [String: String](), auth: [String: String] = [String: String](), callback: ((err: NSError?, response: NSHTTPURLResponse?, body: AnyObject?)->())? = nil) {
        var qs = dictToQueryString(data)
        request(["url": url, "method" : "POST", "body" : qs, "auth" : auth] , callback)
    }
    
    // Actually make the requests
    public func request(options: [String: Any], callback: ((err: NSError?, response: NSHTTPURLResponse?, body: AnyObject?)->())?) {
        if( options["url"] == nil ) { return }
        
        var urlString = options["url"] as String
        if( options["querystring"] != nil && (options["querystring"] as String) != "" ) {
            var qs = options["querystring"] as String
            urlString = "\(urlString)?\(qs)"
        }
        
        var url = NSURL(string:urlString)
        var urlRequest = NSMutableURLRequest(URL: url!)
        
        if( options["method"] != nil) {
            urlRequest.HTTPMethod = options["method"] as String
        }
        
        if( options["body"] != nil && options["body"] as String != "" ) {
            var postData = (options["body"] as String).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            urlRequest.HTTPBody = postData
            urlRequest.setValue("\(postData!.length)", forHTTPHeaderField: "Content-length")
        }
        
        // is there a more efficient way to do this?
        if( options["auth"] != nil && (options["auth"] as [String: String]).count > 0) {
            var auth = options["auth"] as [String: String]
            if( auth["username"] != nil && auth["password"] != nil ) {
                var username = auth["username"]
                var password = auth["password"]
                var authEncoded = "\(username!):\(password!)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros);
                println(authEncoded)
                var authValue = "Basic \(authEncoded)"
                urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
            }
        }
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {body, response, err in
            // this is lame but want to not always send back NSData. Is it reasonable to intelligent about MIME types and send back a string when it makes sense?
            var resp = response as NSHTTPURLResponse
            if( err == nil) {
                if(response.MIMEType == "text/html" || response.MIMEType == "application/json" ) {
                    var bodyStr = NSString(data: body, encoding:NSUTF8StringEncoding)
                    return callback!(err: err, response: resp, body: bodyStr)
                }
            }
            
            callback!(err: err, response: resp, body: body)
        })
        
        task.resume()
    }
    
    public func request(url: String, callback: ((err: NSError?, response: NSHTTPURLResponse?, body: AnyObject?)->())? = nil) {
        request(["url" : url ], callback: callback )
    }

    private func dictToQueryString(data: [String: String]) -> String {
        var qs = ""
        for (key, value) in data {
            qs += "\(key)=\(value)&"
        }
        return qs
    }
}
