//
//  MissionRoomSecondViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

import NSObject_Rx
import RxCocoa
import RxSwift

class MissionRoomSecondViewController: UIViewController {
  @IBOutlet weak var backButton: UIImageView!
  
  private let viewModel: MisionRoomSecondViewModelType
  
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
  
  init?(coder: NSCoder, viewModel: MisionRoomSecondViewModelType) {
    self.viewModel = viewModel
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func didTapCompleteButton(_ sender: UIButton) {
    let charRoomService = ChatService()
    let chatRoomViewModel = ChatRommViewModel(id: 0, chatService: charRoomService)
    let viewController = UIStoryboard(name: "Home",
                                      bundle: nil).instantiateViewController(identifier: "ChatRoomVC",
                                                                             creator: { coder in
                                        ChatRoomController(coder: coder,
                                                           viewModel: chatRoomViewModel)
                                      })
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
