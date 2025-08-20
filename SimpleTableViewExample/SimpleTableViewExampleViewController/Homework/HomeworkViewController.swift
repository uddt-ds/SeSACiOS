//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let profileImage: String
}

class HomeworkViewController: UIViewController {

    let viewModel = HomeworkViewModel()

    private var disposeBag = DisposeBag()
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()

        viewModel.input.viewDidLoadTrigger.onNext(())
    }

    private func bind() {

        viewModel.output.rawData
            .bind(to: tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { [weak self] (row, element, cell) in
                guard let self else { return }

                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = ViewController()
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

//                cell.buttonTapped = {
//                    let vc = ViewController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }

                viewModel.output.likeList
                    .bind(with: self.view) { owner, data in
                        let isSelected = data.contains(element.name)
                        cell.likeButton.isSelected = isSelected
                        print(data, isSelected)
                    }
                    .disposed(by: cell.disposeBag)

                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.likeButton.isSelected.toggle()
                        UserModel.updateLikeList(element.name)
                        owner.viewModel.input.likeListChange.onNext(())
                    }
                    .disposed(by: cell.disposeBag)

                cell.configureCell(with: element)
            }
            .disposed(by: disposeBag)

        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in
                let text = owner.searchBar.text
                owner.viewModel.input.searchBarText.onNext(text)
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Person.self)
            .bind(with: self) { owner, userData in
                owner.viewModel.input.tableViewTapped.onNext(userData.name)
                print(userData.name)
            }
            .disposed(by: disposeBag)

        viewModel.output.collectionViewData
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
                cell.configureCell(with: element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}

