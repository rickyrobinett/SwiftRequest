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
    }
    
    // Do these convenience methods even make sense? I don't think we need them
    convenience init(url: String) {
        self.init()
        makeRequest(["url" : url ] )
    }
    
    convenience init(url: String, callback: (err: NSError?, response: AnyObject?, body: AnyObject?)->()) {
        self.init()
        makeRequest(["url" : url ], callback: callback )
    }
    
    func get(url: String, callback: (err: NSError?, response: AnyObject?, body: AnyObject?)->()) {
        makeRequest(["url" : url ], callback: callback )
    }
    
    func post(url: String, callback: (err: NSError?, response: AnyObject?, body: AnyObject?)->()) {
        post(url, payload: Dictionary(), callback)
    }
    
    func post(url: String, payload: Dictionary<String, String>, callback: (err: NSError?, response: AnyObject?, body: AnyObject?)->()) {
        var qs = ""
        for (key, value) in payload {
            qs += "\(key)=\(value)&"
        }
        makeRequest(["url": url, "method" : "POST", "body" : qs] , callback)
    }
    
    func post(url: String, payload: Dictionary<String, String>, auth: Dictionary<String, String>, callback: (err: NSError?, response: AnyObject?, body: AnyObject?)->()) {
        var qs = ""
        for (key, value) in payload {
            qs += "\(key)=\(value)&"
        }
        makeRequest(["url": url, "method" : "POST", "body" : qs, "auth" : auth] , callback)
    }
    
    func makeRequest(options: Dictionary<String, Any>, callback: ((err: NSError?, response: NSURLResponse?, body: AnyObject?)->())?) {
        if( !options["url"] ) { return }
        var url = NSURL.URLWithString(options["url"] as String)
        var urlRequest = NSMutableURLRequest(URL: url)
        
        if( options["method"]) {
            urlRequest.HTTPMethod = options["method"] as String
        }
        
        if( options["body"]) {
            var postData = (options["body"] as String).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
            urlRequest.HTTPBody = postData
            urlRequest.setValue("\(postData.length)", forHTTPHeaderField: "Content-length")
        }
        
        // is there a more efficient way to do this?
        if( options["auth"] ) {
            var auth = options["auth"] as Dictionary<String,String>
            var username = auth["username"]
            var password = auth["password"]
            var authEncoded = "\(username):\(password)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true).base64Encoding()
            var authValue = "Basic \(authEncoded)"
            urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: {body, response, err in
            var bodyStr = NSString(data: body, encoding:NSUTF8StringEncoding)
            callback!(err: err, response: response, body: bodyStr)
        })
        
        task.resume()
    }
    
    func makeRequest(options: Dictionary<String, Any>) {
        makeRequest(options, callback: nil)
    }

}

