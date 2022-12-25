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
import Action

protocol MissionRoomSecondViewModelInput {
  var missionStartDate: PublishRelay<String> { get }
  var missionCertificateCount: PublishRelay<String> { get }
  var missionFriendList: BehaviorRelay<[Friend]> { get }
}
protocol MissionRoomSecondViewModelOutput {
  var buttonEnabled: Driver<Bool> { get }
  var buttonColor: Driver<UIColor> { get }
  var model: Driver<[String]> { get }
  var selectedFriend: Driver<[String]> { get }
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
  let disposeBag: DisposeBag = DisposeBag()
  
  let missionStartDate: PublishRelay<String>
  let missionCertificateCount: PublishRelay<String>
  let missionFriendList: BehaviorRelay<[Friend]>
  
  let buttonEnabled: Driver<Bool>
  let buttonColor: Driver<UIColor>
  let model: Driver<[String]>
  let selectedFriend: Driver<[String]>
  
  init() {
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let friendsList = BehaviorRelay<[Friend]>(value: [])
    let startDate = PublishRelay<String>()
    let count = PublishRelay<String>()
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap { _ -> Observable<[Friend]> in
        let request = RequestType(endpoint: "friends/my", method: .get)
        return APIService.shared.request(request: request)
          .map { (response: FriendResponse) -> [Friend] in
            return response.toDomain
          }
      }
      .do(onNext: { _ in activating.accept(false) })
      .map { (friendList: [Friend]) -> [Friend] in
        var friends = friendList
        guard let memberId = UserDefaults.standard.string(forKey: "memberId"),
              let imageUrl = UserDefaults.standard.string(forKey: "profileImage"),
              let name = UserDefaults.standard.string(forKey: "name") else {
          return friends
        }
        friends.insert(Friend(id: memberId,
                              url: imageUrl,
                              state: .ing,
                              name: name),
                       at: 0)
        return friends
      }
      .bind(onNext: { friends in friendsList.accept(friends) })
      .disposed(by: disposeBag)
    
    let enable = Observable
      .combineLatest(startDate, count)
      .map { (date, count) -> Bool in
        return !date.isEmpty && !count.isEmpty }
    
    self.missionStartDate = startDate
    self.missionCertificateCount = count
    self.missionFriendList = friendsList
    self.buttonEnabled = enable.asDriver(onErrorJustReturn: false)
    self.buttonColor = enable.map { can -> UIColor in
      if can {
        return .primaryColor2
      } else {
        return .primaryColor4
      }
    }.asDriver(onErrorJustReturn: .primaryColor4)
    self.model = missionFriendList.map { $0.map { $0.url } }.asDriver(onErrorJustReturn: [])
    self.selectedFriend = missionFriendList.map { $0.map { $0.id } }.asDriver(onErrorJustReturn: [])
  }
}
