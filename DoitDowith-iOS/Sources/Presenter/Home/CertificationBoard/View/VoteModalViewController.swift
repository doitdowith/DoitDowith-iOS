//
//  VoteModalViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/27.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import RxViewController
import NSObject_Rx

class VoteModalViewController: UIViewController {
  // MARK: Constant
  private var currentViewHeight: CGFloat = 380
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewHeight: CGFloat = 380
  private let criticalHeight: CGFloat = 300
  private let dissmissHeight: CGFloat = 200
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configuration()
    self.bind()
  }
  
  @IBOutlet weak var dimmedView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
}

extension VoteModalViewController {
  func configuration() {
    self.configureModalView()
  }
  
  func configureModalView() {
    self.contentView.layer.applySketchShadow(alpha: 0.08, x: 0, y: 0, blur: 4, spread: 0)
    self.contentView.layer.cornerRadius = 24
    self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
}

// MARK: Bind function
extension VoteModalViewController {
  func bind() {
    self.bindLifeCycle()
    self.bindDimmedView()
    self.bindContentView()
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
}

// MARK: Animate Function
extension VoteModalViewController {
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
