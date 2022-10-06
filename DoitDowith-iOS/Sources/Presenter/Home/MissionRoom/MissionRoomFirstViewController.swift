//
//  MissionRoomFirstViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/05.
//

import UIKit

class MissionRoomFirstViewController: UIViewController {
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
  
  @IBAction func didTapNextPageButton(_ sender: UIButton) {
    //    let charRoomService = ChatService()
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
