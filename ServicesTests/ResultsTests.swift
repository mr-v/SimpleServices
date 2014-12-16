//
//  ResultsTests.swift
//  Services
//
//  Created by Witold Skibniewski on 16/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Services
import XCTest

class ResultsTests: XCTestCase {

    func test_isError_ErrorResult_ReturnsTrue() {
        let result: Result<Any> = .Error

        XCTAssertTrue(result.isError())
    }

    func test_isError_OK_ReturnsFalse() {
        let result: Result = .OK(25)

        XCTAssertTrue(result.isOK())
    }

    func test_isOK_Error_ReturnsFalse() {
        let result: Result<Any> = .Error

        XCTAssertFalse(result.isOK())
    }

    func test_isOK_OK_ReturnsTrue() {
        let result: Result = .OK(25)

        XCTAssertTrue(result.isOK())
    }

    func test_data_OK_ReturnsValue() {
        let result: Result = .OK(25)

        XCTAssertEqual(25, result.data()!)
    }

    func test_data_Error_ReturnsNil() {
        let result: Result<AnyObject> = .Error

        XCTAssertNil(result.data()?)
    }
}
