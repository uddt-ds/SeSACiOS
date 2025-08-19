//
//  BaseTableViewCell.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureConstraints()
        configureView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureHierarchy() {

    }

    func configureConstraints() {

    }

    func configureView() {

    }

}
