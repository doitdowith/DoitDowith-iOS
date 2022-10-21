//
//  MisionRoomSecondViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol MissionRoomSecondViewModelInput {
  var passedData: PublishRelay<FirstRoomPassData> { get }
  var missionStartDate: PublishRelay<String> { get }
  var missionCertificateCount: PublishRelay<Int> { get }
  var missionFriendList: PublishRelay<[String]> { get }
}
protocol MissionRoomSecondViewModelOutput {
  var model: BehaviorRelay<[UIColor]> { get }
  var passData: Observable<MissionRoomRequest> { get }
}

protocol MissionRoomSecondViewModelType {
  var input: MissionRoomSecondViewModelInput { get }
  var output: MissionRoomSecondViewModelOutput { get }
}

final class MisionRoomSecondViewModel: MissionRoomSecondViewModelType,
                                       MissionRoomSecondViewModelInput,
                                       MissionRoomSecondViewModelOutput {
  var input: MissionRoomSecondViewModelInput { return self }
  var output: MissionRoomSecondViewModelOutput { return self }
  
  let passedData: PublishRelay<FirstRoomPassData>
  let missionStartDate: PublishRelay<String>
  let missionCertificateCount: PublishRelay<Int>
  let missionFriendList: PublishRelay<[String]>
  
  let model: BehaviorRelay<[UIColor]>
  let passData: Observable<MissionRoomRequest>
  
  init() {
    let colors = BehaviorRelay<[UIColor]>(value: [UIColor(red: 253/255, green: 236/255, blue: 236/255, alpha: 1),
                                                  UIColor(red: 253/255, green: 243/255, blue: 232/255, alpha: 1),
                                                  UIColor(red: 245/255, green: 247/255, blue: 229/255, alpha: 1),
                                                  UIColor(red: 229/255, green: 243/255, blue: 251/255, alpha: 1),
                                                  UIColor(red: 235/255, green: 235/255, blue: 252/255, alpha: 1),
                                                  UIColor(red: 255/255, green: 237/255, blue: 250/255, alpha: 1)])
    self.missionStartDate = PublishRelay<String>()
    self.missionCertificateCount = PublishRelay<Int>()
    self.missionFriendList = PublishRelay<[String]>()
    
    self.passedData = PublishRelay<FirstRoomPassData>()
    self.model = colors
    self.passData = Observable.zip(passedData,
                                   self.missionStartDate,
                                   self.missionCertificateCount,
                                   self.missionFriendList)
      .map { MissionRoomRequest(title: $0.0.name,
                              description: $0.0.description,
                              color: $0.0.color,
                              date: $0.1,
                              certificationCount: $0.2,
                              members: $0.3) }
  }
}
