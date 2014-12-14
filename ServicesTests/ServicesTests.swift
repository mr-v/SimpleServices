//
//  ServicesTests.swift
//  ServicesTests
//
//  Created by Witold Skibniewski on 14/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest
import Services

class ServicesTests: XCTestCase {

    func test_test200() {
        stubRequest("", "google.com")
    }
}
