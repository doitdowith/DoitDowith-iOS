//
//  MoreViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Alamofire

class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var dowithCode: UILabel!
    @IBOutlet weak var friendCount: UIButton!
    @IBOutlet weak var friend: UIButton!
    @IBOutlet weak var participationCount: UILabel!
    @IBOutlet weak var successRate: UILabel!
    
    private var profileImageURL: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCode.rx.tap
                    .bind(onNext: { 
                        UIPasteboard.general.string = self.dowithCode.text
                    })
                    .disposed(by: rx.disposeBag)
        
        getTest()
        self.friendCount.addTarget(self, action: #selector(moveFriendVC), for: .touchUpInside)
        self.friend.addTarget(self, action: #selector(moveFriendVC), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func getTest() {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let requestModel = RequestModel(url: "http://117.17.198.38:8080/api/v1/members/mypage",
                                        method: .get,
                                        parameters: nil,
                                        model: Mypage.self,
                                        header: ["Authorization": "Bearer \(token)"])

        NetworkLayer.shared.request(model: requestModel) { (response) in
            if response.error != nil {
                // handle error
            }

            if let data = response.data {
                // use data in your app
                DispatchQueue.main.async {
                    self.userName.text = data.name
                    self.profileImageURL = "http://117.17.198.38:8080/images/\(data.profileImage)"
                    self.userImage.setImage(with: self.profileImageURL!)
                    self.dowithCode.text = data.dowithCode
                    self.friendCount.setTitle("\(data.friendCount)명", for: .normal)
                    self.friendCount.titleLabel?.font = UIFont(name: "Pretendard-Bold", size: 14)
                    self.participationCount.text = "\(data.participationCount)번"
                    self.successRate.text = "\(data.successRate)%"
                    print(data)
                }
            }
        }
    }
    
    @objc func moveFriendVC() {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(identifier: FriendListViewController.identifier) { coder in
            FriendListViewController(coder: coder, doitCode: self.dowithCode.text, userName: self.userName.text, userImageURL: self.profileImageURL!)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "otherCell", for: indexPath) as? OtherTableViewCell else { return UITableViewCell() }
            // 셀에 넣을 text을 정하고
        
        switch indexPath.row {
        case 0: cell.setOtherLabelCell(text: "공지사항")
        case 1: cell.setOtherLabelCell(text: "고객센터")
        case 2: cell.setOtherLabelCell(text: "앱 설정")
        default: cell.setOtherLabelCell(text: "공지사항")
        }
        // 셀에 text를 넣어준다.
        // 셀을 리턴한다.
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "NoticeViewController")
                self.navigationController?.pushViewController(pushVC!, animated: true)
                 
        case 1:
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "CSViewController")
                self.navigationController?.pushViewController(pushVC!, animated: true)
                   
        case 2:
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController")
                self.navigationController?.pushViewController(pushVC!, animated: true)
                    
        default: break
        }
    }
}
