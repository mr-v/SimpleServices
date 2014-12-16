//
//  ServiceType.swift
//  ServicesTest
//
//  Created by Witold Skibniewski on 13/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

protocol ServiceType {
    typealias T
    func fetch(parameters: [String: Any], completionHandler: Result<T> -> ()) // cancellable
    func fetch(URL: NSURL, completionHandler: Result<T> -> ())
    func fetch(URLString: String, completionHandler: Result<T> -> ())
}
