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
  // MARK: Interface Builder
  @IBOutlet weak var backButton: UIImageView!
  @IBOutlet weak var missionColorView: UICollectionView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var nextPageButton: UIButton!
  
  @IBAction func didTapNextPageButton(_ sender: UIButton) {
    let missionRoomSecondViewModel: MissionRoomSecondViewModelType = MisionRoomSecondViewModel()
    self.viewModel.output.passData
      .do(onNext: { print($0) })
      .bind(to: missionRoomSecondViewModel.input.passedData)
      .disposed(by: rx.disposeBag)
    
    let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(
      identifier: "MissionRoomSecondVC",
      creator: { coder in
        MissionRoomSecondViewController(coder: coder,
                                        viewModel: missionRoomSecondViewModel)
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
      .bind(to: self.missionColorView.rx.items(cellIdentifier: ColorCell.identifier,
                                               cellType: ColorCell.self)) { _, color, cell in
        cell.backgroundColor = color
      }
      .disposed(by: rx.disposeBag)
    
    Observable
      .zip(self.missionColorView.rx.itemSelected, self.missionColorView.rx.modelSelected(UIColor.self))
      .withUnretained(self)
      .bind(onNext: { owner, arg in
        let indexPath = arg.0
        let color = arg.1
        print(color)
        owner.viewModel.input.currentMissionColor.accept(color.accessibilityName)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindNameTextField() {
    self.nameTextField.rx.text
      .debounce(.seconds(1), scheduler: MainScheduler.instance)
      .filter { $0 != nil }
      .map { $0! }
      .filter { !$0.isEmpty }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        print("name: ", text)
        owner.viewModel.input.currentMissionName.accept(text)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindDescriptionTextField() {
    self.descriptionTextField.rx.text
      .debounce(.seconds(1), scheduler: MainScheduler.instance)
      .filter { $0 != nil }
      .map { $0! }
      .filter { !$0.isEmpty }
      .withUnretained(self)
      .bind(onNext: { owner, text in
        print("des: ", text)
        owner.viewModel.input.currentMissionDetail.accept(text)
      })
      .disposed(by: rx.disposeBag)
  }
  
  func bindNextPageButton() {
  }
}
