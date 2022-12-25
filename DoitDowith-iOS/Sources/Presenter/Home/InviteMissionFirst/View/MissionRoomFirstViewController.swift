//
//  MissionRoomFirstViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxSwift
import RxRelay

final class MissionRoomFirstViewController: UIViewController {
  static let identifier: String = "MissionRoomFirstVC"
  // MARK: Interface Builder
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var missionColorView: UICollectionView!
  @IBOutlet weak var nameTextField: UITextFieldWithPadding!
  @IBOutlet weak var descriptionTextField: UITextFieldWithPadding!
  @IBOutlet weak var nextPageButton: UIButton!
  
  private var name: String?
  private var detail: String?
  private var color: String?
  
  @IBAction func didTapNextPageButton(_ sender: UIButton) {
    guard let name = name,
          let detail = detail,
          let color = color else { return }
    let vm = MisionRoomSecondViewModel()
    let passdata = FirstRoomPassData(name: name, description: detail, color: color)
    let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(
      identifier: "MissionRoomSecondVC",
      creator: { coder in
        MissionRoomSecondViewController(coder: coder,
                                        viewModel: vm,
                                        passdata: passdata)
      })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  // MARK: Property
  private let viewModel: MissionRoomFirstViewModelType
  
  // MARK: Initializer
  init?(coder: NSCoder, viewModel: MissionRoomFirstViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder: viewModel:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.missionColorView.collectionViewLayout = self.collectionViewLayout()
    self.bind()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

// MARK: - Basic Functions
extension MissionRoomFirstViewController {
  func registerNib() {
    let colorCell = UINib(nibName: "ColorCell", bundle: nil)
    self.missionColorView.register(colorCell,
                                   forCellWithReuseIdentifier: ColorCell.identifier)
  }
  
  func bind() {
    self.bindLifeCycle()
    self.bindBackButton()
    self.bindMissionColorView()
    self.bindNameTextField()
    self.bindDescriptionTextField()
    self.bindNextPageButton()
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
}

// MARK: - Bind ViewModel
extension MissionRoomFirstViewController {
  func bindLifeCycle() {
    Observable
      .merge([rx.viewWillAppear.map { _ in true },
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
  
  func bindMissionColorView() {
    self.viewModel.output.missionColors
      .drive(self.missionColorView.rx.items(cellIdentifier: ColorCell.identifier,
                                            cellType: ColorCell.self)) { [weak self] (_, color: Int, cell: ColorCell) in
        guard let self = self else { return }
        cell.configure(color: UIColor(hex: color))
        self.color = "\(color)"
      }
      .disposed(by: rx.disposeBag)
    
    Observable
      .zip(self.missionColorView.rx.itemSelected,
           self.missionColorView.rx.modelSelected(Int.self))
      .withUnretained(self)
      .bind(onNext: { owner, arg in
        let color = arg.1
        owner.viewModel.input.currentMissionColor.accept("\(color)")
        owner.color = "\(color)"
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindNameTextField() {
    self.nameTextField.rx.text
      .map { $0! }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        owner.viewModel.input.currentMissionName.accept(text)
        owner.name = text
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindDescriptionTextField() {
    self.descriptionTextField.rx.text
      .map { $0! }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        owner.viewModel.input.currentMissionDetail.accept(text)
        owner.detail = text
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindNextPageButton() {
    self.viewModel.output.buttonEnabled
      .drive(self.nextPageButton.rx.isUserInteractionEnabled)
      .disposed(by: rx.disposeBag)
    
    self.viewModel.output.buttonColor
      .drive(onNext: {
        self.nextPageButton.setTitleColor($0, for: .normal)
      })
      .disposed(by: rx.disposeBag)
  }
}
