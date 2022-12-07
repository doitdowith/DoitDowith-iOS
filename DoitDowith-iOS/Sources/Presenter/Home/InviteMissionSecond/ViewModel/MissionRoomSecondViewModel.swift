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
  var missionCertificateCount: PublishRelay<String> { get }
  var missionFriendList: BehaviorRelay<[Friend]> { get }
}
protocol MissionRoomSecondViewModelOutput {
  var buttonEnabled: Driver<Bool> { get }
  var buttonColor: Driver<UIColor> { get }
  var model: Driver<[String]> { get }
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
  let missionCertificateCount: PublishRelay<String>
  let missionFriendList: BehaviorRelay<[Friend]>
  
  let buttonEnabled: Driver<Bool>
  let buttonColor: Driver<UIColor>
  let model: Driver<[String]>
  let passData: Observable<MissionRoomRequest>
  
  init() {
    let myimage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJ5iqjI9Lka_8V84HSC_1Df8ZdVK1otORRVGJwYWDPFw&s"
    self.missionStartDate = PublishRelay<String>()
    self.missionCertificateCount = PublishRelay<String>()
    self.missionFriendList = BehaviorRelay<[Friend]>(value: [Friend(id: 1, url: myimage, state: .ing, name: "김영균")])
    self.passedData = PublishRelay<FirstRoomPassData>()
    
    let enable = Observable
      .combineLatest(missionStartDate,
                     missionCertificateCount)
      .map { (date, count) -> Bool in
        return !date.isEmpty && !count.isEmpty
      }
    
    self.buttonEnabled = enable.asDriver(onErrorJustReturn: false)
    self.buttonColor = enable.map { can -> UIColor in
      if can {
        return .primaryColor2
      } else {
        return .primaryColor4
      }
    }.asDriver(onErrorJustReturn: .primaryColor4)
    
    self.model = missionFriendList.map { $0.map { $0.url } }.asDriver(onErrorJustReturn: [])
    self.passData = Observable
      .zip(passedData,
           self.missionStartDate,
           self.missionCertificateCount,
           self.missionFriendList)
      .map { firstData, startDate, count, friendList in
        return MissionRoomRequest(title: firstData.name,
                                  description: firstData.description,
                                  color: firstData.color,
                                  date: startDate,
                                  certificationCount: Int(count)!,
                                  members: friendList) }
      .do(onNext: { request in
        HomeAPI.shared.postChatRoom(request: request)
      })
  }
}
