//
//  AlarmViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/12/27.
//

import UIKit

import RxCocoa
import RxSwift
import RxViewController
import NSObject_Rx

class AlarmViewController: UIViewController {
  // MARK: Properties
  static let identifier: String = "AlarmViewController"
  private let viewModel: AlarmViewModelType
  
  // MARK: Initializer
  required init?(coder: NSCoder, viewModel: AlarmViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerNib()
    self.bind()
  }
  
  // MARK: Interface Builder
  @IBOutlet weak var alamTableView: UITableView!
  @IBOutlet weak var backButton: UIImageView!
}

// MARK: Basic Functions
extension AlarmViewController {
  func registerNib() {
    let alarmNib = UINib(nibName: "AlarmCell", bundle: nil)
    self.alamTableView.register(alarmNib, forCellReuseIdentifier: AlarmCell.identifer)
  }
  
  func backButtonDidTap() {
    self.navigationController?.popViewController(animated: true)
  }
}

// MARK: Bind Functions
extension AlarmViewController {
  func bind() {
    self.bindLifeCycle()
    self.bindAlarmTableView()
    self.bindBackButton()
  }
  
  func bindLifeCycle() {
    // 네비게이션 바 없애기
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      navigationController?.isNavigationBarHidden = visible })
    .disposed(by: rx.disposeBag)
    
    rx.viewWillAppear
      .map { _ in () }
      .bind(to: viewModel.input.fetchAlarms)
      .disposed(by: rx.disposeBag)
  }
  
  func bindAlarmTableView() {
    self.viewModel.output.alarms
      .drive(alamTableView.rx.items(cellIdentifier: AlarmCell.identifer,
                                    cellType: AlarmCell.self)) { _, element, cell in
        cell.configure(model: element)
      }
      .disposed(by: rx.disposeBag)
  }
  
  func bindBackButton() {
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .bind(onNext: { owner, _ in
        owner.backButtonDidTap()
      })
      .disposed(by: rx.disposeBag)
  }
}
