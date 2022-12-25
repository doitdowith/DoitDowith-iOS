//
//  MissionRoomFirstViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/11.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

struct FirstRoomPassData {
  let name: String
  let description: String
  let color: String
}

protocol MissionRoomFirstViewModelInput {
  var currentMissionName: PublishRelay<String> { get }
  var currentMissionDetail: PublishRelay<String> { get }
  var currentMissionColor: PublishRelay<String> { get }
}

protocol MissionRoomFirstViewModelOutput {
  var buttonEnabled: Driver<Bool> { get }
  var buttonColor: Driver<UIColor> { get }
  var missionColors: Driver<[Int]> { get }
}

protocol MissionRoomFirstViewModelType {
  var input: MissionRoomFirstViewModelInput { get }
  var output: MissionRoomFirstViewModelOutput { get }
}

final class MissionRoomFirstViewModel: MissionRoomFirstViewModelInput,
                                       MissionRoomFirstViewModelOutput,
                                       MissionRoomFirstViewModelType {
  var disposeBag = DisposeBag()
  var input: MissionRoomFirstViewModelInput { return self }
  var output: MissionRoomFirstViewModelOutput { return self }
  
  // Input
  let currentMissionName: PublishRelay<String>
  let currentMissionDetail: PublishRelay<String>
  let currentMissionColor: PublishRelay<String>
  
  // Output
  let buttonEnabled: Driver<Bool>
  let buttonColor: Driver<UIColor>
  let missionColors: Driver<[Int]>
  
  init() {
    self.currentMissionName = PublishRelay<String>()
    self.currentMissionDetail = PublishRelay<String>()
    self.currentMissionColor = PublishRelay<String>()
    
    let colors = BehaviorRelay<[Int]>(value: [0xFDECEC,
                                              0xFDF3E8,
                                              0xF5F7E5,
                                              0xE5F3FB,
                                              0xEBEBFC,
                                              0xFFEDFA])
    
    let combined = PublishRelay.combineLatest(currentMissionName,
                                              currentMissionDetail,
                                              currentMissionColor)
    let enable = combined.map { (name, detail, _) -> Bool in
      return !name.isEmpty && !detail.isEmpty
    }
    
    self.buttonEnabled = enable.asDriver(onErrorJustReturn: false)
    self.buttonColor = enable.map { can -> UIColor in
      if can {
        return .primaryColor2
      } else {
        return .primaryColor4
      }
    }.asDriver(onErrorJustReturn: .primaryColor4)
    self.missionColors = colors.asDriver(onErrorJustReturn: [Int]())
  }
}
