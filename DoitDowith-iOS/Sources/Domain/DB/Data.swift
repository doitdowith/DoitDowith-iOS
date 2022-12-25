//
//  Data.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/05.
//

import Foundation
import RealmSwift

class ChatRoom: Object, NSCopying {
  @objc dynamic var roomId: Int = 1
  var items = List<Chat>()
  
  override class func primaryKey() -> String? {
    return "roomId"
  }
  
  func copy(with zone: NSZone? = nil) -> Any {
    let copy = ChatRoom()
    copy.items = self.items
    return copy
  }
}

class Chat: Object {
  @objc dynamic var type: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var message: String = ""
  @objc dynamic var time: Date = Date.now
  var parent = LinkingObjects(fromType: ChatRoom.self, property: "items")
  
  convenience init(type: Int, name: String, message: String) {
    self.init()
    self.type = type
    self.name = name
    self.message = message
  }
}
