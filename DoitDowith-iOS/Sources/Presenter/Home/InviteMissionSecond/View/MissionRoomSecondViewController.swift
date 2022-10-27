//
//  MissionRoomSecondViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import Action
import NSObject_Rx
import RxCocoa
import RxSwift
import RxRelay

final class MissionRoomSecondViewController: UIViewController {
  // MARK: Interface Builder
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var friendCollectionView: UICollectionView!
  @IBOutlet weak var makeButton: UIButton!
  @IBOutlet weak var dateTextfield: UITextField!
  @IBOutlet weak var certificateCountTextField: UITextField!
  
  @IBAction func didTapCompleteButton(_ sender: UIButton) {
    let charRoomService = ChatService()
    let stompManager = StompManager(targetId: 1, senderId: "b6dcf006-7fbf-47fc-9247-944b5706222e", connectType: .room)
    let chatRoomViewModel = ChatRommViewModel(id: 1,
                                              chatService: charRoomService,
                                              stompManager: stompManager)
    let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(identifier: "ChatRoomVC",
                                                                                           creator: { coder in
      ChatRoomController(coder: coder, viewModel: chatRoomViewModel)
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
  private let viewModel: MissionRoomSecondViewModelType
  
  // MARK: Initializers
  init?(coder: NSCoder, viewModel: MissionRoomSecondViewModelType) {
    self.viewModel = viewModel
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
                                   bundle: nil).instantiateViewController(withIdentifier: "InviteModalVC")
    
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
    self.viewModel.output.model
      .bind(to: self.friendCollectionView.rx.items(cellIdentifier: FriendProfileCell.identifier,
                                                   cellType: FriendProfileCell.self)) { _, color, cell in
        cell.backgroundColor = color
      }
                                                   .disposed(by: rx.disposeBag)
    
    Observable
      .zip(self.friendCollectionView.rx.itemSelected,
           self.friendCollectionView.rx.modelSelected(UIColor.self))
      .bind { [unowned self] indexPath, _ in
        if indexPath.row == self.viewModel.output.model.value.count - 1 {
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
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindCertificateCountTextField() {
    self.certificateCountTextField.rx.text
      .map { $0! }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        owner.viewModel.input.missionCertificateCount.accept(text)
      })
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
    self.dateTextfield.rx.text.onNext("\(self.datePicker.date.formatted(format: "yy-MM-dd"))")
    self.view.endEditing(true)
  }
}
