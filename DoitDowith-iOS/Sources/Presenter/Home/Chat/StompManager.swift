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

class StompManager {
  static let shared: StompManager = StompManager()
  private var socketClient = StompClientLib()
  private let url = URL(string: "ws://ip 걸고/ws")!
  //    var readyMessage: ReadyRoomRequest
  
  // connection
  func registerSocket() {
    socketClient.openSocketWithURLRequest(
      request: NSURLRequest(url: url),
      delegate: self
    )
  }
  
  // subscribe
  func subscribe(memberId: Int) {
    socketClient.subscribe(destination: "/sub/member/\(memberId)")
  }
  
  // subscribe
  func subscribe1(roomId: Int) {
    socketClient.subscribe(destination: "/sub/chat/\(roomId)")
  }
  
  // public message
  func sendMessage(senderId: CLong, roomId: Int) {
    let payloadObject: [String: Any] = [ "type": "READY", "senderId": senderId]
    
    socketClient.sendJSONForDict(
      dict: payloadObject as AnyObject,
      toDestination: "/pub/ready/\(roomId)")
  }
  
  func disconnect() {
    socketClient.disconnect()
  }
}

extension StompManager: StompClientLibDelegate {
  func stompClient(client: StompClientLib!,
                   didReceiveMessageWithJSONBody jsonBody: AnyObject?,
                   akaStringBody stringBody: String?,
                   withHeader header: [String: String]?,
                   withDestination destination: String) {
    print("Destination : \(destination)")
    print("JSON Body : \(String(describing: jsonBody))")
    print("String Body : \(stringBody ?? "nil")")
    
//    let string = stringBody ?? "nil"
//    var dicData: [String: Any]
//    do {
//      // 딕셔너리에 데이터 저장 실시
//
//      guard dicData = try JSONSerialization.jsonObject(with: Data(string.utf8),
//                                                       options: []) as [String: Any] else {
//        return
//      }
//    } catch {
//      print(error.localizedDescription)
//    }
//
//    print(dicData["type"] ?? "")
//    print(dicData["message"] ?? "")
//
//    if dicData["type"] as? String == "ERROR" {
//      print("hi")
//    }
  }
  
  func stompClientJSONBody(client: StompClientLib!,
                           didReceiveMessageWithJSONBody jsonBody: String?,
                           withHeader header: [String : String]?,
                           withDestination destination: String) {
    print("DESTINATION : \(destination)")
    print("String JSON BODY : \(String(describing: jsonBody))")
  }
  
  // Unsubscribe Topic
  func stompClientDidDisconnect(client: StompClientLib!) {
    print("Socket is Disconnected")
  }
  
  // Subscribe Topic after Connection
  func stompClientDidConnect(client: StompClientLib!) {
    print("Socket is connected")
    // Stomp subscribe will be here!
    //        subscribe()
    // Note : topic needs to be a String object
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
