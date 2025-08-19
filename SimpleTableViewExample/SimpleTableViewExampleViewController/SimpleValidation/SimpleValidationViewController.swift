//
//  SimpleValidationController.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleValidationViewController: BaseViewController {

    let nameHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.text = "nickname"
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = textFieldMessage.name.rawValue
        textField.textColor = .black
        textField.borderStyle = .line
        return textField
    }()

    let nameValidateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .red
        label.text = ""
        return label
    }()

    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameHeaderLabel, nameTextField, nameValidateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let passwordHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.text = "password"
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = textFieldMessage.password.rawValue
        textField.textColor = .black
        textField.borderStyle = .line
        return textField
    }()

    let passwordValidateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .red
        label.text = ""
        return label
    }()

    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordHeaderLabel, passwordTextField, passwordValidateLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .systemGray
        button.isEnabled = false

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackSubViewConstraints()
        bind()
    }

    override func configureHierarchy() {
        [nameStackView, passwordStackView, checkButton].forEach { view.addSubview($0) }
    }

    override func configureConstraints() {
        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        passwordStackView.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(300)
        }

        checkButton.snp.makeConstraints { make in
            make.top.equalTo(passwordStackView.snp.bottom).offset(12)
            make.height.equalTo(44)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func configureStackSubViewConstraints() {
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
    }

    private func bind() {

        let usernameCheck = nameTextField.rx.text.orEmpty
            .skip(1)
            .map { $0.count > ValidationRange.name.rawValue }
            .share()
            .share(replay: 1)

        let passwordCheck = passwordTextField.rx.text.orEmpty
            .skip(1)
            .map { $0.count > ValidationRange.password.rawValue }
            .share(replay: 1)

        let totalCheck = Observable.combineLatest(usernameCheck, passwordCheck) { $0 && $1 }
            .share(replay: 1)

        usernameCheck
            .bind(to: nameValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)

        usernameCheck
            .bind(with: self) { owner, value in
                owner.nameValidateLabel.text = value ? "" : "6글자 이상의 닉네임을 설정해주세요"
            }
            .disposed(by: disposeBag)

        usernameCheck
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)

        passwordCheck
            .bind(to: passwordValidateLabel.rx.isHidden)
            .disposed(by: disposeBag)

        passwordCheck
            .bind(with: self) { owner, value in
                owner.passwordValidateLabel.text = value ? "" : "9글자 이상의 비밀번호를 설정해주세요"
            }
            .disposed(by: disposeBag)

        totalCheck
            .bind(to: checkButton.rx.isEnabled)
            .disposed(by: disposeBag)

        totalCheck
            .bind(with: self) { owner, value in
                owner.checkButton.backgroundColor = value ? .systemGreen : .systemGray
            }
            .disposed(by: disposeBag)

        checkButton.rx.tap
            .map { "확인되었습니다" }
            .bind(with: self) { owner, message in
                owner.showAlert(message: message)
            }
            .disposed(by: disposeBag)


// MARK: Zip 방식
        /*
         zip의 경우
         유저가 name에 123456 을 입력하고
         password에 123456789를 입력해서 조건에 통과해도 false임
         한번 사용한 이벤트는 이미 쌍으로 처리되어 없어지고,
         만약 zip으로 성공 조건을 타려면 name을 하나 더 입력하게 해서 Emit이 다시 이루어져야 true 처리가 됨
         */

//        Observable.zip(usernameCheck, passwordCheck)
//            .map { $0.0 && $0.1 }
//            .bind(with: self) { owner, value in
//                print(value)
//                owner.checkButton.isEnabled = value
//            }
//            .disposed(by: disposeBag)

// MARK: Merge 방식
//        let nameCheck = nameTextField.rx.text.orEmpty
//            .map { $0.count > 5 }
//
//        let passwordCheck = passwordTextField.rx.text.orEmpty
//            .map { $0.count > 8 }
//
//
//        // merge하면 name이 조건에 맞으면, 비밀번호 조건에 타기 전까지는 true로 return함
//        Observable.merge(nameCheck, passwordCheck)
//            .bind(with: self) { owner, value in
//                print(value)
//            }
//            .disposed(by: disposeBag)
    }
}

extension SimpleValidationViewController {
    enum textFieldMessage: String {
        case name = "이름을 입력해주세요"
        case password = "비밀번호를 입력해주세요"
    }

    enum ValidationRange: Int {
        case name = 5
        case password = 8
    }
}

extension SimpleValidationViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
