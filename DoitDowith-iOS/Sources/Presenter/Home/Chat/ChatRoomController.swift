//
//  ChatRoomController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

final class ChatRoomController: UIViewController {
  @IBOutlet weak var chatView: UITableView!
  @IBOutlet weak var bottomModalView: UIView!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var modalButton: UIButton!
  
  private var isModalOpen = false
  private weak var bottomModalViewBottomConstraint: NSLayoutConstraint?
  private let defaultBottomConstraint: CGFloat = 98
  
  var viewModel: ChatRoomViewModelType?
  
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
    self.addKeyboardNotification()
    self.registerMessageCell()
    
    for constraint in self.view.constraints where constraint.identifier == "InputViewBottom" {
      self.bottomModalViewBottomConstraint = constraint
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.isNavigationBarHidden = false
  }
  /// 모달의 +버튼 클릭했을 때 실행되는 함수
  @IBAction func didTapAddButton(_ sender: UIButton) {
    var bottomHeight: CGFloat = 0
    if isModalOpen {
      self.modalButton.setImage(UIImage(named: "ic_plus"), for: .normal)
      bottomHeight = self.defaultBottomConstraint
    } else {
      self.modalButton.setImage(UIImage(named: "ic_exit"), for: .normal)
      bottomHeight = 0
    }
    isModalOpen.toggle()
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.bottomModalViewBottomConstraint?.constant = bottomHeight
      self.view.layoutIfNeeded()
    }
  }
  /// 뒤로가기 버튼을 클릭했을 때
  @IBAction func didTapNavBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension ChatRoomController {
  // MARK: Configure Bottom Input View
  func configureBottomInputView() {
    self.bottomModalView.layer.applySketchShadow(alpha: 0.08, x: 2, y: 2, blur: 4, spread: 0)
  }
  
  // MARK: Configure Chat View(Table View)
  func registerMessageCell() {
    let sendMessageCellNib = UINib(nibName: "SendMessageCell", bundle: nil)
    chatView.register(sendMessageCellNib,
                      forCellReuseIdentifier: SendMessageCell.identifier)
    let receiveMessageCellNib = UINib(nibName: "ReceiveMessageCell", bundle: nil)
    chatView.register(receiveMessageCellNib,
                      forCellReuseIdentifier: ReceiveMessageCell.identifier)
  }
  
  // MARK: Notification Center
  func addKeyboardNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillDown),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  // MARK: Keyboard Notification Function
  @objc func keyboardWillShow(_ notification: NSNotification) {
    let height = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
    let window = UIApplication.shared.windows.first
    let bottom = window?.safeAreaInsets.bottom ?? 0
    
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.bottomModalViewBottomConstraint?.constant = -height + self.defaultBottomConstraint + bottom
    }
  }
  
  @objc func keyboardWillDown(_ notification: NSNotification) {
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
      self.bottomModalViewBottomConstraint?.constant = self.defaultBottomConstraint
    }
  }
}

// MARK: - UITextField Delegate
extension ChatRoomController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    messageTextField.endEditing(true)
    messageTextField.resignFirstResponder()
    return true
  }
}

// MARK: - TableView DataSource, Delegate
extension ChatRoomController: UITableViewDelegate, UITableViewDataSource {
  // MARK: DataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.count
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
  
  // MARK: Header DataSource
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
}
