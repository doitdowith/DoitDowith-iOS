//
//  HomeViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift

typealias HomeSectionModel = AnimatableSectionModel<Int, CardList>

protocol HomeViewModelInput {
  var fetchCards: PublishRelay<Void> { get }
  var indicatorIndex: BehaviorRelay<Int> { get }
  var buttonClickIndex: BehaviorRelay<Int> { get }
}

protocol HomeViewModelOutput {
  var cardList: Driver<[HomeSectionModel]> { get }
  var activated: Driver<Bool> { get }
  var doingButtonColor: Driver<UIColor> { get }
  var willDoButtonColor: Driver<UIColor> { get }
  var doneButtonColor: Driver<UIColor> { get }
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
  let fetchCards: PublishRelay<Void>
  let indicatorIndex: BehaviorRelay<Int>
  let buttonClickIndex: BehaviorRelay<Int>
  
  // Output
  let cardList: Driver<[HomeSectionModel]>
  let activated: Driver<Bool>
  let doingButtonColor: Driver<UIColor>
  let willDoButtonColor: Driver<UIColor>
  let doneButtonColor: Driver<UIColor>
  
  init(service: HomeAPIProtocol) {
    let fetching = PublishRelay<Void>()
    let indicatorIndexing = BehaviorRelay<Int>(value: 0)
    let buttonIndexing = BehaviorRelay<Int>(value: 0)
    let activating = BehaviorRelay<Bool>(value: false)
    let sectionCards = BehaviorRelay<[HomeSectionModel]>(value: [])
    
//    fetching
//      .do(onNext: { _ in activating.accept(true) })
//      .flatMap { _ -> Single<[Card]> in
//        let request = CardRequest(id: 1)
//        return service.getDoingCard(request: request)
//      }
//      .do(onNext: { _ in activating.accept(false) })
//      .map({ cards -> [HomeSectionModel] in
//        return [.init(model: 0, items: [CardList(type: .doing, data: cards.filter { $0.section == 1 }),
//                                        CardList(type: .willdo, data: cards.filter { $0.section == 2 }),
//                                        CardList(type: .done, data: cards.filter { $0.section == 3 })])]
//      })
//      .bind(onNext: { sectionCards.accept($0) })
//      .disposed(by: disposeBag)
        
    // Input
    self.fetchCards = fetching
    self.indicatorIndex = indicatorIndexing
    self.buttonClickIndex = buttonIndexing
      
    // Output
    self.cardList = sectionCards.asDriver(onErrorJustReturn: [])
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
    
    self.doingButtonColor = buttonIndexing
      .map { $0 == 0 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
    
    self.willDoButtonColor = buttonIndexing
      .map { $0 == 1 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
    
    self.doneButtonColor = buttonIndexing
      .map { $0 == 2 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
  }
}
