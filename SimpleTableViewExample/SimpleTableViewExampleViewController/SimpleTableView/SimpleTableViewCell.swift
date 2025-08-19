//
//  SimpleTableViewCell.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit
import SnapKit

final class SimpleTableViewCell: BaseTableViewCell, ReusableViewProtocol {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    override func configureHierarchy() {
        [titleLabel].forEach { contentView.addSubview($0)}
    }

    override func configureConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func configureView() {
        accessoryType = .detailButton
    }
}
