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
        postTest()
    }
    
    func postTest() {
            let url = "http://117.17.198.38:8080/api/v1/friends"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.headers = ["Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiI0YzA3YmUyOS1lZTQzLTQyOGYtYTk1My1iNjM1ODFmZjJmMDgiLCJleHAiOjE2NzE1MTg3MzV9.8SpAo2ZE7QaiWIEO7xJc1hYwnPDkXYZ9FL5iXX8RoqPVJtS3xJGBJFqFgzbYwOODS6hnyTD7GULh7cnYR-3Myw"]
            // POST 로 보낼 정보
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
