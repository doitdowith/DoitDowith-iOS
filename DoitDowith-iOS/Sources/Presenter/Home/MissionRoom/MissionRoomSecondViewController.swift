//
//  MissionRoomSecondViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

class MissionRoomSecondViewController: UIViewController {
  private let viewModel: MisionRoomSecondViewModelType
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    self.navigationController?.navigationBar.isHidden = false
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
