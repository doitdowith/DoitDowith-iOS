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
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var dowithCode: UILabel!
    @IBOutlet weak var friendCount: UIButton!
    @IBOutlet weak var participationCount: UILabel!
    @IBOutlet weak var successRate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCode.rx.tap
                    .bind(onNext: { 
                        UIPasteboard.general.string = self.dowithCode.text
                    })
                    .disposed(by: rx.disposeBag)
        getTest()
        
        // Do any additional setup after loading the view.
    }
    
    func getTest() {
        let requestModel = RequestModel(url: "http://117.17.198.38:8080/api/v1/members/mypage",
                                        method: .get,
                                        parameters: nil,
                                        model: Mypage.self,
                                        header: ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiI0YzA3YmUyOS1lZTQzLTQyOGYtYTk1My1iNjM1ODFmZjJmMDgiLCJleHAiOjE2NzA5MjU2NDV9.H5dUy0NvtC1p4ieeHhxokJkbo0SgLa4nzRpqhoR6J1yD35pxxK1hefm_2FTXzXLMp87I0z2BpS-FjrLq97w7Cg"])

        NetworkLayer.shared.request(model: requestModel) { (response) in
            if response.error != nil {
                // handle error
            }

            if let data = response.data {
                // use data in your app
                DispatchQueue.main.async {
                    self.dowithCode.text = data.dowithCode
                    self.friendCount.setTitle("\(data.friendCount)", for: .normal)
                    self.participationCount.text = String(data.participationCount)
                    self.successRate.text = String(data.successRate)
                    print(data)
                }
            }
        }
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
