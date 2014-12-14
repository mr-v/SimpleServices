//
//  NocillaTestCase.swift
//  Services
//
//  Created by Witold Skibniewski on 14/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class NocillaTestCase: XCTestCase {

    var expectaction: XCTestExpectation!

    override class func setUp() {
        super.setUp()
        LSNocilla.sharedInstance().start()
    }

    override class func tearDown() {
        super.tearDown()
        LSNocilla.sharedInstance().stop()
    }

    override func setUp() {
        super.setUp()
//        expectaction = expectationWithDescription("")
    }

    override func tearDown() {
        super.tearDown()
        expectaction = nil
        LSNocilla.sharedInstance().clearStubs()
    }
}
