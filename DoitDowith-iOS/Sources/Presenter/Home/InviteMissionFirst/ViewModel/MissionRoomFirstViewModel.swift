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

protocol MissionRoomFirstViewModelInput {
  var currentMissionName: PublishRelay<String> { get }
  var currentMissionDetail: PublishRelay<String> { get }
  var currentMissionColor: PublishRelay<Int> { get }
}

protocol MissionRoomFirstViewModelOutput {
  var missionColors: BehaviorRelay<[UIColor]> { get }
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
  let currentMissionColor: PublishRelay<Int>
  
  // Output
  let missionColors: BehaviorRelay<[UIColor]>
  
  init() {
    self.currentMissionName = PublishRelay<String>()
    self.currentMissionDetail = PublishRelay<String>()
    self.currentMissionColor = PublishRelay<Int>()
    
    let colors = BehaviorRelay<[UIColor]>(value: [UIColor(red: 253/255, green: 236/255, blue: 236/255, alpha: 1),
                                                  UIColor(red: 253/255, green: 243/255, blue: 232/255, alpha: 1),
                                                  UIColor(red: 245/255, green: 247/255, blue: 229/255, alpha: 1),
                                                  UIColor(red: 229/255, green: 243/255, blue: 251/255, alpha: 1),
                                                  UIColor(red: 235/255, green: 235/255, blue: 252/255, alpha: 1),
                                                  UIColor(red: 255/255, green: 237/255, blue: 250/255, alpha: 1)])
  
    self.missionColors = colors
  }
}
