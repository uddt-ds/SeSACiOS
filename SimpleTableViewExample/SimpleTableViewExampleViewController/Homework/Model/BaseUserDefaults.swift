//
//  BaseUserDefaults.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/20/25.
//

import Foundation

@propertyWrapper
struct BaseUserDefaults<T: Codable> {

    let key: String
    let defaultValue: T
    let storage = UserDefaults.standard

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            if let data = storage.data(forKey: key) {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return decodedData
                } catch {
                    print("fail Decoding")
                }
            }
            return defaultValue
        }
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                storage.set(encodedData, forKey: key)
            } catch {
                print("fail Encoding")
            }
        }
    }
}

enum UserDefaultsKey: String {
    case likeList
}
