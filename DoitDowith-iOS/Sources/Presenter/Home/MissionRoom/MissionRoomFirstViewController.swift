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

class MissionRoomFirstViewController: UIViewController {
  @IBOutlet weak var backButton: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Observable.merge([
      rx.viewWillAppear.map { _ in true },
      rx.viewWillDisappear.map { _ in false }])
    .bind(onNext: { [weak navigationController] visible in
      print(visible)
      navigationController?.isNavigationBarHidden = visible
    })
    .disposed(by: rx.disposeBag)
    
    self.backButton.rx
      .tapGesture()
      .when(.recognized)
      .bind(onNext: { [weak navigationController]_ in
        navigationController?.popViewController(animated: true)
      })
      .disposed(by: rx.disposeBag)
  }
  
  @IBAction func didTapNextPageButton(_ sender: UIButton) {
    // let charRoomService = ChatService()
    let missionRoomSecondViewModel: MisionRoomSecondViewModelType = MisionRoomSecondViewModel()
    let viewController = UIStoryboard(name: "Home",
                                      bundle: nil).instantiateViewController(identifier: "MissionRoomSecondVC",
                                                                             creator: { coder in
                                        MissionRoomSecondViewController(coder: coder,
                                                                        viewModel: missionRoomSecondViewModel)
                                      })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
