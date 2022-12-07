//
//  ChatService.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/02.
//

import Foundation

import RxSwift
import RealmSwift

enum ErrorType: Error {
  case Error
}

protocol ChatServiceProtocol {
  func fetchChatList(roomId: Int) -> Observable<[ChatModel]>
  func sendMessage(roomId: Int, message: ChatModel)
  func createChatRoom(roomId: Int)
}

class ChatService: ChatServiceProtocol {
  let realm = try! Realm()
  
  func createChatRoom(roomId: Int) {
    let chatroom = ChatRoom(id: roomId)
    try? realm.write {
      realm.add(chatroom)
    }
  }
  
  func sendMessage(roomId: Int, message: ChatModel) {
    try! realm.write {
      let chatrooms = realm.objects(ChatRoom.self)
      let chatroom = chatrooms.first { $0.roomId == roomId }
      switch message.message {
      case .text(let m):
        chatroom?.items.append(Chat(type: message.type.rawValue,
                                    name: message.name,
                                    message: m))
      case .image:
        break
      }
    }
  }
  
  func fetchChatList(roomId: Int) -> Observable<[ChatModel]> {
    return Observable.create { emitter in
      print(Realm.Configuration.defaultConfiguration.fileURL)
      let realmChat = self.realm.objects(ChatRoom.self).sorted(byKeyPath: "roomId")
      let chatrooms: [ChatRoom] = self.convertToArray(results: realmChat)
      guard let chatroom = chatrooms.first(where: { $0.roomId == roomId }) else {
        emitter.onError(ErrorType.Error)
        return Disposables.create()
      }
      let items = chatroom.items
      print(chatroom, items)
      let chatModel: [ChatModel] = items.map { elem in
        return ChatModel(type: .init(rawValue: elem.type) ?? .sendMessage,
                         name: elem.name,
                         message: .text(elem.message),
                         time: elem.time.formatted(format: "hh:mm"))
      }
      emitter.onNext(chatModel)
      emitter.onCompleted()
      return Disposables.create()
    }
  }
  private func convertToArray<R>(results: Results<R>) -> [R] where R: Object {
      var arrayOfResults: [R] = []
      for result in results {
          arrayOfResults.append(result)
      }
      return arrayOfResults
  }
}
