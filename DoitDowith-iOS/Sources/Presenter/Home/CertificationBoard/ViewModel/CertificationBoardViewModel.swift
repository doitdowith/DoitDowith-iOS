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
  
  let activated: Driver<Bool>
  let certificatePostList: Driver<[PostSectionModel]>
  
  init() {
    let fetching = PublishRelay<Void>()
    let activating = BehaviorRelay<Bool>(value: false)
    let allPosts = BehaviorRelay<[PostSectionModel]>(value: [
      PostSectionModel(model: 0, items: [CertificationPost(postType: .TextPost,
                                                           nickName: "ㅎㅇ",
                                                           uploadTime: Date().addingTimeInterval(123),
                                                           certificateText: "ㅎㅇㅎㅇㅎㅇ")]
                      )
    ])
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .flatMap { _ -> Single<[CertificationPost]> in
        return HomeAPI.shared.getCertificatePostList(request: CertificateBoardRequest(id: 1))
      }
      .do(onNext: { _ in activating.accept(false) })
      .map { [PostSectionModel(model: 0, items: $0)] }
      .bind(onNext: { allPosts.accept($0) })
      .disposed(by: disposeBag)
    
    // Input
    self.fetchPosts = fetching
    // Output
    self.certificatePostList = allPosts.asDriver(onErrorJustReturn: [])
    
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
  }
}
