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
  
  // Input
  let viewWillApper: PublishRelay<Void>
  
  // Output
  let frieindList: BehaviorRelay<[Friend]>
  let friendNumber: Driver<Int>
  
  init(id: Int, service: HomeAPIProtocol) {
    let fetching = PublishRelay<Void>()
    let friends = BehaviorRelay<[Friend]>(value: [])
    
    self.frieindList = friends
    self.friendNumber = friends.map { $0.count }.asDriver(onErrorJustReturn: 0)
    self.viewWillApper = fetching
  }
}
