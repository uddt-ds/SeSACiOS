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


    }

    private func bind() {

        let trigger = BehaviorSubject(value: ())

        let likeListChange = BehaviorSubject(value: ())

        let input = HomeworkViewModel.Input(viewDidLoadTrigger: trigger,
                                            searchButtonCliked: searchBar.rx.searchButtonClicked.withLatestFrom(searchBar.rx.text.orEmpty),
                                            likeListChange: likeListChange,
                                            tableViewTapped: tableView.rx.modelSelected(Person.self))


        let output = viewModel.transform(input: input)

        output.rawData
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: PersonTableViewCell.identifier, cellType: PersonTableViewCell.self)) { [weak self] (row, element, cell) in
                guard let self else { return }

                cell.detailButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = ViewController(nickname: element.name)
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)

                output.likeList
                    .bind(with: self.view) { owner, data in
                        let isSelected = data.contains(element.name)
                        cell.likeButton.isSelected = isSelected
                    }
                    .disposed(by: cell.disposeBag)

                // 이 로직도 ViewModel로 가야하지 않을까, UserModel을 프로퍼티 래퍼 형태로 저장해서 쓰는게 어색함 Rx구조로 변경이 필요함
                cell.likeButton.rx.tap
                    .bind(with: self) { owner, _ in
                        cell.likeButton.isSelected.toggle()
                        UserModel.updateLikeList(element.name)
                        likeListChange.onNext(())
                    }
                    .disposed(by: cell.disposeBag)

                cell.configureCell(with: element)
            }
            .disposed(by: disposeBag)

        output.collectionViewData
            .asDriver()
            .drive(collectionView.rx.items) { (collectionView, row, element) in
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

