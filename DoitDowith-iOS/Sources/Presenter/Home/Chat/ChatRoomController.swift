//
//  ChatRoomController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

final class ChatRoomController: UIViewController {
  @IBOutlet weak var chatView: UITableView!
  @IBOutlet weak var bottomInputView: UIView!
  @IBOutlet weak var messageTextField: UITextField!
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerMessageCell()
  }
}

// MARK: - Configure Bottom Input View
extension ChatRoomController {
  func configureBottomInputView() {
    self.bottomInputView.layer.applySketchShadow(alpha: 0.08, x: 2, y: 2, blur: 4, spread: 0)
  }
}

// MARK: - Configure Chat View(Table View)
extension ChatRoomController {
  func registerMessageCell() {
    let sendMessageCellNib = UINib(nibName: "SendMessageCell", bundle: nil)
    chatView.register(sendMessageCellNib,
                      forCellReuseIdentifier: SendMessageCell.identifier)
    let receiveMessageCellNib = UINib(nibName: "ReceiveMessageCell", bundle: nil)
    chatView.register(receiveMessageCellNib,
                      forCellReuseIdentifier: ReceiveMessageCell.identifier)
  }
}

extension ChatRoomController: UITableViewDelegate, UITableViewDataSource {
  // MARK: TableView DataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.count
  }
  
  // Header
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = MessageHeaderView()
    view.configure(day: Date.now.formatted(format: "yyyy.mm.dd (E)"))
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
  
  // MARK: TableView Delegate
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let type = model[indexPath.row].type
    let time = model[indexPath.row].time.formatted(format: "a hh:mm")
    let message = model[indexPath.row].message
    if type == ChatType.send {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SendMessageCell.identifier,
                                                     for: indexPath)
              as? SendMessageCell else { return SendMessageCell() }
      cell.configure(time: time, message: message)
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiveMessageCell.identifier,
                                                     for: indexPath)
              as? ReceiveMessageCell else { return ReceiveMessageCell() }
      cell.configure(time: time, message: message)
      return cell
    }
  }
}
