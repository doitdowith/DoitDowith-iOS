//
//  ChatHeaderView.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/02.
//

import UIKit

class ChatHeaderView: UIView {
  @IBOutlet weak var dateLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.loadXib()
  }
  
  private func loadXib() {
    let identifier = String(describing: type(of: self))
    let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
    
    guard let customView = nibs?.first as? UIView else { return }
    customView.frame = self.bounds
    self.addSubview(customView)
  }
}
