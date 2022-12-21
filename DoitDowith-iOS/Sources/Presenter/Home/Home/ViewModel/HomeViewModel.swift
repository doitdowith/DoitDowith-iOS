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
  
  // Output
  let cardList: Driver<[HomeSectionModel]>
  let activated: Driver<Bool>
  let doingButtonColor: Driver<UIColor>
  let willDoButtonColor: Driver<UIColor>
  let doneButtonColor: Driver<UIColor>
  
  init() {
    let emptyCards: [HomeSectionModel] = [.init(model: 0, items: [.init(type: .none, data: []),
                                                                  .init(type: .none, data: []),
                                                                  .init(type: .none, data: [])])
    ]
    let fetching = PublishRelay<Void>()
    let indicatorIndexing = BehaviorRelay<Int>(value: 0)
    let activating = BehaviorRelay<Bool>(value: false)
    let sectionCards = BehaviorRelay<[HomeSectionModel]>(value: emptyCards)
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap { _ -> Observable<[Card]> in
        let request = RequestType(endpoint: "room",
                                  method: .get)
        return APIService.shared.request(request: request)
          .map { (response: CardResponse) -> [Card] in
            return response.toDomain
          }
      }
      .do(onNext: { _ in activating.accept(false) })
      .filter { !$0.isEmpty }
      .bind(onNext: { cards in
        let none: CardList = .init(type: .none, data: [])
        let doing = cards.filter { $0.section == 1 }
        let willdo = cards.filter { $0.section == 2 }
        let done = cards.filter { $0.section == 3 }
        let sectionModel: [HomeSectionModel] = [ .init(model: 0,
                                                       items: [doing.isEmpty ? none : CardList(type: .doing, data: doing),
                                                               willdo.isEmpty ? none : CardList(type: .willdo, data: willdo),
                                                               done.isEmpty ? none : CardList(type: .done, data: done)])
        ]
        sectionCards.accept(sectionModel)
      })
      .disposed(by: disposeBag)
        
        // Input
    self.fetchCards = fetching
    self.indicatorIndex = indicatorIndexing
        
        // Output
    self.cardList = sectionCards.asDriver(onErrorJustReturn: emptyCards)
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
        
    self.doingButtonColor = indicatorIndexing
      .map { $0 == 0 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
    
    self.willDoButtonColor = indicatorIndexing
      .map { $0 == 1 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
    
    self.doneButtonColor = indicatorIndexing
      .map { $0 == 2 ? .primaryColor2 : .coolGray2 }
      .asDriver(onErrorJustReturn: .primaryColor2)
  }
}
