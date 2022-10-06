//
//  HomeViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxGesture
import RxSwift
import RxViewController

final class HomeViewController: UIViewController {
  // MARK: - Interface Builder
  @IBOutlet weak var contentCollectionView: UICollectionView!
  @IBOutlet weak var doingButton: UILabel!
  @IBOutlet weak var willdoButton: UILabel!
  @IBOutlet weak var doneButton: UILabel!
  @IBOutlet weak var bottomLine: UIView!
  
  @IBOutlet weak var bottomLineWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
  
  // MARK: - Constant
  private let doingButtonLeftPadding: CGFloat = 16
  private let buttonSpacing: CGFloat = 12
  
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
    self.bindViewWillAppear()
    self.bindContentCollectionView()
    self.bindPagingTabButton()
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let screenWidth = UIScreen.main.bounds.width
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: size)
    
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .paging
    section.visibleItemsInvalidationHandler = ({ [weak self] (_, point, _) in
      guard let self = self else { return }
      if point.x <= 0 {
        self.bottomLineLeadingConstraint.constant = (self.doingButton.left - self.doingButtonLeftPadding)
      } else if point.x <= screenWidth {
        self.bottomLineLeadingConstraint.constant = (self.doingButton.width + self.buttonSpacing) / screenWidth * point.x
      } else if point.x <= screenWidth * 2 {
        self.bottomLineLeadingConstraint.constant = (self.willdoButton.width + self.buttonSpacing) / screenWidth * point.x - 10
      }
    })
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func slideNextPage(at index: Int) {
    self.contentCollectionView.selectItem(at: IndexPath(row: index, section: 0),
                                          animated: true,
                                          scrollPosition: .centeredHorizontally)
  }
}

// MARK: - Bind ViewModel Function
extension HomeViewController {
  func bindViewWillAppear() {
    // 네비게이션 바 없애기
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      navigationController?.isNavigationBarHidden = visible
    })
    .disposed(by: rx.disposeBag)
    
    let firstLoad = rx.viewWillAppear
      .take(1)
      .map { _ in () }
    
    let reload = self.contentCollectionView.refreshControl?.rx
      .controlEvent(.valueChanged)
      .map { _ in () } ?? Observable.just(())
    
    Observable.merge([firstLoad, reload])
      .bind(to: viewModel.fetchCards)
      .disposed(by: rx.disposeBag)
  }
  
  func bindContentCollectionView() {
    self.viewModel.output.doingCardList
      .bind(to: self.contentCollectionView.rx.items(
        cellIdentifier: ContentCell.identifier,
        cellType: ContentCell.self)) { _, element, cell in
          cell.modelRelay.accept(element)
          cell.delegate = self
        }
        .disposed(by: rx.disposeBag)
  }
  
  func bindPagingTabButton() {
    self.doingButton.rx
      .tapGesture()
      .when(.recognized)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind(onNext: { vc, _ in
        vc.slideNextPage(at: 0)
      })
      .disposed(by: rx.disposeBag)
    
    self.willdoButton.rx
      .tapGesture()
      .when(.recognized)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind(onNext: { vc, _ in
        vc.slideNextPage(at: 1)
      })
      .disposed(by: rx.disposeBag)
    
    self.doneButton.rx
      .tapGesture()
      .when(.recognized)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind(onNext: { vc, _ in
        vc.slideNextPage(at: 2)
      })
      .disposed(by: rx.disposeBag)
  }
}

extension HomeViewController: ContentCellDelegate {
  func contentCell(_ cell: UICollectionViewCell, didSelectCell: CardModel) {
    let viewController = UIStoryboard(name: "Home",
                                      bundle: nil).instantiateViewController(identifier: "MissionRoomFirstVC",
                                                                             creator: { coder in
                                        MissionRoomFirstViewController(coder: coder)
                                      })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
