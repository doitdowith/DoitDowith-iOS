//
//  MoreViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var doitCode: UILabel!

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        btnCode.rx.tap
                    .bind(onNext: {
                        UIPasteboard.general.string = self.doitCode.text
                    }).disposed(by: bag)

                if let storedString = UIPasteboard.general.string {
                    print(storedString)
                }
        // Do any additional setup after loading the view.
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
