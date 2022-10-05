//
//  ChatService.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/02.
//

import Foundation

import RxSwift

enum ErrorType: Error {
  case pathError
  case decodeError
}
protocol ChatServiceProtocol {
  func fetchChatList() -> Observable<[ChatModel]>
}
struct ChatService: ChatServiceProtocol {
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
  func fetchChatList() -> Observable<[ChatModel]> {
    return Observable.create { emitter in
      guard let path = Bundle.main.path(forResource: "mock", ofType: "json") else {
        emitter.onError(ErrorType.pathError)
        return Disposables.create()
      }
      guard let jsonString = try? String(contentsOfFile: path) else {
        emitter.onError(ErrorType.decodeError)
        return Disposables.create()
      }
      let data = jsonString.data(using: .utf8)
      guard let data = data, let result = try? JSONDecoder().decode([ChatModel].self, from: data) else {
        emitter.onCompleted()
        return Disposables.create()
      }
      emitter.onNext(result)
      emitter.onCompleted()
      return Disposables.create()
    }
  }
}
