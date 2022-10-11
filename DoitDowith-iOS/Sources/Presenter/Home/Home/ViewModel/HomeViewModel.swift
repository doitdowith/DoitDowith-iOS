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
  var indicatorIndex: BehaviorRelay<Int> { get }
  var buttonClickIndex: BehaviorRelay<Int> { get }
}

protocol HomeViewModelOutput {
  var doingCardList: BehaviorRelay<[[CardModel]]> { get }
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
  let doingCardList: BehaviorRelay<[[CardModel]]>
  let activated: Driver<Bool>
  let doingButtonColor: Driver<UIColor>
  let willDoButtonColor: Driver<UIColor>
  let doneButtonColor: Driver<UIColor>
  
  init(service: HomeServiceProtocol) {
    let fetching = PublishRelay<Void>()
    let indicatorIndexing = BehaviorRelay<Int>(value: 0)
    let buttonIndexing = BehaviorRelay<Int>(value: 0)
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
    self.indicatorIndex = indicatorIndexing
    self.buttonClickIndex = buttonIndexing
    
    // Output
    self.doingCardList = doingCards
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
    
    self.doingButtonColor = buttonIndexing
      .map { $0 == 0 ?
        UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1) :
        UIColor(red: 169/255, green: 175/255, blue: 185/255, alpha: 1)}
      .asDriver(onErrorJustReturn: UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1))
    
    self.willDoButtonColor = buttonIndexing
      .map { $0 == 1 ?
        UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1) :
        UIColor(red: 169/255, green: 175/255, blue: 185/255, alpha: 1)}
      .asDriver(onErrorJustReturn: UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1))
    
    self.doneButtonColor = buttonIndexing
      .map { $0 == 2 ?
        UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1) :
        UIColor(red: 169/255, green: 175/255, blue: 185/255, alpha: 1)}
      .asDriver(onErrorJustReturn: UIColor(red: 67/255, green: 136/255, blue: 238/255, alpha: 1))
  }
}
