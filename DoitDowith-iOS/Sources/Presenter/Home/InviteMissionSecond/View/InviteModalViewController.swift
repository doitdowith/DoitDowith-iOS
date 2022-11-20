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
  
  @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
  
  // MARK: Constant
  private var currentViewHeight: CGFloat = 700
  
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewHeight: CGFloat = 700
  private let criticalHeight: CGFloat = 500
  private let dissmissHeight: CGFloat = 350
  
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
    self.bindContentView()
    self.bindFriendListTableView()
  }
}

// MARK: Bind Functions
extension InviteModalViewController {
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
      .subscribe(onNext: { _ in
        self.animateDismissView()
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindLifeCycle() {
    self.rx.viewDidAppear
      .withUnretained(self)
      .subscribe(onNext: { _ in
        self.animateDimmedView()
        self.animateContentView()
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindFriendListTableView() {
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
