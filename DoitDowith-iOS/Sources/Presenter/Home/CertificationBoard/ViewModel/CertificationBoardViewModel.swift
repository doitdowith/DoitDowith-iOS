//
//  CertificationBoardViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/23.
//

import Foundation

import RxCocoa
import RxSwift
import RxRelay
import RxDataSources

typealias PostSectionModel = AnimatableSectionModel<Int, CertificationPost>

protocol CertificationBoardViewModelInput {
  var fetchPosts: PublishRelay<Void> { get }
}

protocol CertificationBoardViewModelOutput {
  var activated: Driver<Bool> { get }
  var roomTitle: Driver<String> { get }
  var certificatePostList: Driver<[PostSectionModel]> { get }
}

protocol CertificationBoardViewModelType {
  var input: CertificationBoardViewModelInput { get }
  var output: CertificationBoardViewModelOutput { get }
}

class CertificationBoardViewModel: CertificationBoardViewModelInput,
                                   CertificationBoardViewModelOutput,
                                   CertificationBoardViewModelType {
  let disposeBag = DisposeBag()
  var input: CertificationBoardViewModelInput { return self }
  var output: CertificationBoardViewModelOutput { return self }
  
  let fetchPosts: PublishRelay<Void>
  let roomTitle: Driver<String>
  
  let activated: Driver<Bool>
  let certificatePostList: Driver<[PostSectionModel]>
  
  init(card: Card, chatService: ChatServiceProtocol) {
    let fetching = PublishRelay<Void>()
    let currentCard = BehaviorRelay<Card>(value: card)
    let activating = BehaviorRelay<Bool>(value: false)
    let allPosts = BehaviorRelay<[PostSectionModel]>(value: [PostSectionModel(model: 0, items: [])])
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap { _ -> Observable<[ChatModel]> in
        APIService.shared.request(request: RequestType(endpoint: "chats/\(card.roomId)",
                                                         method: .get))
          .map { (response: ChatResponse) -> [ChatModel] in
            return response.toDomain
          }
        }
      .do(onNext: { _ in activating.accept(false) })
      .map { (chatList: [ChatModel]) -> [ChatModel] in
          return chatList.filter { $0.type == .receiveImageMessage || $0.type == .sendImageMessage }
      }
      .map { (posts: [ChatModel]) -> [CertificationPost] in
        print(posts)
        return posts.map { CertificationPost(postType: .ImagePost,
                                             profileImageUrl: $0.profileImage,
                                             nickName: $0.name,
                                             uploadTime: $0.time,
                                             certificateImageUrl: $0.image,
                                             certificateText: $0.message)}
      }
      .map { [PostSectionModel(model: 0, items: $0)] }
      .bind(onNext: { allPosts.accept($0) })
      .disposed(by: disposeBag)
    
    // Input
    self.fetchPosts = fetching
    // Output
    self.certificatePostList = allPosts.asDriver(onErrorJustReturn: [])
    self.roomTitle = currentCard.map { $0.title }.asDriver(onErrorJustReturn: "")
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
  }
}
