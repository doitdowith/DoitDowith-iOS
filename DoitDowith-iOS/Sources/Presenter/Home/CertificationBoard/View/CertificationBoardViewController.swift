//
//  CertificationBoardViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import UIKit

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import RxViewController
import NSObject_Rx

class CertificationBoardViewController: UIViewController {
  static let identifier: String = "CertificationBoardVC"
  var viewModel: CertificationBoardViewModelType
  
  init?(coder: NSCoder, viewModel: CertificationBoardViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    register()
    bind()
    self.certificationBoardView.collectionViewLayout = layout()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var navigationTitleLabel: UILabel!
  @IBOutlet weak var certificationBoardView: UICollectionView!
  @IBOutlet weak var backButton: UIImageView!
  // @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
}

// MARK: Basic Functions: bind, register...
extension CertificationBoardViewController {
  func bind() {
    bindLifeCycle()
    bindTitle()
    bindBackButton()
    bindCertificationBoardView()
    // bindActivityIndicator()
  }
  func register() {
    let certificationPostWithImageCellNib = UINib(nibName: "CertificationPostWithImageCell", bundle: nil)
    certificationBoardView.register(certificationPostWithImageCellNib,
                                    forCellWithReuseIdentifier: CertificationPostWithImageCell.identifier)
    let certificationPostCellNib = UINib(nibName: "CertificationPostCell", bundle: nil)
    certificationBoardView.register(certificationPostCellNib,
                                    forCellWithReuseIdentifier: CertificationPostCell.identifier)
  }
  
  func backButtonDidTap() {
    self.navigationController?.dismiss(animated: true)
  }
}

// MARK: Bind Functions
extension CertificationBoardViewController {
  func bindBackButton() {
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.backButtonDidTap()
      })
      .disposed(by: rx.disposeBag)
  }
                
  func bindTitle() {
    self.viewModel.output.roomTitle
      .drive(navigationTitleLabel.rx.text)
      .disposed(by: rx.disposeBag)
  }
  
  func bindCertificationBoardView() {
    self.viewModel.output.certificatePostList
      .drive(certificationBoardView.rx.items(dataSource: self.dataSource()))
      .disposed(by: rx.disposeBag)
  }
  
  func bindLifeCycle() {
    Observable
      .merge(self.rx.viewWillAppear.asObservable(), self.rx.viewWillDisappear.asObservable())
      .subscribe(onNext: { state in
        guard let nav = self.navigationController else { return }
        nav.rx.isNavigationBarHidden.onNext(state)
      })
      .disposed(by: rx.disposeBag)
    
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: self.viewModel.input.fetchPosts)
      .disposed(by: rx.disposeBag)
  }
  /*
   func bindActivityIndicator() {
   viewModel.output.activated
   .drive(self.activityIndicator.rx.isHidden)
   .disposed(by: rx.disposeBag)
   }
   */
}

// MARK: CollectionView Function: Layout, datasource
extension CertificationBoardViewController {
  func layout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(400))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                   subitem: item,
                                                   count: 1)
    group.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                  leading: 16,
                                                  bottom: 0,
                                                  trailing: 16)
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 12
    section.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                    leading: 0,
                                                    bottom: 20,
                                                    trailing: 0)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
  
  typealias PostSectionModel = AnimatableSectionModel<Int, CertificationPost>
  private func dataSource() -> RxCollectionViewSectionedAnimatedDataSource<PostSectionModel> {
    return RxCollectionViewSectionedAnimatedDataSource<PostSectionModel> { _, collectionView, indexPath, post in
      switch post.postType {
      case.ImagePost:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: CertificationPostWithImageCell.identifier,
          for: indexPath) as? CertificationPostWithImageCell else {
          return UICollectionViewCell()
        }
        cell.configure(with: post)
        cell.delegate = self
        return cell
      case .TextPost:
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: CertificationPostCell.identifier,
          for: indexPath) as? CertificationPostCell else {
          return UICollectionViewCell()
        }
        cell.configure(with: post)
        cell.delegate = self
        return cell
      }
    }
  }
}

// MARK: CollectionView Cell delegate
extension CertificationBoardViewController: CertifiactionPostCellDelegate,
                                            CertificationPostWithImageCellDelegate {
  func presentVoteModal() {
    let vm = VoteResultViewModel()
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "VoteResultVC") { coder in
      VoteResultViewController(coder: coder, viewModel: vm)
    }
    vc.modalPresentationStyle = .overCurrentContext
    self.present(vc, animated: false)
  }
  func certificationPostCell(_ voteButtonDidTap: UIButton) {
    presentVoteModal()
  }
  
  func certificationPostWithImageCell(_ voteButtonDidTap: UIButton) {
    presentVoteModal()
  }
}
