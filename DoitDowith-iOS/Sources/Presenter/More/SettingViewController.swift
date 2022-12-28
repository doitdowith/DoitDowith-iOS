//
//  SettingViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit
import KakaoSDKUser

class SettingViewController: UIViewController {
    @IBOutlet weak var navigationView: UIView!

    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
        }
    @IBAction func logout() {
        UserApi.shared.logout {(error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("logout() success.")

                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            exit(0)
                        }
                    }
                }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 뷰 밑줄
        let border = CALayer()
        border.frame = CGRect(x: 0, y: navigationView.frame.size.height-1, width: navigationView.frame.width, height: 0.4)
        border.backgroundColor = UIColor.systemGray.cgColor
        navigationView.layer.addSublayer((border))

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
