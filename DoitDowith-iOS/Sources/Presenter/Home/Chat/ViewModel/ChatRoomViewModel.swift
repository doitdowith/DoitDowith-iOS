//
//  ChatRoomViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/29.
//

import Foundation

import Action
import NSObject_Rx
import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import RealmSwift
import StompClientLib

protocol ChatRoomViewModelInput {
  var viewWillAppear: PublishRelay<Void> { get }
  var viewWillDisappear: PublishRelay<Void> { get }
  var sendMessage: PublishRelay<ChatModel> { get }
  var recevieMessage: PublishRelay<ChatModel> { get }
  var chatroomInfo: PublishRelay<MissionRoomRequest> { get }
}

protocol ChatRoomViewModelOutput {
  var messageList: Driver<[SectionOfChatModel]> { get }
  var activated: Driver<Bool> { get }
  var errorMessage: Signal<NSError> { get }
  var lastPosition: Signal<(Int, Int)> { get }
  var title: Driver<String> { get }
  var ddayCount: Driver<String> { get }
  var leftCertificateCount: Driver<String> { get }
  var hideCertificateButton: Driver<Bool> { get}
}

protocol ChatRoomViewModelType {
  var input: ChatRoomViewModelInput { get }
  var output: ChatRoomViewModelOutput { get }
}

enum MyError: Error {
  case error
}

final class ChatRommViewModel: ChatRoomViewModelInput,
                               ChatRoomViewModelOutput,
                               ChatRoomViewModelType {
  let disposeBag = DisposeBag()
  var input: ChatRoomViewModelInput { return self }
  var output: ChatRoomViewModelOutput { return self }
  
  // Input
  let viewWillAppear: PublishRelay<Void>
  let viewWillDisappear: PublishRelay<Void>
  let sendMessage: PublishRelay<ChatModel>
  let recevieMessage: PublishRelay<ChatModel>
  let chatroomInfo: PublishRelay<MissionRoomRequest>
  
  // Output
  let messageList: Driver<[SectionOfChatModel]>
  let activated: Driver<Bool>
  let errorMessage: Signal<NSError>
  let lastPosition: Signal<(Int, Int)>
  let title: Driver<String>
  let ddayCount: Driver<String>
  let leftCertificateCount: Driver<String>
  let hideCertificateButton: Driver<Bool>
  
  init(card: Card, stompManager: StompManagerProtocol, chatService: ChatServiceProtocol) {
    let name = UserDefaults.standard.string(forKey: "name")
    let fetching = PublishRelay<Void>()
    let disconnect = PublishRelay<Void>()
    let send = PublishRelay<ChatModel>()
    let receive = PublishRelay<ChatModel>()
    let cardInfo = BehaviorRelay<Card>(value: card)
    let allMessages = BehaviorRelay<[ChatModel]>(value: [])
    let activating = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    let roomid = card.roomId
    
    let certificateCount = Observable.combineLatest(cardInfo, allMessages)
      .map { (cards, messages) -> Int in
        let totalcertificateCount = cards.count
        let certificateCount = messages.filter { $0.type == .sendImageMessage }.count
        return totalcertificateCount - certificateCount
      }
    
    let chatRecord = allMessages.scan([ChatModel](),
                                        accumulator: { prev, new in
      if prev != new {
        return prev + new
      } else {
        return prev
      }
    })
    
    let isHide = Observable.combineLatest(chatRecord, certificateCount)
      .debug()
      .map { (messages, count) -> Bool in
        guard let name = name else { return false }
        let today = Date.now.formatted(format: "yyyy-MM-dd")
        let message = messages.filter { $0.name == name && !$0.message.isEmpty && $0.image != nil && $0.time.prefix(10).description == today }
        return !(message.isEmpty && count > 0)
      }
    
    receive
      .filter { $0.name != name! }
      .bind(onNext: { allMessages.accept([$0]) })
      .disposed(by: disposeBag)
    
    send
      .observe(on: MainScheduler.instance)
      .do(onNext: { stompManager.sendMessage(meesage: $0.message) })
      .bind(onNext: { allMessages.accept([$0]) })
      .disposed(by: disposeBag)
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .do(onNext: { _ in stompManager.registerSocket() })
      .flatMap { _ -> Observable<[ChatModel]> in
        APIService.shared.request(request: RequestType(endpoint: "chats/\(roomid)",
                                                       method: .get))
        .map { (response: ChatResponse) -> [ChatModel] in
          return response.toDomain
        }
      }
      .do(onNext: { _ in activating.accept(false) })
      .bind(onNext: { allMessages.accept($0) })
      .disposed(by: disposeBag)
    
    disconnect
      .bind(onNext: { _ in stompManager.disconnect() })
      .disposed(by: disposeBag)
    
    self.viewWillAppear = fetching
    self.viewWillDisappear = disconnect
    self.chatroomInfo = PublishRelay<MissionRoomRequest>()
    self.sendMessage = send
    self.recevieMessage = receive
    self.messageList = chatRecord
        .map { (chats: [ChatModel]) -> [SectionOfChatModel] in
          var section: [SectionOfChatModel] = []
          var row: [ChatModel] = []
          var currentTime: String = ""
          for i in 0..<chats.count {
            var message: ChatModel = chats[i]
            let time = message.time.substring(from: 0, to: 9)
            if i == 0 || chats[i - 1].name != message.name {
              message.type = message.type.inverseMessage()
            }
            if currentTime.isEmpty || currentTime == time {
              row.append(message)
              currentTime = time
            } else {
              section.append(SectionOfChatModel(header: currentTime, items: row))
              row = [message]
              currentTime = time
            }
          }
          if !row.isEmpty {
            section.append(SectionOfChatModel(header: currentTime, items: row))
          }
          return section
        }
        .asDriver(onErrorJustReturn: [])
    
    self.activated = activating
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
    
    self.errorMessage = error
      .map { $0 as NSError }
      .asSignal(onErrorJustReturn: MyError.error as NSError)
    
    self.title = cardInfo
      .map { $0.title }
      .asDriver(onErrorJustReturn: "")
    
    self.lastPosition = messageList
      .filter { !$0.isEmpty }
      .map { ($0[$0.endIndex - 1].items.count - 1, $0.count - 1) }
      .asSignal(onErrorJustReturn: (0, 0))
    
    self.ddayCount = cardInfo
      .map { $0.startDate.toDate() }
      .map { (date: Date?) -> String in
        guard let date = date else { return "" }
        let next = date.addingTimeInterval(3600 * 7 * 24)
        let diff = next.timeIntervalSince(Date.now)
        let day = Int(diff / (3600 * 24))
        if day > 7 {
          return "미션 시작 D-\(day - 7)"
        } else if day < 0 {
          return "미션이 종료되었습니다."
        } else if day == 0 {
          return "미션이 오늘 종료됩니다."
        }
        return "미션 종료 D-\(day)"
      }
      .asDriver(onErrorJustReturn: "")

    self.leftCertificateCount = certificateCount
      .map { "남은 인증 횟수 \($0)회" }
      .asDriver(onErrorJustReturn: "")
    
    self.hideCertificateButton = isHide.asDriver(onErrorJustReturn: false)
  }
}
