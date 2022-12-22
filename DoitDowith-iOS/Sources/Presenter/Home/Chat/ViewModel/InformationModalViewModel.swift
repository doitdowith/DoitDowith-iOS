//
//  InformationModalViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/20.
//

import Foundation

import RxCocoa
import RxDataSources
import RxRelay
import RxSwift

protocol InformationModalViewModelInput {
  var chatroomInfo: BehaviorRelay<Card> { get }
}

protocol InformationModalViewModelOutput {
  var roomTitle: Driver<String> { get }
  var roomDescription: Driver<String> { get }
  var roomCount: Driver<String> { get }
  var roomDate: Driver<String> { get }
}

protocol InformationModalViewModelType: InformationModalViewModelInput,
                                        InformationModalViewModelOutput {
  var input: InformationModalViewModelInput { get }
  var output: InformationModalViewModelOutput { get }
}

final class InformationModalViewModel: InformationModalViewModelInput,
                           InformationModalViewModelOutput,
                           InformationModalViewModelType {
  let disposeBag = DisposeBag()
  var input: InformationModalViewModelInput { return self }
  var output: InformationModalViewModelOutput { return self }
  
  // Input
  let chatroomInfo: BehaviorRelay<Card>
  
  // Output
  let roomTitle: Driver<String>
  let roomDescription: Driver<String>
  let roomCount: Driver<String>
  let roomDate: Driver<String>
  
  init(card: Card) {
    self.chatroomInfo = BehaviorRelay<Card>(value: card)
    self.roomTitle = chatroomInfo.map { $0.title }.asDriver(onErrorJustReturn: "")
    self.roomDescription = chatroomInfo.map { $0.description }.asDriver(onErrorJustReturn: "")
    self.roomCount = chatroomInfo
      .map { _ -> String in
        return "7일동안 \(2)회 인증" }
      .asDriver(onErrorJustReturn: "")
    self.roomDate = chatroomInfo
      .map { $0.startDate.toDate() }
      .map { date in
        guard let date = date else { return "" }
        let nextDate = date.addingTimeInterval(3600 * 24 * 7)
        return "\(date.formatted(format: "yyyy-MM-dd")) ~ \(nextDate.formatted(format: "yyyy-MM-dd"))"
      }
      .asDriver(onErrorJustReturn: "")
  }
}
