//
//  ModalViewController.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/10/21.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.alpha = 0.2
        self.view.sendSubviewToBack(mainView)

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
