//
//  ServiceType.swift
//  ServicesTest
//
//  Created by Witold Skibniewski on 13/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

public enum Result<T> {
    case OK(T)
    case Error

    public func isOK() -> Bool {
        switch self {
        case .OK(_):    return true
        default:        return false
        }
    }

    public func isError() -> Bool {
        switch self {
        case .Error:    return true
        default:        return false
        }
    }
}

protocol ServiceType {
    typealias T
    func fetch(parameters: [String: Any], completionHandler: Result<T> -> ()) // cancellable
    func fetch(URL: NSURL, completionHandler: Result<T> -> ())
    func fetch(URLString: String, completionHandler: Result<T> -> ())
}
