//
//  SimpleValidationViewModel.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

//input : textField 2개, 버튼 클릭 이벤트
//output: 결과 string

enum textFieldMessage: String {
    case name = "이름을 입력해주세요"
    case password = "비밀번호를 입력해주세요"
    case invalidName = "6글자 이상의 닉네임을 설정해주세요"
    case invalidPassword = "9글자 이상의 비밀번호를 설정해주세요"
}

final class SimpleValidationViewModel {

    var disposeBag = DisposeBag()

    struct Input {
        var nicknameTextField: ControlProperty<String>
        var passwordTextField: ControlProperty<String>
        var buttonTapped: ControlEvent<Void>
    }

    struct Output {
        var nicknameValidateResult: BehaviorSubject<String>
        var passwordValidateResult: BehaviorSubject<String>
        var validateResult: BehaviorSubject<String>
        var isFullInput: BehaviorSubject<Bool>
    }

    func transform(input: Input) -> Output {

        let resultText = BehaviorSubject(value: "")
        let isEnable = BehaviorSubject(value:false)

        let idText = BehaviorSubject(value: "")
        let pwText = BehaviorSubject(value: "")

        let idCheck = input.nicknameTextField
            .map { $0.count > ValidationRange.name.rawValue }
            .share(replay: 1)

        let passwordCheck = input.passwordTextField
            .map { $0.count > ValidationRange.password.rawValue }
            .share(replay: 1)

        let totalCheck = Observable.combineLatest(idCheck, passwordCheck)
            .map { $0 && $1 }
            .share(replay: 1)

        let nickNameTextField = input.nicknameTextField
            .map { $0.count > 1 }
            .map{ value in
                value ? "" : textFieldMessage.name.rawValue
            }
            .share(replay: 1)

        let passwordTextField = input.passwordTextField
            .map { $0.count > 1 }
            .map{ value in
                value ? "" : textFieldMessage.password.rawValue
            }
            .share(replay: 1)

        let idValidation = idCheck.map { $0 ? "" : textFieldMessage.invalidName.rawValue }

        let passwordValidation = passwordCheck.map { $0 ? "" : textFieldMessage.invalidPassword.rawValue }

        // Operator 학습을 위한 코드
        Observable.merge(nickNameTextField, passwordTextField, idValidation, passwordValidation)
            .bind(to: resultText)
            .disposed(by: disposeBag)

        nickNameTextField
            .bind(to: idText)
            .disposed(by: disposeBag)

        passwordTextField
            .bind(to: pwText)
            .disposed(by: disposeBag)

        totalCheck.bind(to: isEnable)
            .disposed(by: disposeBag)

        return Output(nicknameValidateResult: idText, passwordValidateResult: pwText, validateResult: resultText, isFullInput: isEnable)
    }

}

extension SimpleValidationViewModel {
    enum ValidationRange: Int {
        case name = 5
        case password = 8
    }
}
