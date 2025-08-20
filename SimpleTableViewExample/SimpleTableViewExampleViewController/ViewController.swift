//
//  ViewController.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/20/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ViewController: UIViewController {

    var disposeBag = DisposeBag()

    let tableViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("tableView", for: .normal)
        button.backgroundColor = .black
        return button
    }()

    let numbersViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("numbersView", for: .normal)
        button.backgroundColor = .black
        return button
    }()

    let validationViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("validation", for: .normal)
        button.backgroundColor = .black
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableViewButton, numbersViewButton, validationViewButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureStackSubViewLayout()
        configureLayout()
        bind()
    }

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(buttonStackView)
    }

    private func configureStackSubViewLayout() {
        [tableViewButton, numbersViewButton, validationViewButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(200)
                make.height.equalTo(40)
            }
        }
    }

    private func configureLayout() {
        buttonStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bind() {
        tableViewButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SimpleTableViewExampleViewController()
                vc.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        numbersViewButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = NumbersViewController()
                vc.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)

        validationViewButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = SimpleValidationViewController()
                vc.navigationItem.backButtonTitle = ""
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }

}
