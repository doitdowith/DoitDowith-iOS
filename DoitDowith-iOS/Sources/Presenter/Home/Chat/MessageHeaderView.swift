//
//  MessageHeaderView.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/28.
//

import UIKit

final class MessageHeaderView: UIView {
  @IBOutlet weak var dateLabel: UILabel!
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      registerXib()
  }
  
  required init?(coder: NSCoder) {
      super.init(coder: coder)
  }
}

extension MessageHeaderView {
  func configure(day: String) {
    dateLabel?.text = day
  }
  
  func registerXib() {
    let nib = UINib(nibName: "MessageHeaderView", bundle: nil)
    guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
    xibView.frame = self.bounds
    xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(xibView)
  }
}
