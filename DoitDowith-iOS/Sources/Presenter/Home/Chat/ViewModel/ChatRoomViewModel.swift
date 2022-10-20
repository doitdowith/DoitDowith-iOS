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
import StompClientLib

protocol ChatRoomViewModelInput {
  var viewWillAppear: PublishRelay<Void> { get }
  var sendMessage: PublishRelay<String?> { get }
}

protocol ChatRoomViewModelOutput {
  var messageList: Driver<[SectionOfChatModel]> { get }
  var dataSource: RxTableViewSectionedReloadDataSource<SectionOfChatModel> { get }
  var activated: Driver<Bool> { get }
  var errorMessage: Signal<NSError> { get }
  var lastPosition: Signal<(Int, Int)> { get }
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
  let sendMessage: PublishRelay<String?>
  
  // Output
  let messageList: Driver<[SectionOfChatModel]>
  let dataSource: RxTableViewSectionedReloadDataSource<SectionOfChatModel>
  let activated: Driver<Bool>
  let errorMessage: Signal<NSError>
  let lastPosition: Signal<(Int, Int)>
  
  init(id: Int, chatService: ChatServiceProtocol, stompManager: StompManagerProtocol) {
    let fetching = PublishRelay<Void>()
    let message = PublishRelay<String?>()
    
    let allMessages = BehaviorRelay<[ChatModel]>(value: [])
    let activating = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    message
      .filter { $0 != nil }
      .map { $0! }
      .filter { !$0.isEmpty }
      .do(onNext: { message in
        stompManager.sendMessage(meesage: message)
      })
      .map { [ChatModel(id: 2, name: "김영균", message: $0, time: Date.now.formatted())] }
      .bind(onNext: allMessages.accept)
      .disposed(by: disposeBag)
    
    self.viewWillAppear = fetching
    self.sendMessage = message
    self.messageList = allMessages
      .scan([ChatModel](), accumulator: { prev, new in
        return prev + new
      })
      .map { chat in
        var section: [SectionOfChatModel] = []
        chat.forEach { section.append(SectionOfChatModel(header: $0.time, items: [$0])) }
        return section
      }
      .asDriver(onErrorJustReturn: [])
    
    fetching
      .do(onNext: { _ in activating.accept(true) })
        .do(onNext: { _ in stompManager.registerSocket() })
      .flatMap(chatService.fetchChatList)
      .do(onNext: { _ in activating.accept(false) })
      .do(onError: { err in error.accept(err) })
      .subscribe(onNext: { allMessages.accept($0) })
      .disposed(by: disposeBag)
        
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
    
    self.dataSource = RxTableViewSectionedReloadDataSource<SectionOfChatModel>(
      configureCell: { _, tableView, indexPath, item in
        if item.memberId == id {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.identifier,
                                                         for: indexPath) as? SendMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(7).description, message: item.message)
          return cell
        } else {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveMessageCell.identifier,
                                                         for: indexPath) as? ReceiveMessageCell else {
            return UITableViewCell()
          }
          cell.configure(time: item.time.suffix(7).description, message: item.message)
          return cell
        }
      })
  }
}
