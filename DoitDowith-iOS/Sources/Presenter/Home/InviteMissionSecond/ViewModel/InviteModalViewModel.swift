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
  
  let url = ["https://img.hankyung.com/photo/202208/03.30968100.1.jpg",
             "https://mblogthumb-phinf.pstatic.net/MjAxODEwMTlfMTgx/MDAxNTM5OTI4MjAwNDEx.k7oG-Q0tA6bdI1smaMzsK4t08NREjRrq3OthZKoIz8Qg.BeZxWi7HekwTWipOckbNWpvnesXuHjpldNGA7QppprUg.JPEG.retspe/eb13.jpg?type=w800",
             "https://www.korea.kr/goNewsRes/attaches/innods/images/000088/32_640.jpg",
             "https://www.jungle.co.kr/image/abf6121743c2afa9cf97332d",
             "https://www.kocca.kr/cmm/fnw/getImage.do?atchFileId=FILE_000000001097009&fileSn=1",
             "https://mir-s3-cdn-cf.behance.net/projects/404/760686114652663.Y3JvcCw4MDgsNjMyLDAsMA.png",
             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCTnkfkeA6mFkBzzTPVWh2KwZKEF3dJRn03g&usqp=CAU"
  ]
  
  init(memberId: Int) {
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let friends = BehaviorRelay<[Friend]>(value: [Friend(id: 2, url: url[0], state: .can, name: "이예림"),
                                                  Friend(id: 3, url: url[1], state: .fail, name: "박재영"),
                                                  Friend(id: 4, url: url[2], state: .can, name: "조구영"),
                                                  Friend(id: 5, url: url[4], state: .can, name: "김영균"),
                                                  Friend(id: 6, url: url[5], state: .can, name: "해범이"),
                                                  Friend(id: 5, url: url[6], state: .fail, name: "지민석")
                                                 ])
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap { _ -> Single<[Friend]> in
        let request = FriendRequest(id: memberId)
        return HomeAPI.shared.getFriendList(request: request)
      }
      .catchAndReturn([])
      .do(onNext: { _ in activating.accept(false) })
      .bind(onNext: { friends.accept($0) })
      .disposed(by: disposeBag)
    
    self.frieindList = friends
    self.friendNumber = friends.map { $0.count }.asDriver(onErrorJustReturn: 0)
    self.viewWillApper = fetching
  }
}
