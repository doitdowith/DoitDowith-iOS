//
//  VoteResultViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import UIKit

import RxCocoa
import RxSwift
import RxGesture
import RxViewController
import NSObject_Rx

class VoteResultViewController: UIViewController {
  // MARK: Constant
  private var currentViewHeight: CGFloat = 760
  private let dimmedAlpha: CGFloat = 0.8
  private let modalViewHeight: CGFloat = 760
  private let criticalHeight: CGFloat = 506
  private let dissmissHeight: CGFloat = 380
  
  var viewModel: VoteResultViewModelType
  
  init?(coder: NSCoder, viewModel: VoteResultViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.voteMemberListView.collectionViewLayout = layout()
    self.register()
    self.configuration()
    self.bind()
  }
  
  @IBOutlet weak var dimmedView: UIView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nickNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var goodCountLabel: UILabel!
  @IBOutlet weak var badCountLabel: UILabel!
  @IBOutlet weak var voteMemberListView: UICollectionView!
  
  @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
}

extension VoteResultViewController {
  func configuration() {
    self.configureModalView()
  }
  
  func configureModalView() {
    self.contentView.layer.applySketchShadow(alpha: 0.08, x: 0, y: 0, blur: 4, spread: 0)
    self.contentView.layer.cornerRadius = 24
    self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
  }
  
  func register() {
    let cellNib = UINib(nibName: "VoteResultContentViewCell", bundle: nil)
    voteMemberListView.register(cellNib,
                                forCellWithReuseIdentifier: VoteResultContentViewCell.identifier)
  }
}
extension VoteResultViewController {
  func layout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: size)
    
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                    leading: 0,
                                                    bottom: 20,
                                                    trailing: 0)
    section.interGroupSpacing = 15
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}

// MARK: Bind function
extension VoteResultViewController {
  func bind() {
    self.bindLifeCycle()
    self.bindDimmedView()
    self.bindContentView()
    self.bindVoteMemberListView()
  }
  
  func bindVoteMemberListView() {
    self.viewModel.output.voteMemberList
      .do { print($0) }
      .drive(self.voteMemberListView.rx.items(dataSource: self.viewModel.output.voteMemberViewDataSource))
      .disposed(by: rx.disposeBag)
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
extension VoteResultViewController {
  func animateDimmedView() {
    self.dimmedView.alpha = 0
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.dimmedView.alpha = self.dimmedAlpha
      self.view.layoutIfNeeded()
    }
  }
  
  func animateContentView() {
    self.contentViewBottomConstraint.constant = 0
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
  }
  
  func animateDismissView() {
    self.dimmedView.alpha = dimmedAlpha
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
    
    self.contentViewBottomConstraint.constant = self.modalViewHeight
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
  }
  
  func animateContentViewHeight(_ height: CGFloat) {
    self.contentViewHeightConstraint.constant = height
    UIView.animate(withDuration: 0.5) { [weak self] in
      guard let self = self else { return }
      self.view.layoutIfNeeded()
    }
    self.currentViewHeight = height
  }
}
