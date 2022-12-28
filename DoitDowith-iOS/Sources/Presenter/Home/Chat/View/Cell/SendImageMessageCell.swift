//
//  SendImageMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/17.
//

import UIKit

import RxSwift
import RxGesture

protocol SendImageMessageCellDelegate: AnyObject {
  func sendImageMessageCell()
}
class SendImageMessageCell: UITableViewCell {
  static let identifier: String = "SendImageMessageCell"
  weak var delegate: SendImageMessageCellDelegate?
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var sendMessageView: UIView!
  @IBOutlet weak var sendImageView: UIImageView!
  @IBOutlet weak var sendMessage: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.applySketchShadow(alpha: 0.04,
                                 x: 2,
                                 y: 2,
                                 blur: 4,
                                 spread: 0)
    self.layer.cornerRadius = 2
    bindSendMessageView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
    self.sendImageView.image = nil
  }
}

extension SendImageMessageCell {
  func configure(model: ChatModel) {
    self.sendImageView.image = UIImage(named: "confirm")
    
    self.sendMessage.text = "\(model.name)님의 인증 메세지"
    
    self.dateLabel.text = model.time.suffix(5).description
  }
  
  func bindSendMessageView() {
    self.sendMessageView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.delegate?.sendImageMessageCell()
      })
      .disposed(by: rx.disposeBag)
  }
}
