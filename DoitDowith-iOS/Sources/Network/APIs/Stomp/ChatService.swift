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
      guard let data = data, let result = try? JSONDecoder().decode(ChatResponse.self, from: data) else {
        emitter.onError(MyError.error)
        return Disposables.create()
      }
      emitter.onNext(result.toDomain)
      emitter.onCompleted()
      return Disposables.create()
    }
  }
}
