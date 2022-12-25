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
  var fetchFriends: PublishRelay<Void> { get }
  var missionStartDate: PublishRelay<String> { get }
  var missionCertificateCount: PublishRelay<String> { get }
  var selectFriends: BehaviorRelay<[Friend]> { get }
}
protocol MissionRoomSecondViewModelOutput {
  var buttonEnabled: Driver<Bool> { get }
  var buttonColor: Driver<UIColor> { get }
  var model: Driver<[String]> { get }
  var friendList: Driver<[Friend]> { get }
  var selectedFriends: Driver<[String]> { get }
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
  
  let fetchFriends: PublishRelay<Void>
  let missionStartDate: PublishRelay<String>
  let missionCertificateCount: PublishRelay<String>
  let selectFriends: BehaviorRelay<[Friend]>
  
  let buttonEnabled: Driver<Bool>
  let buttonColor: Driver<UIColor>
  let model: Driver<[String]>
  let friendList: Driver<[Friend]>
  let selectedFriends: Driver<[String]>
  
  init() {
    let memberId = UserDefaults.standard.string(forKey: "memberId")
    let imageUrl = UserDefaults.standard.string(forKey: "profileImage")
    let name = UserDefaults.standard.string(forKey: "name")
    
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let startDate = PublishRelay<String>()
    let select = BehaviorRelay<[Friend]>(value: [])
    let count = PublishRelay<String>()
    
    let friends = BehaviorRelay<[Friend]>(value: [])
    
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
      .bind(onNext: { friends.accept($0) })
      .disposed(by: disposeBag)
    
    let enable = Observable
      .combineLatest(startDate, count)
      .map { (date, count) -> Bool in
        return !date.isEmpty && !count.isEmpty }
    
    self.fetchFriends = fetching
    self.missionStartDate = startDate
    self.missionCertificateCount = count
    self.selectFriends = select
  
    self.buttonEnabled = enable.asDriver(onErrorJustReturn: false)
    self.buttonColor = enable.map { can -> UIColor in
      if can {
        return .primaryColor2
      } else {
        return .primaryColor4
      }
    }.asDriver(onErrorJustReturn: .primaryColor4)
    self.model = select.map { $0.map { $0.url } }
                        .map { [imageUrl!] + $0 }
                        .asDriver(onErrorJustReturn: [])
    self.friendList = friends.asDriver(onErrorJustReturn: [])
    self.selectedFriends = select.map { $0.map { $0.id } }
                                 .map { [memberId!] + $0 }
                                 .asDriver(onErrorJustReturn: [])
  }
}
