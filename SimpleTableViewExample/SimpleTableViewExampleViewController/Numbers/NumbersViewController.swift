//
//  NumberViewController.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit
import RxSwift
import SnapKit

final class NumbersViewController: BaseViewController {

    private let firstNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)
        textField.textAlignment = .right
        textField.textColor = .black
        textField.borderStyle = .line
        return textField
    }()

    private let secondNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)
        textField.textAlignment = .right
        textField.textColor = .black
        textField.borderStyle = .line
        return textField
    }()

    private let thirdNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12)
        textField.textAlignment = .right
        textField.textColor = .black
        textField.borderStyle = .line
        return textField
    }()

    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    private let operatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "+"
        label.textColor = .black
        return label
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .right
        label.text = ""
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        [firstNumberTextField, secondNumberTextField, thirdNumberTextField, underLine, resultLabel, operatorLabel].forEach { view.addSubview($0) }
    }

    override func configureConstraints() {

        [firstNumberTextField, secondNumberTextField, thirdNumberTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(160)
            }
        }

        firstNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(40)
            make.width.equalTo(160)
        }

        secondNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNumberTextField.snp.bottom).offset(4)
            make.centerX.equalTo(firstNumberTextField)
            make.size.equalTo(firstNumberTextField)
        }

        thirdNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(secondNumberTextField.snp.bottom).offset(4)
            make.centerX.equalTo(firstNumberTextField)
            make.size.equalTo(secondNumberTextField)
        }

        underLine.snp.makeConstraints { make in
            make.top.equalTo(thirdNumberTextField.snp.bottom).offset(4)
            make.centerX.equalTo(firstNumberTextField)
            make.height.equalTo(1)
            make.width.equalTo(firstNumberTextField)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(underLine).offset(4)
            make.trailing.equalTo(firstNumberTextField)

        }

        operatorLabel.snp.makeConstraints { make in
            make.trailing.equalTo(thirdNumberTextField.snp.leading).offset(-4)
            make.centerY.equalTo(thirdNumberTextField)
        }
    }

    private func bind() {
        Observable.combineLatest(firstNumberTextField.rx.text.orEmpty,
                                 secondNumberTextField.rx.text.orEmpty,
                                 thirdNumberTextField.rx.text.orEmpty)
        .skip(2)
        .map { first, second, third -> Int in
            let firstValue = Int(first) ?? 0
            let secondValue = Int(second) ?? 0
            let thirdValue = Int(third) ?? 0
            return firstValue + secondValue + thirdValue
        }
        .bind(with: self, onNext: { owner, value in
            owner.resultLabel.text = "\(value)"
        })
        .disposed(by: disposeBag)
    }

//    private func bindTest() {
//        Observable.combineLatest(
//            firstNumberTextField.rx.text.orEmpty.map { Int($0) ?? 0 },
//            secondNumberTextField.rx.text.orEmpty.map { Int($0) ?? 0 },
//            thirdNumberTextField.rx.text.orEmpty.map { Int($0) ?? 0 }
//        )
//        .map { ($0 + $1 + $2) }
//        .bind(with: self) { owner, result in
//            owner.resultLabel.text = "\(result)"
//        }
//        .disposed(by: disposeBag)
//    }
}

