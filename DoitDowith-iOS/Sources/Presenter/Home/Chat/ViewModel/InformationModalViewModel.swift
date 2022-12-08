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
  var chatroomInfo: PublishRelay<Card> { get }
}

protocol InformationModalViewModelOutput {
  var roomTitle: Driver<String> { get }
  var roomDescription: Driver<String> { get }
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
  let chatroomInfo: PublishRelay<Card>
  
  // Output
  let roomTitle: Driver<String>
  let roomDescription: Driver<String>
  
  init() {
    self.chatroomInfo = PublishRelay<Card>()
    self.roomTitle = chatroomInfo.map { $0.title }.asDriver(onErrorJustReturn: "")
    self.roomDescription = chatroomInfo.map { $0.description }.asDriver(onErrorJustReturn: "")
  }
}
