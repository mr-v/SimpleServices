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

    // as baseURLString setup valid URL otherwise tests not expecting error will fail
    private let baseURLString = "https://www.google.com/"
    private let emptyParameters = [String: Any]()

    func test_fetchParameters_200ProperJSON_CallsCompletionHandlerWithJSONObject() {
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: emptyParameters)
        stubRequest("GET", baseURLString).andReturn(200).withBody("{\"ok\":1}")

        service.fetch(emptyParameters) { result in
            self.expectation.fulfill()
            XCTAssertEqual(["ok": 1], result.data()!)
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func test_fetchParameters_200MalformedJSON_CallsCompletionHandlerWithError() {
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: emptyParameters)
        stubRequest("GET", baseURLString).andReturn(200).withBody("{1}")

        service.fetch(emptyParameters) { result in
            self.expectation.fulfill()
            XCTAssertTrue(result.isError())
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func test_fetchParameters_404_CallsCompletionHandlerWithError() {
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: emptyParameters)
        stubRequest("GET", baseURLString).andReturn(404)

        service.fetch(emptyParameters) { result in
            self.expectation.fulfill()
            XCTAssertTrue(result.isError())
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    // MARK: - Query formatting tests
    // note: creating query is encapsulated in the service,
    // as a workaround queries are tested with stub requests;
    // if query doesn't match expected stub it will fail after timeout

    func test_fetchParameters_QueryContainsDefaultParameters() {
        let parameters = stubRequestWithDefaultParameters()
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: parameters)

        service.fetch(emptyParameters) { result in
            self.expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    func test_fetchParameters_QueryContainsParameters() {
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: emptyParameters)
        let parameters = stubRequestWithParameters()

        service.fetch(parameters) { result in
            self.expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    func test_FetchJSON_QueryIsPercentEncoded() {
        let service = makeJSONWebService(baseURLString: baseURLString, defaultParameters: emptyParameters)
        let parameters = stubRequestWithPercentEncodedParameters()

        service.fetch(parameters) { result in
            self.expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsWithTimeout(0.1, handler: nil)
    }

    // TODO: - add data validator

    // MARK: - HTTP stubs

    private func stubRequestWithDefaultParameters() -> [String: Any] {
        let parameters: [String: Any] = ["test": 2, "test2": 3]
        let query = "test2=3&test=2"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }

    private func stubRequestWithParameters() -> [String: Any] {
        let parameters: [String: Any] = ["custom": 2, "custom2": 3]
        let query = "custom2=3&custom=2"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }

    private func stubRequestWithPercentEncodedParameters() -> [String: Any] {
        let parameters: [String: Any] = ["custom": "  ą"]
        let query = "custom=%20%20%C4%85"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }
}
