//
//  CertificationBoardViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import UIKit

import RxCocoa
import RxSwift
import RxViewController
import NSObject_Rx

class CertificationBoardViewController: UIViewController {
  var viewModel: CertificationBoardViewModelType
  
  init?(coder: NSCoder, viewModel: CertificationBoardViewModel) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.certificationBoardView.collectionViewLayout = layout()
    register()
    bind()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var navigationTitleLabel: UILabel!
  @IBOutlet weak var certificationBoardView: UICollectionView!
  // @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

extension CertificationBoardViewController {
  func register() {
    let certificationPostWithImageCellNib = UINib(nibName: "CertificationPostWithImageCell", bundle: nil)
    certificationBoardView.register(certificationPostWithImageCellNib,
                                    forCellWithReuseIdentifier: CertificationPostWithImageCell.identifier)
    let certificationPostCellNib = UINib(nibName: "CertificationPostCell", bundle: nil)
    certificationBoardView.register(certificationPostCellNib,
                                    forCellWithReuseIdentifier: CertificationPostCell.identifier)
  }
}

extension CertificationBoardViewController {
  func bind() {
    bindLifeCycle()
    bindCertificationBoardView()
    // bindActivityIndicator()
  }
  
  func bindCertificationBoardView() {
    self.viewModel.output.certificatePostList
      .drive(certificationBoardView.rx.items(dataSource: self.viewModel.output.dataSource))
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
  }
  /*
   func bindActivityIndicator() {
   viewModel.output.activated
   .drive(self.activityIndicator.rx.isHidden)
   .disposed(by: rx.disposeBag)
   }
   */
}

extension CertificationBoardViewController {
  func layout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .estimated(500))
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
}
