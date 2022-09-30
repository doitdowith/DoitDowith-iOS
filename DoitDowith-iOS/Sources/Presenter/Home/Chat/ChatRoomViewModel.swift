//
//  ChatRoomViewModel.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/29.
//

import Foundation

import RxSwift
import RxCocoa
import RxDataSources
import Action

typealias ChatSectionModel = AnimatableSectionModel<Int, ChatModel>

protocol ChatRoomViewModelInput {
}

protocol ChatRoomViewModelOutput {
  var chatList: Driver<[ChatSectionModel]> { get }
  var dataSource: RxTableViewSectionedAnimatedDataSource<ChatSectionModel> { get }
}

protocol ChatRoomViewModelType {
  var input: ChatRoomViewModelInput { get }
  var output: ChatRoomViewModelOutput { get }
}

final class ChatRoomViewModel: ChatRoomViewModelInput,
                               ChatRoomViewModelOutput,
                               ChatRoomViewModelType {
  var input: ChatRoomViewModelInput { return self }
  var output: ChatRoomViewModelOutput { return self }
  
  // MARK: Output
  var chatList: Driver<[ChatSectionModel]>
  var dataSource: RxTableViewSectionedAnimatedDataSource<ChatSectionModel>
  
  init() {
    var sectionModel = ChatSectionModel(model: 0, items: [])
    let store = BehaviorSubject<[ChatSectionModel]>(value: [sectionModel])
    
    let model = [
      ChatModel(type: ChatType.send,
                name: "김영균",
                message: "안녕",
                time: Date.now),
      ChatModel(type: ChatType.receive,
                name: "김영균",
                message: "Self-sizing cells in UITableView and UICollectionView were added as a feature in iOS 8. This feature allows each cell to determine its own size rather than using a fixed size or asking the table or collection view delegate for the size of each cell.Self-sizing cells in UITableView and UICollectionView were added as a feature in iOS 8. This feature allows each cell to determine its own size rather than using a fixed size or asking the table or collection view delegate for the size of each cell.",
                
                time: Date.now.addingTimeInterval(1)),
      ChatModel(type: ChatType.send,
                name: "김영균",
                message: "Self-sizing cells in UITableView and UICollectionView were added as a feature in iOS 8. This feature allows each cell to determine its own size rather than using a fixed size or asking the table or collection view delegate for the size of each cell.",
                time: Date.now.addingTimeInterval(2))
    ]
    sectionModel.items.insert(model[0], at: 0)
    sectionModel.items.insert(model[1], at: 1)
    sectionModel.items.insert(model[2], at: 2)
    
    self.chatList = store.asDriver(onErrorJustReturn: [])
    self.dataSource = RxTableViewSectionedAnimatedDataSource<ChatSectionModel>(
      configureCell: { _, tableView, indexPath, chat in
        let type = chat.type
        let time = chat.time.formatted(format: "a hh:mm")
        let message = chat.message
        switch type {
        case .receive:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveMessageCell.identifier,
                                                         for: indexPath)
                  as? ReceiveMessageCell else { return ReceiveMessageCell() }
          cell.configure(time: time, message: message)
          return cell
        case .send:
          guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.identifier,
                                                         for: indexPath)
                  as? SendMessageCell else { return SendMessageCell() }
          cell.configure(time: time, message: message)
          return cell
        }
      })
  }
}
