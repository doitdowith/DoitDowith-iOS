//
//  ChatRoomController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxSwift
import RxViewController

final class ChatRoomController: UIViewController {
  @IBOutlet weak var chatView: UITableView!
  @IBOutlet weak var bottomModalView: UIView!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var modalButton: UIButton!
  
  private var isModalOpen = false
  private weak var bottomModalViewBottomConstraint: NSLayoutConstraint?
  private let defaultBottomConstraint: CGFloat = 98
  
  var viewModel: ChatRoomViewModelType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.bind()
    
    for constraint in self.view.constraints where constraint.identifier == "InputViewBottom" {
      self.bottomModalViewBottomConstraint = constraint
    }
  }
  
  /// 모달의 +버튼 클릭했을 때 실행되는 함수
  // 액션도 뷰모델로 빼야하는데
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
  func bind() {
    guard let viewModel = viewModel else { return }
    
    // MARK: Bind ViewWillAppear
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: rx.disposeBag)
    
    // 네비게이션 바 없애기
    Observable
      .merge(self.rx.viewWillAppear.asObservable(), self.rx.viewWillDisappear.asObservable())
      .subscribe(onNext: { state in
        guard let nav = self.navigationController else { return }
        nav.rx.isNavigationBarHidden.onNext(state)
      })
      .disposed(by: rx.disposeBag)
    
    // MARK: Bind Message Text Field
    self.messageTextField.rx.controlEvent(.editingDidEndOnExit)
      .withUnretained(self)
      .withLatestFrom(messageTextField.rx.text)
      .filter { $0 != nil && $0?.isEmpty == false }
      .map { $0! }
      .subscribe(onNext: { message in
        self.messageTextField.rx.text.onNext("")
        self.messageTextField.resignFirstResponder()
        viewModel.input.sendMessage.accept(message)
      })
      .disposed(by: rx.disposeBag)
    
    // MARK: Bind ChatView(table view)
    self.chatView.rx
      .setDelegate(self)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.messageList
      .drive(self.chatView.rx.items(dataSource: viewModel.output.dataSource))
      .disposed(by: rx.disposeBag)
    
        viewModel.output.lastPosition
          .do(onNext: { row, section in
            let indexPath = IndexPath(row: row, section: section)
            self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
          })
          .emit(onNext: { _ in })
          .disposed(by: rx.disposeBag)
    
    // MARK: Bind keyboard notification
    /// viewmodel로 빼야되긴함.
    let keyboardWillShowObservable =
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .map {
        ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
         as? NSValue)?.cgRectValue.height ?? 0
      }
      .map { height in
        return -height + self.defaultBottomConstraint + 34 // 34 수정해야하
      }
    
    let keyboardWillHideObservable =
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in self.defaultBottomConstraint }
    
    Observable
      .merge(keyboardWillShowObservable, keyboardWillHideObservable)
      .do(onNext: { self.bottomModalViewBottomConstraint?.constant = $0 })
      .subscribe(onNext: { _ in })
      .disposed(by: rx.disposeBag)
  }
  
  // MARK: Configure Bottom Input View
  func configureBottomInputView() {
    self.bottomModalView.layer.applySketchShadow(alpha: 0.08, x: 2, y: 2, blur: 4, spread: 0)
  }
  
  // MARK: Configure Chat View(Table View)
  func registerNib() {
    let sendMessageCellNib = UINib(nibName: "SendMessageCell", bundle: nil)
    chatView.register(sendMessageCellNib,
                      forCellReuseIdentifier: SendMessageCell.identifier)
    let receiveMessageCellNib = UINib(nibName: "ReceiveMessageCell", bundle: nil)
    chatView.register(receiveMessageCellNib,
                      forCellReuseIdentifier: ReceiveMessageCell.identifier)
    let chatHeaderViewNib = UINib(nibName: "ChatHeaderCell", bundle: nil)
    chatView.register(chatHeaderViewNib, forHeaderFooterViewReuseIdentifier: ChatHeaderView.identifier)
  }
}

// MARK: - TableView DataSource, Delegate
extension ChatRoomController: UITableViewDelegate {
  // MARK: Header DataSource
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  
  //  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
  //    guard let header = tableView.dequeueReusableHeaderFooterView(
  //      withIdentifier: ChatHeaderView.identifier) as? ChatHeaderView
  //    else { return UIView() }
  //    header.configure(day: "3")
  //    print("good")
  //    return header
  //  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
