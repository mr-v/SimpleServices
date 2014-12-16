//
//  WebServices.swift
//  ServicesTest
//
//  Created by Witold Skibniewski on 13/12/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

// created global factory methods to avoid calling it like: WebService<UIImage>.makeImageWebService() // where UIImage generic type would be ignored anyway
public func makeImageWebService() -> WebService<UIImage> {
    return WebService<UIImage>(baseURLString: "", defaultParameters: [String : Any](), deserializer: ImageDeserializer()) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let imageCache = NSURLCache(memoryCapacity:40 * 1024 * 1024, diskCapacity:50 * 1024 * 1024, diskPath:nil)
        configuration.URLCache = imageCache
        configuration.requestCachePolicy = .ReturnCacheDataElseLoad
        return NSURLSession(configuration: configuration)
    }
}

public func makeJSONWebService(#baseURLString: String, #defaultParameters: [String: Any]) -> WebService<NSDictionary> {
    return WebService<NSDictionary>(baseURLString: baseURLString,
        defaultParameters: defaultParameters,
        deserializer: JSONDeserializer(errorPointer: nil),
        makeSessionClosure: {
            let defaultConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
            // defaultConfiguration.requestCachePolicy = .ReturnCacheDataElseLoad
            return NSURLSession(configuration: defaultConfiguration)
    })
}


public class WebService<T>: ServiceType {


    private var dataValidator: Any!

    private let deserializer: DeserializerType
    private let session: NSURLSession!
    private let baseURLString: String
    private let defaultParameters = [String: Any]()

    private init(baseURLString: String, defaultParameters: [String: Any], deserializer: DeserializerType, makeSessionClosure: () -> NSURLSession) {
        self.baseURLString = baseURLString
        self.defaultParameters = defaultParameters
        self.deserializer = deserializer
        session = makeSessionClosure()
    }

    public func fetch(URLString: String, completionHandler: Result<T> -> ()) {
        if let URL = NSURL(string: URLString) {
            fetch(URL, completionHandler: completionHandler)
        } else {
            dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
        }
    }

    public func fetch(URL: NSURL, completionHandler: Result<T> -> ()) {
        let request = NSURLRequest(URL: URL)
        startTaskWithRequest(request, completionHandler: completionHandler)
    }

    public func fetch(parameters: [String: Any], completionHandler: Result<T> -> ()) { //-> Cancelable {
        let request = urlRequestWithParameters(parameters)
        startTaskWithRequest(request, completionHandler: completionHandler)
    }

    private func startTaskWithRequest(request: NSURLRequest, completionHandler: Result<T> -> ()) {
        let task = session.dataTaskWithRequest(request, completionHandler: {
            [weak self] data, urlResponse, error in
            func dispatchError() {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
            }

            if let taskError = error {
                if taskError.code != NSUserCancelledError {
                    dispatchError()
                }
                return
            }
            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    dispatchError()
                    return
                }
            }
            if let deserialized = self?.deserializer.deserialize(data) as? T {
                //            if !validate(deserialized)? {
                //                dispatchError()
                //                return
                //            }
                let result: Result = .OK(deserialized) // forced casting
                dispatch_async(dispatch_get_main_queue()) { completionHandler(result) }
            } else {
                dispatchError()
                return
            }
        })
        task.resume()
    }

    private func urlRequestWithParameters(parameters: [String: Any]) -> NSURLRequest {
        let components = NSURLComponents(string: baseURLString)!
        let mergedParameters = defaultParameters + parameters
        if !mergedParameters.isEmpty {
            components.queryItems = queryItemsWithParameters(mergedParameters)
        }
        let request = NSURLRequest(URL: components.URL!)
        return request
    }

    private func queryItemsWithParameters(parameters: [String: Any]) -> [NSURLQueryItem] {
        let keys = parameters.keys.array
        return keys.map { key in NSURLQueryItem(name: key, value: "\(parameters[key]!)") }
    }
}

// TODO: move it
private func + <K, V> (left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    var result = left
    for (k, v) in right {
        result.updateValue(v, forKey: k)
    }
    return result
}
