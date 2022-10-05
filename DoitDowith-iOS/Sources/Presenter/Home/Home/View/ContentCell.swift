//
//  ContentCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import RxCocoa
import RxSwift
import RxViewController

class ContentCell: UICollectionViewCell {
  static let identifier = "ContentCell"
  @IBOutlet weak var cardCollectionView: UICollectionView!
  var model: [CardModel] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let cardCellNib = UINib(nibName: "CardCell", bundle: nil)
    self.cardCollectionView.register(cardCellNib,
                                        forCellWithReuseIdentifier: CardCell.identifier)
    self.cardCollectionView.collectionViewLayout = self.colletionViewLayout()
    cardCollectionView.delegate = self
    cardCollectionView.dataSource = self
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  func configure(model: [CardModel]) {
    self.model = model
  }
  
  func colletionViewLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(125))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(125))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                   subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 14
    return UICollectionViewCompositionalLayout(section: section)
  }
}

extension ContentCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else { return UICollectionViewCell() }
    cell.configure(title: model[indexPath.row].title, subtitle: model[indexPath.row].subTitle)
    return cell
  }
}
