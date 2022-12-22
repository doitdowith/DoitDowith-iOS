//
//  InviteModalViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/14.
//

import Foundation

import RxCocoa
import RxRelay
import RxSwift

protocol InviteModalViewModelInput {
  var viewWillApper: PublishRelay<Void> { get }
}

protocol InviteModalViewModelOutput {
  var friendNumber: Driver<Int> { get }
  var frieindList: BehaviorRelay<[Friend]> { get }
}

protocol InviteModalViewModelType: InviteModalViewModelInput,
                                   InviteModalViewModelOutput {
  var input: InviteModalViewModelInput { get }
  var output: InviteModalViewModelOutput { get }
}

final class InviteModalViewModel: InviteModalViewModelInput,
                                  InviteModalViewModelOutput,
                                  InviteModalViewModelType {
  var input: InviteModalViewModelInput { return self }
  var output: InviteModalViewModelOutput { return self }
  
  let disposeBag = DisposeBag()
  // Input
  let viewWillApper: PublishRelay<Void>
  
  // Output
  let frieindList: BehaviorRelay<[Friend]>
  let friendNumber: Driver<Int>
  
  init() {
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
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
    
    self.frieindList = friends
    self.friendNumber = friends.map { $0.count }.asDriver(onErrorJustReturn: 0)
    self.viewWillApper = fetching
  }
}
