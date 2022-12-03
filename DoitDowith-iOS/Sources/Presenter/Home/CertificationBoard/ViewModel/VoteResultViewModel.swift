//
//  VoteResultViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/02.
//

import Foundation

import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

typealias VoteSectionModel = AnimatableSectionModel<Int, VoteMemberList>
typealias VoteDataSource = RxCollectionViewSectionedAnimatedDataSource<VoteSectionModel>

protocol VoteResultViewModelInput {
  var fetchData: PublishRelay<Void> { get }
}

protocol VoteResultViewModelOutput {
  var activated: Driver<Bool> { get }
  var voteMemberList: Driver<[VoteSectionModel]> { get }
  var voteMemberViewDataSource: VoteDataSource { get }
}

protocol VoteResultViewModelType {
  var input: VoteResultViewModelInput { get }
  var output: VoteResultViewModelOutput { get }
}

class VoteResultViewModel: VoteResultViewModelInput,
                           VoteResultViewModelOutput,
                           VoteResultViewModelType {
  let disposeBag = DisposeBag()
  var input: VoteResultViewModelInput { return self }
  var output: VoteResultViewModelOutput { return self }
  
  let fetchData: PublishRelay<Void>
  
  let activated: Driver<Bool>
  let voteMemberList: Driver<[VoteSectionModel]>
  let voteMemberViewDataSource: VoteDataSource
  
  let a = "https://wikiimg.tojsiabtv.com/wikipedia/commons/thumb/e/e6/Noto_Emoji_KitKat_263a.svg/1200px-Noto_Emoji_KitKat_263a.svg.png"
  let b = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Twemoji_1f600.svg/1200px-Twemoji_1f600.svg.png"
  
  init(service: HomeAPIProtocol) {
    let c: [VoteMember] = [.init(type: 0, profileImageUrl: a, nickName: "김1", emojiUrl: b),
                           .init(type: 0, profileImageUrl: a, nickName: "김2", emojiUrl: b),
                           .init(type: 0, profileImageUrl: a, nickName: "김3", emojiUrl: b),
                           .init(type: 0, profileImageUrl: a, nickName: "김4", emojiUrl: b)]
    
    let d: [VoteMember] =  [.init(type: 1, profileImageUrl: a, nickName: "이1", emojiUrl: b),
                            .init(type: 1, profileImageUrl: a, nickName: "이2", emojiUrl: b),
                            .init(type: 1, profileImageUrl: a, nickName: "이3", emojiUrl: b),
                            .init(type: 1, profileImageUrl: a, nickName: "이4", emojiUrl: b)]
    
    let e: [VoteMember] =  [.init(type: 2, profileImageUrl: a, nickName: "박1", emojiUrl: b),
                            .init(type: 2, profileImageUrl: a, nickName: "박2", emojiUrl: b),
                            .init(type: 2, profileImageUrl: a, nickName: "박3", emojiUrl: b),
                            .init(type: 2, profileImageUrl: a, nickName: "박4", emojiUrl: b)]
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let voteMembers = BehaviorRelay<[VoteSectionModel]>(value: [.init(model: 0, items: [.init(type: .all, data: c),
                                                                                        .init(type: .good, data: d),
                                                                                        .init(type: .bad, data: e)])])
    
        fetching
          .do(onNext: { _ in activating.accept(true) })
          .flatMap { _ -> Single<[VoteMember]> in
            return service.getVoteMemberList(request: VoteMemberListRequest(id: 1))
          }
          .do(onNext: { _ in activating.accept(false) })
            .map { members -> [VoteSectionModel] in
              return [VoteSectionModel(model: 0, items: [.init(type: .all, data: members),
                                                         .init(type: .good, data: members.filter { $0.type == 1 }),
                                                         .init(type: .bad, data: members.filter { $0.type == 2 })])]
          }
            .bind(onNext: { voteMembers.accept($0) })
            .disposed(by: disposeBag)
    
    // Input
    self.fetchData = fetching
    
    // Output
    self.voteMemberList = voteMembers.asDriver(onErrorJustReturn: [])
    self.voteMemberViewDataSource = VoteDataSource { _, collectionView, indexPath, item in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoteResultContentViewCell.identifier,
                                                          for: indexPath) as? VoteResultContentViewCell else {
        return UICollectionViewCell()
      }
      
      cell.modelRelay.accept(item.data)
      return cell
    }
    
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
  }
}
