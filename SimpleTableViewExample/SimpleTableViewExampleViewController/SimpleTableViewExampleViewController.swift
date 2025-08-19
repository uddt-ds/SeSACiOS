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

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureHierarchy() {
        [tableView].forEach { view.addSubview($0) }
    }

    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


