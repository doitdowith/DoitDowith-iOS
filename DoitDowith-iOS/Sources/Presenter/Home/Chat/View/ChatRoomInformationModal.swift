//
//  ChatRoomInformationModal.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/20.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxGesture
import RxSwift

final class ChatRoomInformationModal: UIViewController {
  // MARK: Interface Builder
  @IBOutlet weak var dimmedView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var teamMemberTableView: UITableView!
  
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewWidth: CGFloat = 350
  @IBOutlet weak var contentViewTrailingConstraints: NSLayoutConstraint!
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
    self.configureModalView()
  }
  
  @IBAction func closeModal(_ sender: UIButton) {
    self.animateDismissView()
  }
}

// MARK: Basic functions
extension ChatRoomInformationModal {
  func bind() {
    self.bindLifeCylce()
    self.bindDimmedView()
    self.bindConentView()
  }
  func configureModalView() {
    self.contentView.layer.masksToBounds = true
    self.contentView.layer.cornerRadius = 24
    self.contentView.layer.maskedCorners = [.layerMinXMinYCorner]
  }
  func registerCells() { }
}

// MARK: Bind functions
extension ChatRoomInformationModal {
  func bindLifeCylce() {
    self.rx.viewDidAppear
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.animateDimmedView()
        owner.animateContentView()
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindDimmedView() {
    self.dimmedView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.animateDismissView()
      })
      .disposed(by: rx.disposeBag)
  }
  func bindConentView() { }
}

// MARK: Animate functions
extension ChatRoomInformationModal {
  func animateDimmedView() {
    self.dimmedView.alpha = 0
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.dimmedView.alpha = self.dimmedAlpha
      self.view.layoutIfNeeded()
    }
  }
  
  func animateContentView() {
    self.contentViewTrailingConstraints.constant = 0
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
    self.contentViewTrailingConstraints.constant = -self.modalViewWidth
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
  }
}
