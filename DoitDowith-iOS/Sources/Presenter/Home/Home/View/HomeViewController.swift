//
//  HomeViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import RxViewController

typealias HomeDataSource = RxCollectionViewSectionedAnimatedDataSource<HomeSectionModel>
final class HomeViewController: UIViewController {
  // MARK: Constant
  private let doingButtonLeftPadding: CGFloat = 16
  private let buttonSpacing: CGFloat = 12
  
  // MARK: Properties
  var viewModel: HomeViewModelType
  var stompManager: StompManagerProtocol?
  
  // MARK: Initializer
  required init?(coder: NSCoder) {
    self.viewModel = HomeViewModel()
    super.init(coder: coder)
  }
  
  deinit {
    stompManager?.disconnect()
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.contentCollectionView.collectionViewLayout = self.colletionViewLayout()
    self.contentCollectionView.refreshControl = refreshControl
    self.bind()
  }
  
  // MARK: Interface Builder
  let refreshControl = UIRefreshControl()
  @IBOutlet weak var contentCollectionView: UICollectionView!
  @IBOutlet weak var doingButton: UILabel!
  @IBOutlet weak var willdoButton: UILabel!
  @IBOutlet weak var doneButton: UILabel!
  @IBOutlet weak var bottomLine: UIView!
  @IBOutlet weak var alamButton: UIImageView!
  
  @IBOutlet weak var bottomLineWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomLineLeadingConstraint: NSLayoutConstraint!
  
  @IBAction func createMissionRoom(_ sender: UIButton) {
    navigateCreateMissionRoom()
  }
}

// MARK: - Basic functions
extension HomeViewController {
  func registerNib() {
    let contentCellNib = UINib(nibName: "ContentCell", bundle: nil)
    self.contentCollectionView.register(contentCellNib,
                                        forCellWithReuseIdentifier: ContentCell.identifier)
    let emptyCellNib = UINib(nibName: "EmptyCardCell", bundle: nil)
    self.contentCollectionView.register(emptyCellNib,
                                        forCellWithReuseIdentifier: EmptyCardCell.identifier)
  }
  
  func bind() {
    self.bindLifeCycle()
    self.bindContentCollectionView()
    self.bindPagingTabButton()
    self.bindAlarmButton()
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let screenWidth = UIScreen.main.bounds.width
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: size)
    
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.visibleItemsInvalidationHandler = ({ [weak self] (_, point, _) in
      let half = screenWidth / 2
      guard let self = self else { return }
      if 0 <= point.x  && point.x <= half {
        self.viewModel.input.indicatorIndex.accept(0)
      } else if half < point.x && point.x <= screenWidth + half {
        self.viewModel.input.indicatorIndex.accept(1)
      } else if screenWidth + half < point.x && point.x <= 2 * screenWidth {
        self.viewModel.input.indicatorIndex.accept(2)
      }
      
      if point.x <= 0 {
        self.bottomLineLeadingConstraint.constant = (self.doingButton.left - self.doingButtonLeftPadding)
        self.bottomLineWidthConstraint.constant = self.doingButton.width
      } else if point.x <= screenWidth {
        self.bottomLineLeadingConstraint.constant =
        (self.doingButton.width + self.buttonSpacing) / screenWidth * point.x
        self.bottomLineWidthConstraint.constant =
        self.doingButton.width + (self.willdoButton.width - self.doingButton.width) / screenWidth * point.x
      } else if point.x <= screenWidth * 2 {
        self.bottomLineLeadingConstraint.constant =
        (self.willdoButton.width + self.buttonSpacing) / screenWidth * point.x - 10
        self.bottomLineWidthConstraint.constant =
        self.willdoButton.width + ((self.doneButton.width - self.willdoButton.width) / (screenWidth * 2) * point.x)
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

// MARK: - Bind functions
extension HomeViewController {
  func bindLifeCycle() {
    // 네비게이션 바 없애기
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      navigationController?.isNavigationBarHidden = visible })
    .disposed(by: rx.disposeBag)
    
    rx.viewWillAppear
      .withUnretained(self)
      .bind(onNext: {(owner, _) in
        owner.slideNextPage(at: 0)
        owner.viewModel.input.indicatorIndex.accept(0)
      })
      .disposed(by: rx.disposeBag)
    let firstLoad = rx.viewWillAppear
      .map { _ in () }
    
    let reload = self.contentCollectionView.refreshControl?.rx
      .controlEvent(.valueChanged)
      .map { _ in () } ?? Observable.just(())
    
    Observable.merge([firstLoad, reload])
      .bind(to: viewModel.input.fetchCards)
      .disposed(by: rx.disposeBag)
  }
  
  func bindContentCollectionView() {
    self.viewModel.output.cardList
      .drive(contentCollectionView.rx.items(dataSource: self.dataSource()))
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
        vc.viewModel.input.indicatorIndex.accept(0) })
      .disposed(by: rx.disposeBag)
    
    self.viewModel.doingButtonColor
      .drive(self.doingButton.rx.textColor)
      .disposed(by: rx.disposeBag)
    
    self.willdoButton.rx
      .tapGesture()
      .when(.recognized)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind(onNext: { vc, _ in
        vc.slideNextPage(at: 1)
        vc.viewModel.input.indicatorIndex.accept(1) })
      .disposed(by: rx.disposeBag)
    
    self.viewModel.willDoButtonColor
      .drive(self.willdoButton.rx.textColor)
      .disposed(by: rx.disposeBag)
    
    self.doneButton.rx
      .tapGesture()
      .when(.recognized)
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .withUnretained(self)
      .bind(onNext: { vc, _ in
        vc.slideNextPage(at: 2)
        vc.viewModel.input.indicatorIndex.accept(2) })
      .disposed(by: rx.disposeBag)
    
    self.viewModel.doneButtonColor
      .drive(self.doneButton.rx.textColor)
      .disposed(by: rx.disposeBag)
  }
  
  func bindAlarmButton() {
    self.alamButton.rx
      .tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.navigateAlarmView()
      })
      .disposed(by: rx.disposeBag)
  }
}

// MARK: - ContentCell Delegate
extension HomeViewController: ContentCellDelegate {
  func contentCell(_ didSelectCell: UICollectionViewCell, card: Card) {
    guard let memberId = UserDefaults.standard.string(forKey: "memberId") else { return }
    let stompManager = StompManager(roomId: card.roomId,
                                    memberId: memberId)
    self.stompManager = stompManager
    let chatService = ChatService()
    let roomid = card.roomId.hash
    if !chatService.searchRoom(roomId: roomid) {
      chatService.createChatRoom(roomId: roomid)
    }
    let vm = ChatRommViewModel(card: card,
                               stompManager: stompManager,
                               chatService: chatService)
    stompManager.viewModel = vm
    let vc = UIStoryboard(name: "Home",
                          bundle: nil).instantiateViewController(identifier: ChatRoomController.identifier,
                                                                 creator: { coder in
                            ChatRoomController(coder: coder, card: card, viewModel: vm) })
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - Card TableView DataSource
extension HomeViewController {
  func dataSource() -> HomeDataSource {
    return HomeDataSource { _, collectionView, indexPath, item in
      switch item.type {
      case .none:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCardCell.identifier,
                                                            for: indexPath) as? EmptyCardCell else {
          return UICollectionViewCell()
        }
        return cell
      case .doing, .willdo, .done:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier,
                                                            for: indexPath) as? ContentCell else {
          return UICollectionViewCell()
        }
        cell.modelRelay.accept(item.data)
        cell.delegate = self
        return cell
      }
    }
  }
}

// MARK: - Navigate Functions
extension HomeViewController {
  func navigateCreateMissionRoom() {
    let vm: MissionRoomFirstViewModelType = MissionRoomFirstViewModel()
    let vc = UIStoryboard(name: "Home",
                          bundle: nil).instantiateViewController(identifier: MissionRoomFirstViewController.identifier,
                                                                 creator: { coder in
                            MissionRoomFirstViewController(coder: coder, viewModel: vm) })
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func navigateAlarmView() {
    let vm: AlarmViewModelType = AlarmViewModel()
    let vc = UIStoryboard(name: "Home",
                          bundle: nil).instantiateViewController(identifier: AlarmViewController.identifier,
                                                                 creator: { coder in
                            AlarmViewController(coder: coder, viewModel: vm) })
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
