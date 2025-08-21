//
//  NumbersViewModel.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NumbersViewModel {

    var disposeBag = DisposeBag()

    struct Input {
        var firstNumberTextField: ControlProperty<String>
        var secondNumberTextField: ControlProperty<String>
        var thirdNumberTextField: ControlProperty<String>
    }

    struct Output {
        var calculateResult: BehaviorSubject<String>
    }

    func transform(input: Input) -> Output {

        let calculateResult = BehaviorSubject(value: "")

        Observable
            .combineLatest(input.firstNumberTextField.asObservable(),
                           input.secondNumberTextField.asObservable(),
                           input.thirdNumberTextField.asObservable())
            .map { first, second, third in
                let firstNum = Int(first) ?? 0
                let secondNum = Int(second) ?? 0
                let thirdNum = Int(third) ?? 0
                return String(firstNum + secondNum + thirdNum)
            }
            .bind(to: calculateResult)
            .disposed(by: disposeBag)

        return NumbersViewModel.Output(calculateResult: calculateResult)
    }
}
