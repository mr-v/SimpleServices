//
//  XCTestCase+Extension.swift
//  Services
//
//  Created by Witold Skibniewski on 14/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import XCTest

extension XCTestCase {
    func waitForExpectationsAndFailAfterTimeout(timeout: NSTimeInterval) {
        waitForExpectationsWithTimeout(timeout) { _ in XCTFail() }
    }
}
