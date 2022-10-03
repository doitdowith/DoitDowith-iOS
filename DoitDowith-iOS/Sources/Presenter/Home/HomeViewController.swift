//
//  HomeViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxSwift
import RxViewController

class HomeViewController: UIViewController {
  @IBOutlet weak var contentCollectionView: UICollectionView!
  
  var service: HomeServiceProtocol
  var viewModel: HomeViewModelType
  
  required init?(coder: NSCoder) {
    self.service = HomeService()
    self.viewModel = HomeViewModel(service: service)
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.contentCollectionView.collectionViewLayout = self.colletionViewLayout()
    self.bindViewModel()
  }
  
  //  @IBAction func navigateChatVC(_ sender: UIButton) {
  //    guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomVC") as? ChatRoomController else { return }
  //    let service = ChatService()
  //    let viewModel = ChatRommViewModel(id: 0, chatService: service)
  //    viewController.viewModel = viewModel
  //    self.navigationController?.pushViewController(viewController, animated: true)
  //  }
}

extension HomeViewController {
  func registerNib() {
    let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
    self.contentCollectionView.register(contentCellNib,
                                        forCellWithReuseIdentifier: ContentCell.identifier)
  }
  
  func bindViewModel() {
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.cardList
      .drive(self.contentCollectionView.rx.items(dataSource: viewModel.output.cardDataSource))
      .disposed(by: rx.disposeBag)
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(125))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalHeight(1.0))
    let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                 subitems: [item])
    verticalGroup.interItemSpacing = NSCollectionLayoutSpacing.fixed(14)
    
    let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0)
                                                     , heightDimension: .fractionalHeight(1.0))
    let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize,
                                                             subitem: verticalGroup,
                                                             count: 1)
    
    let section = NSCollectionLayoutSection(group: horizontalGroup)
    section.orthogonalScrollingBehavior = .paging
    
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}
