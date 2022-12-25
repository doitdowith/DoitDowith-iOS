//
//  InviteModalViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/13.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxGesture
import RxSwift
import RxViewController

final class InviteModalViewController: UIViewController {
  // MARK: Interface Builder
  @IBOutlet weak var dimmedView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var friendListTableView: UITableView!
  @IBOutlet weak var searchbar: UISearchBar!
  @IBOutlet weak var friendNumber: UILabel!
  @IBOutlet weak var filterButton: UIButton!
  
  @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
  
  @IBAction func completeButtonDidTap(_ sender: UIButton) {
    var filtered: [Friend] = []
    for (i, friend) in self.friendList.enumerated() where selectedCell[i] {
      let selected = Friend(id: friend.id, url: friend.url, state: .ing, name: friend.name)
      filtered.append(selected)
    }
    print(filtered)
    parentViewModel.input.selectFriends.accept(filtered)
    animateDismissView()
  }
  
  // MARK: Constant
  static let identifier: String = "InviteModalVC"
  private var currentViewHeight: CGFloat = 700
  
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewHeight: CGFloat = 700
  private let criticalHeight: CGFloat = 500
  private let dissmissHeight: CGFloat = 350
  private let filterButtonTapCount: Int = 0
  
  private var friendList: [Friend] = []
  private var selectedCell: [Bool] = []
  private let parentViewModel: MissionRoomSecondViewModelType
  
  // MARK: Initializers
  init?(coder: NSCoder,
        parentViewModel: MissionRoomSecondViewModelType) {
    self.parentViewModel = parentViewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerCells()
    self.configureModalView()
    self.configureSearchbar()
    self.bind()
  }
}

// MARK: Basic Functions
extension InviteModalViewController {
  func configureSearchbar() {
  }
  func configureModalView() {
    self.contentView.layer.applySketchShadow(alpha: 0.08, x: 0, y: 0, blur: 4, spread: 0)
    self.contentView.layer.cornerRadius = 24
  }
  
  func registerCells() {
    let friendCellNib = UINib(nibName: "FriendCell", bundle: nil)
    self.friendListTableView.register(friendCellNib,
                                      forCellReuseIdentifier: FriendCell.identifier)
  }
  
  func bind() {
    self.bindLifeCycle()
    self.bindDimmedView()
    self.bindFriendList()
    self.bindContentView()
    self.bindFriendListTableView()
    self.bindFriendNumberLabel()
  }
}

// MARK: Bind Functions
extension InviteModalViewController {
  func bindFriendList() {
    self.parentViewModel.output.friendList
      .drive(onNext: { friends in
        self.friendList = friends
        self.selectedCell = Array(repeating: false, count: friends.count)
      })
      .disposed(by: rx.disposeBag)
  }
  func bindFriendNumberLabel() {
    self.parentViewModel.output.friendList
      .map { $0.count }
      .map { "친구 \($0)명" }
      .drive(self.friendNumber.rx.text)
      .disposed(by: rx.disposeBag)
  }
  
  func bindFilterButton() {
  }
  
  func bindContentView() {
    self.contentView.rx.panGesture()
      .when(.changed)
      .asTranslation()
      .map { self.currentViewHeight - $0.translation.y }
      .filter { $0 <= self.modalViewHeight }
      .bind(to: self.contentViewHeightConstraint.rx.constant)
      .disposed(by: rx.disposeBag)
    
    self.contentView.rx.panGesture()
      .when(.ended)
      .asTranslation()
      .map { self.currentViewHeight - $0.translation.y }
      .withUnretained(self)
      .subscribe(onNext: { owner, height in
        if height <= owner.dissmissHeight {
          owner.animateDismissView()
        } else {
          owner.animateContentViewHeight(owner.modalViewHeight)
        }
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindDimmedView() {
    self.dimmedView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.animateDismissView()
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindLifeCycle() {
    self.rx.viewDidAppear
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.animateDimmedView()
        owner.animateContentView()
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindFriendListTableView() {
    Observable.zip(friendListTableView.rx.modelSelected(Friend.self),
               friendListTableView.rx.itemSelected)
    .bind { [weak self] _, indexPath in
      self?.friendListTableView.deselectRow(at: indexPath, animated: true)
      if let cell = self?.friendListTableView.cellForRow(at: indexPath) as? FriendCell {
        switch cell.state {
        case .can:
          cell.inviteStateLabel.text = "선택함"
          cell.state = .ing
          self?.selectedCell[indexPath.row].toggle()
        case .ing:
          cell.inviteStateLabel.text = State.can.rawValue
          cell.state = .can
          self?.selectedCell[indexPath.row].toggle()
        default:
          break
        }
      }
    }
    .disposed(by: rx.disposeBag)
    
    self.parentViewModel.output.friendList
      .drive(friendListTableView.rx.items(cellIdentifier: FriendCell.identifier,
                                                      cellType: FriendCell.self)) { _, element, cell in
        cell.configure(url: element.url,
                       name: element.name,
                       state: element.state)
        cell.selectionStyle = .none
      }
     .disposed(by: rx.disposeBag)
  }
}

// MARK: Animate Functions
extension InviteModalViewController {
  func animateDimmedView() {
    self.dimmedView.alpha = 0
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.dimmedView.alpha = self.dimmedAlpha
      self.view.layoutIfNeeded()
    }
  }
  
  func animateContentView() {
    self.contentViewBottomConstraint.constant = 0
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
  }
  
  func animateDismissView() {
    self.dimmedView.alpha = dimmedAlpha
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
    
    self.contentViewBottomConstraint.constant = self.modalViewHeight
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
  }
  
  func animateContentViewHeight(_ height: CGFloat) {
    self.contentViewHeightConstraint.constant = height
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
    self.currentViewHeight = height
  }
}
