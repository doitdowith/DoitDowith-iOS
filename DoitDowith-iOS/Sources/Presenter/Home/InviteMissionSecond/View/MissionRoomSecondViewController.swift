//
//  MissionRoomSecondViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import Action
import Kingfisher
import NSObject_Rx
import RealmSwift
import RxCocoa
import RxSwift
import RxRelay

final class MissionRoomSecondViewController: UIViewController {
  private let viewModel: MissionRoomSecondViewModelType
  var chatRequest: RequestType?
  private var passdata: FirstRoomPassData?
  
  private var startDate: String?
  private var certificateCount: String?
  private var friendList: [String]?
  
  // MARK: Initializers
  init?(coder: NSCoder,
        viewModel: MissionRoomSecondViewModelType,
        passdata: FirstRoomPassData) {
    self.viewModel = viewModel
    self.passdata = passdata
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    self.friendCollectionView.collectionViewLayout = self.collectionViewLayout()
    self.registerCells()
    self.configureDatePicker()
    self.bind()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var friendCollectionView: UICollectionView!
  @IBOutlet weak var makeButton: UIButton!
  @IBOutlet weak var dateTextfield: UITextFieldWithPadding!
  @IBOutlet weak var certificateCountTextField: UITextFieldWithPadding!
  
  @IBAction func didTapCompleteButton(_ sender: UIButton) {
    guard let passdata = passdata,
          let startDate = startDate,
          let certificateCount = certificateCount,
          let count = Int(certificateCount),
          let friendList = friendList else { return }
    
    let body: [String: Any] = ["certificationCount": count,
                               "color": passdata.color,
                               "description": passdata.description,
                               "participants": friendList,
                               "startDate": startDate,
                               "title": passdata.name]
    let request = RequestType(endpoint: "room", method: .post, parameters: body)
    APIService.shared.request(request: request)
      .map { (response: CreateRoomResponse) -> String in
        print("roomdId: ", response.roomId)
        return response.roomId
      }
      .withUnretained(self)
      .bind(onNext: { (owner, id: String) in
        owner.navigateChat(roomId: id)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func navigateChat(roomId: String) {
    guard let passdata = passdata,
          let startDate = startDate,
          let certificateCount = certificateCount,
          let count = Int(certificateCount),
          let friendList = friendList,
          let memberId = UserDefaults.standard.string(forKey: "memberId") else { return }
    
    let stompManager = StompManager(roomId: roomId,
                                    memberId: memberId)
    
    let chatService = ChatService()
    chatService.createChatRoom(roomId: roomId.hash)
    
    let card = Card(section: 1,
                    roomId: roomId,
                    title: passdata.name,
                    description: passdata.description,
                    color: passdata.color,
                    startDate: startDate,
                    participants: friendList.map { Participant(name: $0, profileImage: "") },
                    count: count)
    
    let chatRoomViewModel = ChatRommViewModel(card: card,
                                              stompManager: stompManager,
                                              chatService: chatService)
    stompManager.viewModel = chatRoomViewModel
    
    let viewController = UIStoryboard(name: "Home",
                                      bundle: nil).instantiateViewController(identifier: "ChatRoomVC",
                                                                             creator: { coder in
                                        ChatRoomController(coder: coder, card: card, viewModel: chatRoomViewModel)
                                      })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  // MARK: Properties
  private lazy var datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.preferredDatePickerStyle = .wheels
    picker.datePickerMode = .date
    return picker
  }()
}

// MARK: Basic functions
extension MissionRoomSecondViewController {
  func bind() {
    self.bindLifeCylce()
    self.bindBackButton()
    self.bindFriendCollectionView()
    self.bindMakeButton()
    self.bindDateTextField()
    self.bindCertificateCountTextField()
    self.bindFriendList()
  }
  
  func registerCells() {
    let friendCellNib = UINib(nibName: "FriendProfileCell", bundle: nil)
    self.friendCollectionView.register(friendCellNib,
                                       forCellWithReuseIdentifier: FriendProfileCell.identifier)
  }
  
  func collectionViewLayout() -> UICollectionViewLayout {
    let size = NSCollectionLayoutSize(widthDimension: .absolute(48),
                                      heightDimension: .absolute(48))
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                      heightDimension: .absolute(48)),
                                                   subitems: [item])
    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  func action1() {
    let inviteModal = UIStoryboard(name: "Home",
                                   bundle: nil).instantiateViewController(identifier: InviteModalViewController.identifier) { coder in
      InviteModalViewController(coder: coder, parentViewModel: self.viewModel)
    }
    inviteModal.modalPresentationStyle = .overCurrentContext
    self.present(inviteModal, animated: false)
  }
}

// MARK: Bind ViewModel
extension MissionRoomSecondViewController {
  func bindLifeCylce() {
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      navigationController?.isNavigationBarHidden = visible
    })
    .disposed(by: rx.disposeBag)
    
    rx.viewWillAppear
      .take(1)
      .map { _ in () }
      .bind(to: viewModel.input.fetchFriends)
      .disposed(by: rx.disposeBag)
  }
  
  func bindBackButton() {
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak navigationController]_ in
        navigationController?.popViewController(animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindFriendCollectionView() {
    self.friendCollectionView.allowsMultipleSelection = true
    self.viewModel.output.model
      .map { $0 + ["https://cdn-icons-png.flaticon.com/512/117/117885.png"] }
      .drive(self.friendCollectionView.rx.items(cellIdentifier: FriendProfileCell.identifier,
                                                cellType: FriendProfileCell.self)) { _, item, cell in
        if item == "https://cdn-icons-png.flaticon.com/512/117/117885.png" {
          cell.profileImage.setImage(with: "https://cdn-icons-png.flaticon.com/512/117/117885.png",
                                     processor: RoundCornerImageProcessor(cornerRadius: 22))
        } else {
          cell.configure(url: item)
        }
      }
      .disposed(by: rx.disposeBag)
    
    Observable
      .zip(self.friendCollectionView.rx.itemSelected,
           self.friendCollectionView.rx.modelSelected(String.self))
      .bind { [unowned self] indexPath, _ in
        if indexPath.row == self.friendCollectionView.numberOfItems(inSection: 0) - 1 {
          self.action1()
        }
      }
      .disposed(by: rx.disposeBag)
  }
  
  func bindMakeButton() {
    self.viewModel.output.buttonEnabled
      .drive(self.makeButton.rx.isUserInteractionEnabled)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.buttonColor
      .drive(self.makeButton.rx.backgroundColor)
      .disposed(by: rx.disposeBag)
    
    self.makeButton.layer.cornerRadius = 2
    self.makeButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
  }
  
  func bindDateTextField() {
    self.dateTextfield.rx.text
      .map { $0! }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        owner.viewModel.input.missionStartDate.accept(text)
        owner.startDate = text
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindCertificateCountTextField() {
    self.certificateCountTextField.rx.text
      .map { $0! }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        owner.viewModel.input.missionCertificateCount.accept(text)
        owner.certificateCount = text
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindFriendList() {
    self.viewModel.output.selectedFriends
      .drive(onNext: { self.friendList = $0 })
      .disposed(by: rx.disposeBag)
  }
}

// MARK: DatePicker functions
extension MissionRoomSecondViewController {
  func configureDatePicker() {
    self.dateTextfield.inputView = self.datePicker
    self.dateTextfield.inputAccessoryView = self.createDoneButton()
  }
  
  func createDoneButton() -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: nil,
                                     action: #selector(donePressed))
    toolbar.setItems([doneButton], animated: true)
    return toolbar
  }
  
  @objc func donePressed() {
    self.dateTextfield.rx.text.onNext("\(self.datePicker.date.formatted(format: "yyyy-MM-dd"))")
    self.view.endEditing(true)
  }
}
