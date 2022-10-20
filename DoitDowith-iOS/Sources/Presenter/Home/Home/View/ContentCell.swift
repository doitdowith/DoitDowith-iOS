//
//  ContentCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import RxCocoa
import RxSwift

protocol ContentCellDelegate: AnyObject {
  func contentCell(_ cell: UICollectionViewCell, didSelectCell: Card)
}
class ContentCell: UICollectionViewCell {
  static let identifier = "ContentCell"
  
  @IBOutlet weak var cardCollectionView: UICollectionView!
  weak var delegate: ContentCellDelegate?
  
  let disposeBag = DisposeBag()
  let modelRelay = PublishRelay<[Card]>()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    let cardCellNib = UINib(nibName: "CardCell", bundle: nil)
    self.cardCollectionView.register(cardCellNib,
                                     forCellWithReuseIdentifier: CardCell.identifier)
    
    self.cardCollectionView.collectionViewLayout = self.colletionViewLayout()
    
    self.modelRelay
      .bind(to: self.cardCollectionView.rx.items(cellIdentifier: CardCell.identifier,
                                                 cellType: CardCell.self)) { _, element, cell in
        cell.configure(title: element.title, subtitle: element.subTitle)
      }
                                                 .disposed(by: disposeBag)
    
    self.cardCollectionView.rx.modelSelected(Card.self)
      .bind(onNext: { model in
        self.delegate?.contentCell(self, didSelectCell: model)
      }).disposed(by: disposeBag)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
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
