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

protocol StompManagerProtocol {
  func registerSocket()
  func subscribeRoom()
  func sendMessage(meesage: String)
  func disconnect()
}

final class StompManager: StompManagerProtocol {
  weak var viewModel: ChatRommViewModel?
  private var socketClient = StompClientLib()
  private let url = URL(string: "ws://117.17.198.38:8080/chat")!
  private let roomId: String
  private let memberId: String
  
  init(roomId: String, memberId: String) {
    self.roomId = roomId
    self.memberId = memberId
  }
  
  // connection
  func registerSocket() {
    socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url),
                                          delegate: self as StompClientLibDelegate)
  }
  
  // subscribe room
  func subscribeRoom() {
    socketClient.subscribe(destination: DestinationType.receiveRoom(id: self.roomId).path)
  }
  
  // public message
  func sendMessage(meesage message: String) {
    let payloadObject: [String: Any] = ["contents": message,
                                        "memberId": self.memberId,
                                        "roomId": self.roomId]
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
    subscribeRoom()
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
    guard let body = stringBody,
          let data = body.data(using: .utf8),
    let viewModel = viewModel else { return }
    do {
      let data2 = try JSONDecoder().decode(ChatSocketResponse.self, from: data)
      viewModel.input.recevieMessage.accept(data2.toDomain)
    } catch {
      print(error.localizedDescription)
    }
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
