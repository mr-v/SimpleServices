//
//  Serializers.swift
//  ServicesTest
//
//  Created by Witold Skibniewski on 13/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

public protocol DeserializerType {
    func deserialize(data: NSData) -> Any?
}

class JSONDeserializer: DeserializerType {
    private var errorPointer: NSErrorPointer

    init(errorPointer: NSErrorPointer) {
        self.errorPointer = errorPointer
    }

    func deserialize(data: NSData) -> Any? {
        return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: errorPointer) as? NSDictionary
    }
}

class ImageDeserializer: DeserializerType {

    func deserialize(data: NSData) -> Any? {
        return UIImage(data: data)
    }
}
