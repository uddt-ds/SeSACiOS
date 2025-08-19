//
//  BaseViewController.swift
//  SimpleTableViewExampleViewController
//
//  Created by Lee on 8/19/25.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    private(set) var didSetupConstraints = false

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.setNeedsUpdateConstraints()
        configureHierarchy()
    }

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            configureConstraints()
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func configureConstraints() {

    }

    func configureHierarchy() {

    }

}
