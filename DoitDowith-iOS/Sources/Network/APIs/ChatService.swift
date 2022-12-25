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
  func searchRoom(roomId: Int) -> Bool 
}

class ChatService: ChatServiceProtocol {
  let realm = try! Realm()
  
  func createChatRoom(roomId: Int) {
    do {
      let chatroom = ChatRoom()
      chatroom.roomId = roomId
      try realm.write {
        realm.add(chatroom)
      }
    } catch {
      print("Create chat room error: ", error.localizedDescription)
    }
  }
  
  func sendMessage(roomId: Int, message: ChatModel) {
    do {
      try realm.write {
        let chatrooms = realm.objects(ChatRoom.self)
        let chatroom = chatrooms.first { $0.roomId == roomId }
        if let profile = message.profileImage {
          chatroom?.items.append(Chat(type: message.type.rawValue,
                                      name: message.name,
                                      profileImage: profile,
                                      message: message.message))
        }
      }
    } catch {
      print("send message error: ", error.localizedDescription)
    }
  }
  
  func searchRoom(roomId: Int) -> Bool {
    let roomResult = realm.objects(ChatRoom.self).filter { $0.roomId == roomId }
    guard roomResult.first != nil else { return false }
    return true
  }
  
  func fetchChatList(roomId: Int) -> Observable<[ChatModel]> {
    return Observable.create { emitter in
      let realmChat = self.realm.objects(ChatRoom.self).sorted(byKeyPath: "roomId")
      let chatrooms: [ChatRoom] = self.convertToArray(results: realmChat)
      guard let chatroom = chatrooms.first(where: { $0.roomId == roomId }) else {
        emitter.onError(ErrorType.Error)
        return Disposables.create()
      }
      let items = chatroom.items
      let chatModel: [ChatModel] = items.map { elem in
        return ChatModel(type: .init(rawValue: elem.type) ?? .sendMessage,
                         profileImage: elem.profileImage,
                         name: elem.name,
                         message: elem.message,
                         time: elem.time.formatted(format: "yyyy-MM-dd hh:mm"))
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
