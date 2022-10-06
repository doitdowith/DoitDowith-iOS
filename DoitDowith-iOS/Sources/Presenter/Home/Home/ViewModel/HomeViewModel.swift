//
//  HomeViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import RxCocoa
import RxDataSources
import RxSwift

protocol HomeViewModelInput {
  var fetchCards: PublishRelay<Void> { get }
  var indicatorPosition: BehaviorRelay<Int> { get }
}

protocol HomeViewModelOutput {
  var doingCardList: BehaviorRelay<[[CardModel]]> { get }
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
  let fetchCards: PublishRelay<Void>
  let indicatorPosition: BehaviorRelay<Int>
  
  // Output
  let doingCardList: BehaviorRelay<[[CardModel]]>
  let activated: Driver<Bool>
  
  init(service: HomeServiceProtocol) {
    let fetching = PublishRelay<Void>()
    let indicatorIndexing = BehaviorRelay<Int>(value: 0)
    let activating = BehaviorRelay<Bool>(value: false)
    let doingCards = BehaviorRelay<[[CardModel]]>(value: [])
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap(service.fetchCardList)
      .do(onNext: { _ in activating.accept(false) })
      .map { [$0.filter { $0.section == 0 },
              $0.filter { $0.section == 1 },
              $0.filter { $0.section == 2 }] }
      .subscribe(onNext: { doingCards.accept($0) })
      .disposed(by: disposeBag)
    
    // Input
    self.fetchCards = fetching
    self.indicatorPosition = indicatorIndexing
    
    // Output
    self.doingCardList = doingCards
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
  }
}
