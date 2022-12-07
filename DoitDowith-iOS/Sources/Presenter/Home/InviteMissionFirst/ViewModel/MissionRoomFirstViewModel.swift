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
  var missionColors: Driver<[UIColor]> { get }
  var passData: Observable<FirstRoomPassData> { get }
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
  let missionColors: Driver<[UIColor]>
  let passData: Observable<FirstRoomPassData>
  
  init() {
    self.currentMissionName = PublishRelay<String>()
    self.currentMissionDetail = PublishRelay<String>()
    self.currentMissionColor = PublishRelay<String>()
    
    let colors = BehaviorRelay<[UIColor]>(value: [UIColor(red: 253/255, green: 236/255, blue: 236/255, alpha: 1),
                                                  UIColor(red: 253/255, green: 243/255, blue: 232/255, alpha: 1),
                                                  UIColor(red: 245/255, green: 247/255, blue: 229/255, alpha: 1),
                                                  UIColor(red: 229/255, green: 243/255, blue: 251/255, alpha: 1),
                                                  UIColor(red: 235/255, green: 235/255, blue: 252/255, alpha: 1),
                                                  UIColor(red: 255/255, green: 237/255, blue: 250/255, alpha: 1)])
    
    let enable = Observable
      .combineLatest(currentMissionName,
                     currentMissionDetail,
                     currentMissionColor)
      .map { (name, detail, _) -> Bool in
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
    self.missionColors = colors.asDriver(onErrorJustReturn: [UIColor]())
    self.passData = Observable
      .zip(self.currentMissionName.asObservable(),
           self.currentMissionDetail.asObservable(),
           self.currentMissionColor.asObservable())
      .map { FirstRoomPassData(name: $0.0, description: $0.1, color: $0.2) }
  }
}
