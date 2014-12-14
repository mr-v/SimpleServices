//
//  JSONWebServiceTests.swift
//  Services
//
//  Created by Witold Skibniewski on 14/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Services
import XCTest

class JSONWebServiceTests: NocillaTestCase {

    // as baseURLString we setup valid URL otherwise tests not expecting error will fail
    let baseURLString = "https://www.google.com/"

    // test name makes assertion message redundant
    func test_FetchParameters_200ProperJSON_CallsCompletionHandlerWithJSONObject() {
        // arrange
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: [String:Any]())
        // second parameter is LSMatchable: as of now it can be a string or regex, you're free to extend it and add other implementations of this protocol
        stubRequest("GET", baseURLString).andReturn(200).withBody("{\"ok\":true}")
        // act
        service.fetch(["is_it":"ok?"]) { result in
            self.expectaction.fulfill()

            // assert
            switch result {
            case .OK(let data): XCTAssertEqual(data, ["ok": 1])
            case .Error:        XCTFail()
            }
        }
        
        waitForExpectationsWithTimeout(1) { _ in XCTFail() }
    }
}
