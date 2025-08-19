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


    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .black
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    override func configureHierarchy() {
        contentView.addSubview(labelStackView)
    }

    override func configureConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.directionalVerticalEdges.equalToSuperview().inset(4)
        }
    }
}
