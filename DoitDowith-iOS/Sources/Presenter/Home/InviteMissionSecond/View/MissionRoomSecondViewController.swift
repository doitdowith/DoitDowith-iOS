//
//  MissionRoomSecondViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import Action
import NSObject_Rx
import RxCocoa
import RxSwift
import RxRelay

final class MissionRoomSecondViewController: UIViewController {
  // MARK: Interface Builder
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var friendCollectionView: UICollectionView!
  @IBOutlet weak var makeButton: UIButton!
  
  @IBAction func didTapCompleteButton(_ sender: UIButton) {
    let charRoomService = ChatService()
    let stompManager = StompManager(targetId: 1, senderId: "b6dcf006-7fbf-47fc-9247-944b5706222e", connectType: .room)
    let chatRoomViewModel = ChatRommViewModel(id: 1,
                                              chatService: charRoomService,
                                              stompManager: stompManager)
    let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "ChatRoomVC",
                                                                                           creator: { coder in
      ChatRoomController(coder: coder, viewModel: chatRoomViewModel)
    })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: Properties
  private let viewModel: MissionRoomSecondViewModelType
  
  // MARK: Initializers
  init?(coder: NSCoder, viewModel: MissionRoomSecondViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.friendCollectionView.collectionViewLayout = self.collectionViewLayout()
    self.registerCells()
    self.bind()
  }
}

// MARK: Basic functions
extension MissionRoomSecondViewController {
  func bind() {
    self.bindLifeCylce()
    self.bindBackButton()
    self.bindFriendCollectionView()
  }
  
  func registerCells() {
    let friendCellNib = UINib(nibName: "FriendProfileCell", bundle: nil)
    self.friendCollectionView.register(friendCellNib,
                                       forCellWithReuseIdentifier: FriendProfileCell.identifier)
  }
  
  func collectionViewLayout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .absolute(48),
                                      heightDimension: .absolute(48))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                      heightDimension: .absolute(48)),
                                                   subitems: [item])
    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func action1() {
    let inviteModal = UIStoryboard(name: "Home",
                                   bundle: nil).instantiateViewController(withIdentifier: "InviteModalVC")
    
    inviteModal.modalPresentationStyle = .overCurrentContext
    self.present(inviteModal, animated: false)
  }
}

// MARK: Bind ViewModel
extension MissionRoomSecondViewController {
  func bindLifeCylce() {
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      navigationController?.isNavigationBarHidden = visible
    })
    .disposed(by: rx.disposeBag)
  }
  
  func bindBackButton() {
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak navigationController]_ in
        navigationController?.popViewController(animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindFriendCollectionView() {
    self.viewModel.output.model
      .bind(to: self.friendCollectionView.rx.items(cellIdentifier: FriendProfileCell.identifier,
                                                   cellType: FriendProfileCell.self)) { _, color, cell in
        cell.backgroundColor = color
      }
                                                   .disposed(by: rx.disposeBag)
    
    Observable
      .zip(self.friendCollectionView.rx.itemSelected,
           self.friendCollectionView.rx.modelSelected(UIColor.self))
      .bind { [unowned self] indexPath, _ in
        if indexPath.row == self.viewModel.output.model.value.count - 1 {
          self.action1()
        }
      }
      .disposed(by: rx.disposeBag)
  }
}
