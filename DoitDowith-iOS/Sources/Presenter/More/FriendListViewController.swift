//
//  FriendListViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    let korean: [String] = ["이예림", "박재영", "조구영", "김영균", "해범이", "지민석"]
    let url = ["https://img.hankyung.com/photo/202208/03.30968100.1.jpg",
               "https://mblogthumb-phinf.pstatic.net/MjAxODEwMTlfMTgx/MDAxNTM5OTI4MjAwNDEx.k7oG-Q0tA6bdI1smaMzsK4t08NREjRrq3OthZKoIz8Qg.BeZxWi7HekwTWipOckbNWpvnesXuHjpldNGA7QppprUg.JPEG.retspe/eb13.jpg?type=w800",
               "https://www.korea.kr/goNewsRes/attaches/innods/images/000088/32_640.jpg",
               "https://www.jungle.co.kr/image/abf6121743c2afa9cf97332d",
               "https://www.kocca.kr/cmm/fnw/getImage.do?atchFileId=FILE_000000001097009&fileSn=1",
               "https://mir-s3-cdn-cf.behance.net/projects/404/760686114652663.Y3JvcCw4MDgsNjMyLDAsMA.png",
               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCTnkfkeA6mFkBzzTPVWh2KwZKEF3dJRn03g&usqp=CAU"
    ]
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListTableViewCell)!

        let text: String = korean[indexPath.row]
        let text2: String = String(indexPath.row + 1)
                
        cell.friendNameLabel?.text = text
        cell.numLabel?.text = text2

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return korean.count
    }
}

// extension FriendListViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListTableViewCell else { return UITableViewCell() }
//
//        return cell
//    }
// }
