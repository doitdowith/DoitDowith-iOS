//
//  HomeViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import Action
import NSObject_Rx
import RxCocoa
import RxDataSources
import RxSwift

protocol HomeViewModelInput {
  var viewWillAppear: PublishRelay<Void> { get }
}

protocol HomeViewModelOutput {
  var cardList: Driver<[SectionOfCardModel]> { get }
  var cardDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfCardModel> { get }
  var activated: Driver<Bool> { get }
}

protocol HomeViewModelType: HomeViewModelInput,
                            HomeViewModelOutput {
  var input: HomeViewModelInput { get }
  var output: HomeViewModelOutput { get }
}

final class HomeViewModel: HomeViewModelInput,
                           HomeViewModelOutput,
                           HomeViewModelType {
  let disposeBag = DisposeBag()
  var input: HomeViewModelInput { return self }
  var output: HomeViewModelOutput { return self }
  
  // Input
  let viewWillAppear: PublishRelay<Void>
  
  // Output
  let cardList: Driver<[SectionOfCardModel]>
  let cardDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfCardModel>
  let activated: Driver<Bool>
  
  init(service: HomeServiceProtocol) {
    let fetching = PublishRelay<Void>()
    let allCards = BehaviorRelay<[CardModel]>(value: [])
    let activating = BehaviorRelay<Bool>(value: false)
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap(service.fetchCardList)
      .do(onNext: { _ in activating.accept(false) })
      .subscribe(onNext: { allCards.accept($0) })
      .disposed(by: disposeBag)
    
        self.viewWillAppear = fetching
    self.activated = activating
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)
        
      self.cardList = allCards.map { card in
          var section = [SectionOfCardModel]()
          var firstItems = [CardModel]()
          var secondItems = [CardModel]()
          var thirdItems = [CardModel]()
          card.forEach {
            switch $0.section {
            case 1:
              firstItems.append($0)
            case 2:
              secondItems.append($0)
            case 3:
              thirdItems.append($0)
            default:
              break
            }
          }
          section.append(SectionOfCardModel(header: "1", items: firstItems))
          section.append(SectionOfCardModel(header: "2", items: secondItems))
          section.append(SectionOfCardModel(header: "3", items: thirdItems))
          return section
        }.asDriver(onErrorJustReturn: [])
    
    self.cardDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCardModel>(configureCell: { _, collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.identifier, for: indexPath) as? ContentCell else {
        return UICollectionViewCell()
      }
      cell.configure(title: item.title, subtitle: item.subTitle)
      return cell
    })
  }
}
