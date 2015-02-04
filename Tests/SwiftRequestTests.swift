//
//  SwiftRequestTests.swift
//  SwiftRequestTests
//
//  Created by Ricky Robinett on 6/20/14.
//  Copyright (c) 2014 Ricky Robinett. All rights reserved.
//

import XCTest

class SwiftRequestTests: XCTestCase {
    var swiftRequest = SwiftRequest()
    
    func testGet() {
        var expectation = expectationWithDescription("Testing Async Get");
        swiftRequest.get("http://news.ycombinator.com", callback: {err, response, body  in
            XCTAssertNotNil(response, "Response should not be nil" )
            XCTAssertNotNil(body, "Body should not be nil" )
            XCTAssertNil( err, "Should not receive an error" )
            
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { (error) in
            if(error != nil) { XCTFail("Test timed out") }
        }

    }
    
    func testGetWithParams() {
        var expectation = expectationWithDescription("Testing Async Get");

        swiftRequest.get("http://pokeapi.co/api/v1/pokemon/", params: [ "limit" : "5" ], callback: {err, response, body in
            XCTAssertNotNil(response, "Response should not be nil" )
            XCTAssertNotNil(body, "Body should not be nil" )
            XCTAssertNil( err, "Should not receive an error" )
            
            expectation.fulfill()
        })
        
        
        waitForExpectationsWithTimeout(10) { (error) in
            if(error != nil) { XCTFail("Test timed out") }
        }
    }
    
    func testGet404() {
        var expectation = expectationWithDescription("Testing Async Get 404");

        swiftRequest.get("http://httpstat.us/404", callback: {err, response, body in
            XCTAssert(response!.statusCode == 404, "Response code should be 404" )
            
            expectation.fulfill()
        })
        
        
        waitForExpectationsWithTimeout(10) { (error) in
            if(error != nil) { XCTFail("Test timed out") }
        }
    }
    
    func testPost() {
        var expectation = expectationWithDescription("Testing Async Post");

        swiftRequest.post("http://httpbin.org/post", data: ["test":"test"], callback: {err, response, body in
            XCTAssertNotNil(response, "Response should not be nil" )
            XCTAssertNotNil(body, "Body should not be nil" )
            XCTAssertNil( err, "Should not receive an error" )
            
            expectation.fulfill()
        })
        
        
        waitForExpectationsWithTimeout(10) { (error) in
            if(error != nil) { XCTFail("Test timed out") }
        }
    }
    
    
    
}
