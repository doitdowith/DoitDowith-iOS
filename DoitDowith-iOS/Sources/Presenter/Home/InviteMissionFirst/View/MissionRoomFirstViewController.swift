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
  
  @IBAction func didTapNextPageButton(_ sender: UIButton) {
    let missionRoomSecondViewModel: MissionRoomSecondViewModelType = MisionRoomSecondViewModel()
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
    self.bindMissionColoView()
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
  
  func bindMissionColoView() {
    self.viewModel.output.missionColors
      .bind(to: self.missionColorView.rx.items(cellIdentifier: ColorCell.identifier,
                                               cellType: ColorCell.self)) { _, color, cell in
        cell.backgroundColor = color
      }
                                               .disposed(by: rx.disposeBag)
  }
}
