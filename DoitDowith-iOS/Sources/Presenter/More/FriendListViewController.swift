//
//  FriendListViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class FriendListViewController: UIViewController {
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
        }

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showModal(_ sender: UIButton) {
    }
    
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var doitCode: UILabel!

    let bag = DisposeBag()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCode.rx.tap
                    .bind(onNext: {
                        UIPasteboard.general.string = self.doitCode.text
                    }).disposed(by: bag)

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

extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
