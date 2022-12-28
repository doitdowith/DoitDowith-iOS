//
//  ModalViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit
import Alamofire

protocol ModalViewControllerDelegate: AnyObject {
    func modalDismissed()
}

class ModalViewController: UIViewController {
    weak var delegate: ModalViewControllerDelegate?
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.modalDismissed()
    }
    let DidDismissPostCommentViewController: Notification.Name = Notification.Name("DidDismissPostCommentViewController")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.alpha = 0.2
        self.view.sendSubviewToBack(mainView)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendBtn(_ sender: UIButton) {
        postDowithCode()
    }
    
    func postDowithCode() {
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            let url = "http://117.17.198.38:8080/api/v1/friends"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = ["Authorization": "Bearer \(token)"]
            
        let queryString : Parameters = [
            "dowithCode" : codeTF.text
                ] as Dictionary
            
            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: queryString, options: [])
            } catch {
                print("http Body Error")
            }
            AF.request(request).responseString { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                case .failure(let error):
                    print("error : \(error.errorDescription!)")
                }
            }
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
