//
//  StompManager.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/10.
//

import Foundation
import StompClientLib

struct Response: Codable {
  var type: String
  var message: String
}

enum ConnectType {
  case member
  case room
}

protocol StompManagerProtocol {
  func registerSocket()
  func subscribeMember()
  func subscribeRoom()
  func sendMessage(meesage: String)
  func disconnect()
}

final class StompManager: StompManagerProtocol {
  private var socketClient = StompClientLib()
 
  private let url = URL(string: "ws://117.17.198.38:8080/chat")!
  private let targetId: String
  private let senderId: String
  private let connectType: ConnectType
  
  init(targetId: String, senderId: String, connectType: ConnectType) {
    self.targetId = targetId
    self.senderId = senderId
    self.connectType = connectType
  }
  
  // connection
  func registerSocket() {
    socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url),
                                          delegate: self as StompClientLibDelegate)
  }
  
   // subscribe member
  func subscribeMember() {
//    socketClient.subscribe(destination: DestinationType.receiveMemeber(id: self.targetId).path)
  }
  
  // subscribe room
  func subscribeRoom() {
    socketClient.subscribe(destination: DestinationType.receiveRoom(id: self.targetId).path)
  }
  
  // public message
  func sendMessage(meesage message: String) {
    let payloadObject: [String: Any] = ["contents": message,
                                        "memberId": self.senderId,
                                        "roomId": self.targetId]
    socketClient.sendJSONForDict(
      dict: payloadObject as AnyObject,
      toDestination: DestinationType.sendRoom.path)
  }
  
  func disconnect() {
    socketClient.disconnect()
  }
}

extension StompManager: StompClientLibDelegate {
  func stompClientDidConnect(client: StompClientLib!) {
    print("Socket is Connected")
    switch self.connectType {
    case .member:
      subscribeMember()
    case .room:
      subscribeRoom()
    }
  }
  
  // Unsubscribe Topic
  func stompClientDidDisconnect(client: StompClientLib!) {
    print("Socket is Disconnected")
  }
  
  func stompClient(client: StompClientLib!,
                   didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                   akaStringBody stringBody: String?,
                   withHeader header: [String: String]?,
                   withDestination destination: String) {
    print("---------------------------")
    print("Destination : \(destination)")
    print("JSON Body : \(String(describing: jsonBody))")
    print("String Body : \(stringBody ?? "nil")")
    print("---------------------------")
  }
  
  func stompClientJSONBody(client: StompClientLib!,
                           didReceiveMessageWithJSONBody jsonBody: String?,
                           withHeader header: [String: String]?,
                           withDestination destination: String) {
    print("---------------------------")
    print("DESTINATION : \(destination)")
    print("String JSON BODY : \(String(describing: jsonBody))")
    print("---------------------------")
  }
  
  // Error - disconnect and reconnect socket
  func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
    print("Error Send : \(String(describing: message))")
    disconnect()
  }
  
  func serverDidSendPing() {
    print("Server ping")
  }
  
  func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
    print("Receipt : \(receiptId)")
  }
}
