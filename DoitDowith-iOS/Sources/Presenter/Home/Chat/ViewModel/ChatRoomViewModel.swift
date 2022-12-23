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
  var sendMessage: PublishRelay<[ChatModel]> { get }
  var chatroomInfo: PublishRelay<MissionRoomRequest> { get }
}

protocol ChatRoomViewModelOutput {
  var messageList: Driver<[SectionOfChatModel]> { get }
  var dataSource: RxTableViewSectionedReloadDataSource<SectionOfChatModel> { get }
  var activated: Driver<Bool> { get }
  var errorMessage: Signal<NSError> { get }
  var lastPosition: Signal<(Int, Int)> { get }
  var ddayCount: Driver<String> { get }
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
  let lib = StompClientLib()
  
  var input: ChatRoomViewModelInput { return self }
  var output: ChatRoomViewModelOutput { return self }
  
  // Input
  let viewWillAppear: PublishRelay<Void>
  let sendMessage: PublishRelay<[ChatModel]>
  let chatroomInfo: PublishRelay<MissionRoomRequest>
  
  // Output
  let messageList: Driver<[SectionOfChatModel]>
  let dataSource: RxTableViewSectionedReloadDataSource<SectionOfChatModel>
  let activated: Driver<Bool>
  let errorMessage: Signal<NSError>
  let lastPosition: Signal<(Int, Int)>
  let ddayCount: Driver<String>
  
  init(card: Card, stompManager: StompManagerProtocol) {
    let fetching = PublishRelay<Void>()
    let message = PublishRelay<[ChatModel]>()
    let cardInfo = BehaviorRelay<Card>(value: card)
    let allMessages = BehaviorRelay<[ChatModel]>(value: [])
    let activating = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    
    message
      .filter { !$0.isEmpty }
      .do(onNext: { model in
        if let chat = model.first,
           let message = chat.message {
            stompManager.sendMessage(meesage: message)
        }
      })
      .bind(onNext: { allMessages.accept($0) })
      .disposed(by: disposeBag)
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
      .do(onNext: { _ in stompManager.registerSocket() })
      .map { _ in return [] }
//      .flatMap { _ -> Observable<[ChatModel]> in
//        return APIService.shared.request(request: RequestType(endpoint: "chats/\(card.roomId)",
//                                                              method: .get))
//        .map { (response: ChatResponse) -> [ChatModel] in
//          return response.toDomain
//        }
//      }
      .do(onNext: { _ in activating.accept(false) })
      .bind(onNext: { allMessages.accept($0) })
      .disposed(by: disposeBag)
        
    self.viewWillAppear = fetching
    self.chatroomInfo = PublishRelay<MissionRoomRequest>()
    self.sendMessage = message
    self.messageList = allMessages
      .scan([ChatModel](), accumulator: { prev, new in
        return prev + new })
      .map { chat in
        var section: [SectionOfChatModel] = []
        var row: [ChatModel] = []
        var currentTime: String = ""
        for message in chat {
          if currentTime.isEmpty || currentTime == message.time {
            row.append(message)
            currentTime = message.time
          } else {
            section.append(SectionOfChatModel(header: currentTime, items: row))
            row = []
            row.append(message)
            currentTime = message.time
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
    
    self.lastPosition = messageList
      .filter { !$0.isEmpty }
      .map { ($0[$0.endIndex - 1].items.count - 1, $0.count - 1) }
      .asSignal(onErrorJustReturn: (0, 0))
    
    self.ddayCount = cardInfo
      .map { $0.startDate.toDate() }
      .map { (date: Date?) -> String in
        guard let date = date else { return "" }
        let next = date.addingTimeInterval(3600 * 7 * 24)
        let diff = next.timeIntervalSince(date)
        let day = Int(diff / (3600 * 24))
        return "미션 종료 D-\(day)"
      }
      .asDriver(onErrorJustReturn: "")
    
    self.dataSource = RxTableViewSectionedReloadDataSource<SectionOfChatModel>(
      configureCell: { _, tableView, indexPath, item in
        switch item.type {
        case .receiveMessageWithProfile:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveMessageWithProfileCell.identifier,
                                                         for: indexPath) as? ReceiveMessageWithProfileCell else {
            return UITableViewCell()
          }
          cell.configure(image: item.profileImage!,
                         name: item.name,
                         message: item.message,
                         time: item.time)
          return cell
        case .receiveMessage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveMessageCell.identifier,
                                                         for: indexPath) as? ReceiveMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description, message: item.message)
          return cell
        case .sendMessageWithTip:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.identifier,
                                                         for: indexPath) as? SendMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description, message: item.message)
          cell.addTipView()
          return cell
        case .sendMessage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.identifier,
                                                         for: indexPath) as? SendMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description, message: item.message)
          return cell
        case .sendImageMessage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendImageMessageCell.identifier,
                                                         for: indexPath) as? SendImageMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description,
                         message: item.message,
                         image: item.image)
          return cell
        case .receiveImageMessage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveImageMessageCell.identifier,
                                                         for: indexPath) as? ReceiveImageMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description,
                         message: item.message,
                         image: item.image)
          return cell
        case .receiveImage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveImageCell.identifier,
                                                         for: indexPath) as? ReceiveImageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description,
                         image: item.image)
          return cell
        case .sendImage:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendImageCell.identifier,
                                                         for: indexPath) as? SendImageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(5).description,
                         image: item.image)
          return cell
        }
      })
  }
}
