//
//  UserModel.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/20/25.
//

import Foundation

struct UserModel: Codable {
    @BaseUserDefaults(key: UserDefaultsKey.likeList.rawValue, defaultValue: [])
    static var likeList: Set<String>
}

extension UserModel {
    static func updateLikeList(_ userId: String) {
        var currentData = likeList
        if currentData.contains(userId) {
            currentData.remove(userId)
        } else {
            currentData.insert(userId)
        }
        likeList = currentData
    }
}
