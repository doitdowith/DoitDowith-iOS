//
//  ChatRoomInformationModalWhenStarted.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/20.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxGesture
import RxSwift

final class ChatRoomInformationModalWhenStarted: UIViewController {
  static let identifier: String = "ChatRoomInformationModalWhenStarted"
 
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewWidth: CGFloat = 350
  private let viewModel: InformationModalViewModelType
  
  init?(coder: NSCoder, viewModel: InformationModalViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
    self.configureModalView()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var dimmedView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var teamMemberTableView: UITableView!
  @IBOutlet weak var contentViewTrailingConstraints: NSLayoutConstraint!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var countLabel: UILabel!
  
  @IBOutlet weak var descriptionLabel: UILabel!
  
  @IBAction func moveToCertificateBoard(_ sender: UIButton) {
    let vm = CertificationBoardViewModel()
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: CertificationBoardViewController.identifier) { coder in
      CertificationBoardViewController(coder: coder, viewModel: vm)
    }
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    nav.isNavigationBarHidden = true
    present(nav, animated: true)
  }
  
  @IBAction func closeModal(_ sender: UIButton) {
    self.animateDismissView()
  }
}

// MARK: Basic functions
extension ChatRoomInformationModalWhenStarted {
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
extension ChatRoomInformationModalWhenStarted {
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
  func bindConentView() {
    self.viewModel.output.roomTitle
      .drive(titleLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.roomDescription
      .drive(descriptionLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.roomCount
      .drive(countLabel.rx.text)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.roomDate
      .drive(dateLabel.rx.text)
      .disposed(by: rx.disposeBag)
  }
  func bindTeamMemberTableView() {
  }
}

// MARK: Animate functions
extension ChatRoomInformationModalWhenStarted {
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
