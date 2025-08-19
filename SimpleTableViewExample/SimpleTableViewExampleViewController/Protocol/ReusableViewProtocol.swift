//
//  ReusableViewProtocol.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import Foundation

protocol ReusableViewProtocol {
    static var identifier: String { get }
}

extension ReusableViewProtocol {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
