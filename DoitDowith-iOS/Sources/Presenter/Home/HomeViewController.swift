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
  // MARK: - Interface Builder
  @IBOutlet weak var contentCollectionView: UICollectionView!
  @IBOutlet weak var doingButton: UILabel!
  @IBOutlet weak var willdoButton: UILabel!
  @IBOutlet weak var doneButton: UILabel!
  @IBOutlet weak var bottomLine: UIView!
  
  @IBOutlet weak var buttonLineWidthConstraints: NSLayoutConstraint!
  @IBOutlet weak var buttonLineCenterXConstraints: NSLayoutConstraint!
  @IBOutlet weak var bottomLineTopConstraints: NSLayoutConstraint!
  // MARK: - Properties
  var service: HomeServiceProtocol
  var viewModel: HomeViewModelType
  
  // MARK: - Initializer
  required init?(coder: NSCoder) {
    self.service = HomeService()
    self.viewModel = HomeViewModel(service: service)
    super.init(coder: coder)
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addButtonGesture()
    self.registerNib()
    self.contentCollectionView.collectionViewLayout = self.colletionViewLayout()
    self.bindViewModel()
  }
}

// MARK: - Functions
extension HomeViewController {
  func registerNib() {
    let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
    self.contentCollectionView.register(contentCellNib,
                                        forCellWithReuseIdentifier: ContentCell.identifier)
  }
  func bindViewModel() {
    // 네비게이션 바 없애기
    Observable
      .merge(self.rx.viewWillAppear.asObservable(),
             self.rx.viewWillDisappear.asObservable())
      .subscribe(onNext: { state in
        guard let nav = self.navigationController else { return }
        nav.rx.isNavigationBarHidden.onNext(state)
      })
      .disposed(by: rx.disposeBag)
    
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.doingCardList
      .bind(to: self.contentCollectionView.rx.items(
        cellIdentifier: ContentCell.identifier,
        cellType: ContentCell.self)) { _, element, cell in
          cell.configure(model: element)
        }
      .disposed(by: rx.disposeBag)
    
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: size)
    
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - UITapGesture Function
private extension HomeViewController {
  func addButtonGesture() {
    self.doingButton.addGestureRecognizer(
      UITapGestureRecognizer(target: self,
                             action: #selector(self.didTapDoingButton)))
    self.willdoButton.addGestureRecognizer(
      UITapGestureRecognizer(target: self,
                             action: #selector(self.didTapWillDoButton)))
    self.doneButton.addGestureRecognizer(
      UITapGestureRecognizer(target: self,
                             action: #selector(self.didTapDoneButton)))
  }
  
  @objc func didTapDoingButton() {
    self.contentCollectionView.selectItem(at: IndexPath(row: 0, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
  }
  
  @objc func didTapWillDoButton() {
    self.contentCollectionView.selectItem(at: IndexPath(row: 1, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
  }
  
  @objc func didTapDoneButton() {
    self.contentCollectionView.selectItem(at: IndexPath(row: 2, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
  }
}
