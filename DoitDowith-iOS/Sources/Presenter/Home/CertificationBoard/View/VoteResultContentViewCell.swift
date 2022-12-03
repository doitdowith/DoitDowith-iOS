//
//  VoteResultContentViewCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/03.
//

import UIKit

import RxCocoa
import RxRelay
import RxSwift

class VoteResultContentViewCell: UICollectionViewCell {
  static let identifier: String = "VoteResultContentViewCell"
  
  let disposeBag = DisposeBag()
  let modelRelay = PublishRelay<[VoteMember]>()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let cellNib = UINib(nibName: "VoteMemberCell", bundle: nil)
    self.collectionView.register(cellNib,
                                 forCellWithReuseIdentifier: VoteMemberCell.identifier)
    
    self.collectionView.collectionViewLayout = self.colletionViewLayout()
    
    self.modelRelay
      .bind(to: self.collectionView.rx.items(cellIdentifier: VoteMemberCell.identifier,
                                             cellType: VoteMemberCell.self)) { _, element, cell in
        cell.configure(with: element)
      }.disposed(by: disposeBag)
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(36))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(36))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
}
