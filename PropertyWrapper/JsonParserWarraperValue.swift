//
//  JsonParserWarraperValue.swift
//  PropertyWrapper
//
//  Created by Ibrahim Mo Gedami on 1/21/24.
//

import Foundation

typealias JSONDictionary = [String: AnyObject] // [[String: Any?]]

@propertyWrapper
struct JSONValueWrapper<T> {
    
    var wrappedValue: T?

    init(from json: JSONDictionary?, forKey key: String) {
        guard let jsonValue = json?[key] as? T else {
            self.wrappedValue = nil
            return
        }
        self.wrappedValue = jsonValue
    }
    
}
