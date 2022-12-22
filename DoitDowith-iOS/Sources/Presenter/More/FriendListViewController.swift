//
//  FriendListViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation
import Kingfisher

// MARK: - Welcome
struct Welcome: Codable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let memberID, profileImage, name: String

    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case profileImage, name
    }
}

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let identifier = "FriendListViewController"
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
        }

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showModal(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(identifier: "ModalViewVC") as? ModalViewController else { return }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var dowithCode: UILabel!
    @IBOutlet weak var friendCount: UILabel!
    
    let doitcode: String?
    let username: String?
    let bag = DisposeBag()
    var model: [Datum] = []
    
    init?(coder: NSCoder, doitCode: String?, userName: String?) {
        self.doitcode = doitCode
        self.username = userName
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCode.rx.tap
                    .bind(onNext: {
                        UIPasteboard.general.string = self.dowithCode.text
                    }).disposed(by: bag)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.friendCount.text = "친구 \(model.count)명"
        self.dowithCode.text = doitcode
        self.userName.text = username
        getTest()
        // Do any additional setup after loading the view.
    }
    
    func getTest() {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let requestModel = RequestModel(url: "http://117.17.198.38:8080/api/v1/friends/my",
                                        method: .get,
                                        parameters: nil,
                                        model: Welcome.self,
                                        header: ["Authorization": "Bearer \(token)"])

        NetworkLayer.shared.request(model: requestModel) { [weak self] (response) in
            guard let self = self else { return }
            if response.error != nil {
                // handle error
            }

            if let data = response.data {
                // use data in your app
                DispatchQueue.main.async { [self] in
                    self.model = data.data
                    self.friendCount.text = "친구 \(self.model.count)명"
                    self.tableView.reloadData()
                }
            }
        }
    }
        
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FriendListTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendListTableViewCell)!
                
        cell.friendNameLabel?.text = model[indexPath.row].name
        cell.numLabel?.text = model[indexPath.row].memberID
        cell.friendImage.setImage(with: "http://117.17.198.38:8080/images/\(model[indexPath.row].profileImage)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
}

extension FriendListViewController: ModalViewControllerDelegate {
    func modalDismissed() {
        self.getTest()
    }
}
