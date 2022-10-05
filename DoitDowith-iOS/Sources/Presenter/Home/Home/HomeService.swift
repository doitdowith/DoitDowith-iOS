//
//  HomeService.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/03.
//

import Foundation

import RxSwift

enum HomeErrorType: Error {
  case pathError
  case decodeError
}
protocol HomeServiceProtocol {
  func fetchCardList() -> Observable<[CardModel]>
}
struct HomeService: HomeServiceProtocol {
//  func fetch -> Observable<[SectionOfChatModel]> {
//    return fetch().map {
//      var section: [SectionOfChatModel] = []
//      var items: [ChatModel] = []
//      var prev = ""
//      for model in $0 {
//        if prev.isEmpty || prev == model.time.prefix(10) {
//          prev = model.time
//          items.append(model)
//        } else {
//          section.append(SectionOfChatModel(header: prev, items: items))
//          items.removeAll()
//          items.append(model)
//          prev = model.time
//        }
//      }
//      return section
//    }
//  }
  func fetchCardList() -> Observable<[CardModel]> {
    return Observable.create { emitter in
      guard let path = Bundle.main.path(forResource: "homeMock", ofType: "json") else {
        emitter.onError(HomeErrorType.pathError)
        return Disposables.create()
      }
      guard let jsonString = try? String(contentsOfFile: path) else {
        emitter.onError(HomeErrorType.decodeError)
        return Disposables.create()
      }
      let data = jsonString.data(using: .utf8)
      guard let data = data, let result = try? JSONDecoder().decode([CardModel].self, from: data) else {
        emitter.onCompleted()
        return Disposables.create()
      }
      emitter.onNext(result)
      emitter.onCompleted()
      return Disposables.create()
    }
  }
}
