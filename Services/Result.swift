//
//  Result.swift
//  Services
//
//  Created by Witold Skibniewski on 16/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// based on: http://doc.rust-lang.org/std/result/

public enum Result<T> {
    case OK(T)
    case Error

    public func isOK() -> Bool {
        switch self {
        case .OK(_):    return true
        case .Error:    return false
        }
    }

    public func isError() -> Bool {
        switch self {
        case .Error:    return true
        case .OK(_):    return false
        }
    }

    public func data() -> T? {
        switch self {
        case .OK(let value): return value
        case .Error:        return nil
        }
    }
}
