//
//  ViewController.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewExampleViewController: BaseViewController {

    let data = Observable.just(
        (0..<20).map { "\($0)" }
    )

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.identifier)
        tableView.rowHeight = 60
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configureHierarchy() {
        [tableView].forEach { view.addSubview($0) }
    }

    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bind() {
        data.bind(to: tableView.rx.items(cellIdentifier: SimpleTableViewCell.identifier, cellType: SimpleTableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: disposeBag)


        tableView.rx.modelSelected(String.self)
            .compactMap { Int($0) }
            .map { $0 + 1 }
            .bind(with: self) { owner, value in
                owner.showAlert(message: "\(value)번째 셀이 눌렸습니다")
            }
            .disposed(by: disposeBag)

        tableView.rx.itemAccessoryButtonTapped
            .bind(with: self) { owner, value in
                owner.showAlert(message: "버튼이 눌렸습니다")
            }
            .disposed(by: disposeBag)
    }
}

extension SimpleTableViewExampleViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "확인", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
