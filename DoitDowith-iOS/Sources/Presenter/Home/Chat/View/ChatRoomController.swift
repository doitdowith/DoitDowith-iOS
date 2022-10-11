//
//  ChatRoomController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxKeyboard
import RxSwift
import RxViewController

final class ChatRoomController: UIViewController {
  @IBOutlet weak var chatView: UITableView!
  @IBOutlet weak var textfieldView: UIView!
  @IBOutlet weak var textfield: UITextField!
  @IBOutlet weak var modalButton: UIButton!
  
  @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var modalViewBottomConstraint: NSLayoutConstraint!
  
  private var isModalOpen = false
  private let defaultBottomConstraint: CGFloat = 98
  private var keyboardHeight: CGFloat = 0
  private let viewModel: ChatRoomViewModelType
  
  init?(coder: NSCoder, viewModel: ChatRoomViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.bind()
  }
  
  // 모달의 +버튼 클릭했을 때 실행되는 함수
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
    self.modalViewBottomConstraint.constant = bottomHeight
    self.textfieldBottomConstraint.constant = bottomHeight - 98
    UIView.animate(withDuration: 0.4) { [weak self] in
      guard let self = self else { return }
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
    // Bind ViewWillAppear
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: rx.disposeBag)
    
    Observable
      .merge(self.rx.viewWillAppear.asObservable(), self.rx.viewWillDisappear.asObservable())
      .subscribe(onNext: { state in
        guard let nav = self.navigationController else { return }
        nav.rx.isNavigationBarHidden.onNext(state)
      })
      .disposed(by: rx.disposeBag)
    
    // Bind ChatView(table view)
    self.chatView.rx
      .setDelegate(self)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.messageList
      .drive(self.chatView.rx.items(dataSource: viewModel.output.dataSource))
      .disposed(by: rx.disposeBag)
    
    RxKeyboard.instance.visibleHeight
      .map { height in
        if height > 0 {
          return -height + UIApplication.safeAreaEdgeInsets.bottom
        } else {
          return 0
        }
      }
      .drive(self.textfieldBottomConstraint.rx.constant)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.lastPosition
      .do(onNext: { row, section in
        let indexPath = IndexPath(row: row, section: section)
        self.chatView.scrollToRow(at: indexPath, at: .bottom, animated: false)
      })
      .emit(onNext: { _ in })
      .disposed(by: rx.disposeBag)
  }
  
  // MARK: Configure Bottom Input View
  func configureBottomInputView() {
    self.textfieldView.layer.applySketchShadow(alpha: 0.08, x: 2, y: 2, blur: 4, spread: 0)
  }
  
  // MARK: Configure Chat View(Table View)
  func registerNib() {
    let sendMessageCellNib = UINib(nibName: "SendMessageCell", bundle: nil)
    chatView.register(sendMessageCellNib,
                      forCellReuseIdentifier: SendMessageCell.identifier)
    
    let receiveMessageCellNib = UINib(nibName: "ReceiveMessageCell", bundle: nil)
    chatView.register(receiveMessageCellNib,
                      forCellReuseIdentifier: ReceiveMessageCell.identifier)
  }
}
// MARK: - TableView DataSource, Delegate
extension ChatRoomController: UITableViewDelegate {
  // MARK: Header DataSource
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = ChatHeaderView()
    return view
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}
