//
//  ChatRoomController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit
import PhotosUI

import NSObject_Rx
import RealmSwift
import RxCocoa
import RxKeyboard
import RxSwift
import RxRelay
import RxViewController

final class ChatRoomController: UIViewController {
  // MARK: Constant
  static let identifier: String = "ChatRoomVC"
  private var card: Card
  private var isModalOpen = false
  private let defaultBottomConstraint: CGFloat = 98
  private var keyboardHeight: CGFloat = 0
  private var sections: [SectionOfChatModel] = []
  private var name: String?
  private var profileImage: String?
  // MARK: Properties
  private let viewModel: ChatRoomViewModelType
  
  // MARK: Initializer
  init?(coder: NSCoder, card: Card, viewModel: ChatRoomViewModelType) {
    self.card = card
    self.viewModel = viewModel
    self.name = UserDefaults.standard.string(forKey: "name")
    self.profileImage = UserDefaults.standard.string(forKey: "profileImage")
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.register()
    self.applyShadow()
    self.bind()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var chatView: UITableView!
  @IBOutlet weak var textfieldView: UIView!
  @IBOutlet weak var textfield: UITextField!
  @IBOutlet weak var modalButton: UIButton!
  @IBOutlet weak var certificateButton: UIButton!
  @IBOutlet weak var roomTitle: UILabel!
  @IBOutlet weak var ddayLabel: UILabel!
  @IBOutlet weak var leftCertificateCount: UILabel!
  
  @IBOutlet weak var textfieldBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var modalViewBottomConstraint: NSLayoutConstraint!
  
  @IBAction func didTapAddButton(_ sender: UIButton) {
    modalButtonDidTap()
  }
  /// 뒤로가기 버튼을 클릭했을 때
  @IBAction func didTapNavBackButton(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func showInformationModal(_ sender: UIButton) {
    let vm = InformationModalViewModel(card: card)
    let modal = UIStoryboard(name: "Home", bundle: nil)
      .instantiateViewController(identifier: ChatRoomInformationModalWhenStarted.identifier) { coder in
        ChatRoomInformationModalWhenStarted(coder: coder, viewModel: vm)
      }
    modal.modalPresentationStyle = .overCurrentContext
    self.present(modal, animated: false)
  }
  
  @IBAction func certificateButtonDidTap(_ sender: UIButton) {
    let vm: CertificationViewModelType = CertificationViewModel()
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(
      identifier: "CertificationVC") { coder in
        CertificationViewController(coder: coder, viewModel: vm)
      }
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // 갤러리 버튼을 클릭했을 때 갤러리를 보여준다.
  @IBAction func galaryButtonDidTap(_ sender: UIButton) {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 1
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    self.present(picker, animated: true)
  }
  
  // 카메라 버튼을 클릭했을 때 카메라를 동작시킨다.
  @IBAction func cameraButtonDidTap(_ sender: UIButton) {
    let camera = UIImagePickerController()
    camera.sourceType = .camera
    camera.allowsEditing = true
    camera.cameraDevice = .rear
    camera.cameraCaptureMode = .photo
    camera.delegate = self
    self.present(camera, animated: true)
  }
}

// MARK: Basic functions
extension ChatRoomController {
  func bind() {
    self.bindSection()
    self.bindChatView()
    self.bindKeyboard()
    self.bindLifeCycle()
    self.bindMessageField()
  }
  
  func applyShadow() {
    self.textfieldView.layer.applySketchShadow(alpha: 0.08, x: 2, y: 2, blur: 4, spread: 0)
    self.certificateButton.layer.applySketchShadow(alpha: 0.16, x: 1, y: 1, blur: 2, spread: 0)
    self.certificateButton.layer.cornerRadius = 21
  }
  
  // Configure Chat View(Table View)
  func register() {
    let sendImageCellNib = UINib(nibName: "SendImageCell", bundle: nil)
    chatView.register(sendImageCellNib,
                      forCellReuseIdentifier: SendImageCell.identifier)
    let sendMessageCellNib = UINib(nibName: "SendMessageCell", bundle: nil)
    chatView.register(sendMessageCellNib,
                      forCellReuseIdentifier: SendMessageCell.identifier)
    
    let sendImageMessageCellNib = UINib(nibName: "SendImageMessageCell", bundle: nil)
    chatView.register(sendImageMessageCellNib,
                      forCellReuseIdentifier: SendImageMessageCell.identifier)
    
    let receiveImageCellNib = UINib(nibName: "ReceiveImageCell", bundle: nil)
    chatView.register(receiveImageCellNib,
                      forCellReuseIdentifier: ReceiveImageCell.identifier)
    
    let receiveMessageCellNib = UINib(nibName: "ReceiveMessageCell", bundle: nil)
    chatView.register(receiveMessageCellNib,
                      forCellReuseIdentifier: ReceiveMessageCell.identifier)
    
    let receiveMessageWithProfileCellNib = UINib(nibName: "ReceiveMessageWithProfileCell", bundle: nil)
    chatView.register(receiveMessageWithProfileCellNib,
                      forCellReuseIdentifier: ReceiveMessageWithProfileCell.identifier)
    
    let receiveImageMessageCellNib = UINib(nibName: "ReceiveImageMessageCell", bundle: nil)
    chatView.register(receiveImageMessageCellNib,
                      forCellReuseIdentifier: ReceiveImageMessageCell.identifier)
    
    chatView.register(DateView.self, forHeaderFooterViewReuseIdentifier: DateView.identifier)
  }
  
  func modalButtonDidTap() {
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
}

// MARK: Bind functions
extension ChatRoomController {
  func bindSection() {
    self.viewModel.output.messageList
      .drive(onNext: { [weak self] sections in
        guard let self = self else { return }
        self.sections = sections
      })
      .disposed(by: rx.disposeBag)
  }
  func bindLifeCycle() {
    self.rx.viewWillAppear
      .map { _ in }
      .bind(to: viewModel.input.viewWillAppear)
      .disposed(by: rx.disposeBag)
    
    self.rx.viewWillAppear
      .withLatestFrom(self.viewModel.output.lastPosition)
      .withUnretained(self)
      .bind(onNext: { (owner, arg1) in
        let (row, section) = arg1
        owner.chatView.scrollToRow(at: IndexPath(row: row,
                                                 section: section),
                                   at: .bottom,
                                   animated: true)
      })
      .disposed(by: rx.disposeBag)
    
    Observable
      .merge(self.rx.viewWillAppear.asObservable(), self.rx.viewWillDisappear.asObservable())
      .subscribe(onNext: { state in
        guard let nav = self.navigationController else { return }
        nav.rx.isNavigationBarHidden.onNext(state)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindChatView() {
    self.chatView.rx
      .setDelegate(self)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.title
      .drive(roomTitle.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.leftCertificateCount
      .drive(leftCertificateCount.rx.text)
      .disposed(by: rx.disposeBag)
    
    viewModel.output.ddayCount
      .drive(ddayLabel.rx.text)
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
  }
  
  func bindMessageField() {
    self.textfield.rx
      .controlEvent(.editingDidEndOnExit)
      .withLatestFrom(self.textfield.rx.text)
      .withUnretained(self)
      .bind(onNext: { owner, text in
        guard let profileImage = owner.profileImage,
              let message = text?.description else { return }
        owner.viewModel.input.sendMessage.accept(ChatModel(type: .sendMessage,
                                                           profileImage: profileImage,
                                                           name: owner.name ?? "",
                                                           message: message,
                                                           time: Date.now.formatted(format: "yyyy-MM-dd hh:mm")))
        
        owner.textfield.rx.text.onNext("")
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindKeyboard() {
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
  }
}

// MARK: TableView DataSource, Delegate
extension ChatRoomController: UITableViewDelegate {
  // MARK: Header DataSource
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 35
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let header = chatView.dequeueReusableHeaderFooterView(withIdentifier: DateView.identifier) as? DateView else {
      return UIView()
    }
    let date = sections[section].header
    header.configure(date: date.prefix(10).description)
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }
}

// MARK: CertificationViewController Delegate
extension ChatRoomController: CertificationViewControllerDelegate {
  func certificationViewController(_ certificateMessage: ChatModel) {
    viewModel.input.sendMessage.accept(certificateMessage)
  }
}

// MARK: PHPicker ViewController Delegate
extension ChatRoomController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    modalButtonDidTap()
    guard let result = results.first else { return }
    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
      guard error == nil,
            let self = self,
            let image = image as? UIImage,
            let data = image.pngData(),
            let name = UserDefaults.standard.string(forKey: "name"),
            let profileImage = UserDefaults.standard.string(forKey: "profileImage") else { return }
      let base64 = data.base64EncodedString()
      self.viewModel.input.sendMessage.accept(ChatModel(type: .sendImage,
                                                        profileImage: profileImage,
                                                        name: name,
                                                        message: base64,
                                                        time: Date.now.formatted(format: "yyyy-MM-dd hh:mm")))
    }
  }
}

// MARK: UIImagePickerController Delegate
extension ChatRoomController: UIImagePickerControllerDelegate,
                              UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage,
       let data = image.pngData(),
       let name = UserDefaults.standard.string(forKey: "name"),
       let profileImage = UserDefaults.standard.string(forKey: "profileImage") {
      let base64 = data.base64EncodedString()
      self.viewModel.input.sendMessage.accept(ChatModel(type: .sendImage,
                                                        profileImage: profileImage,
                                                        name: name,
                                                        message: base64,
                                                        time: Date.now.formatted(format: "yyyy-MM-dd hh:mm")))
    }
    picker.dismiss(animated: true)
    modalButtonDidTap()
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
    modalButtonDidTap()
  }
}
