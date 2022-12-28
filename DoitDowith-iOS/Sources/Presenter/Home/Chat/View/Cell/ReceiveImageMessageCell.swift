//
//  ReceiveImageMessageCell.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/11/17.
//

import UIKit

import RxSwift
import RxGesture

protocol ReceiveImageMessageCellDelegate: AnyObject {
  func receiveImageMessageCell()
}

class ReceiveImageMessageCell: UITableViewCell {
  static let identifier: String = "ReceiveImageMessageCell"
  
  weak var delegate: ReceiveImageMessageCellDelegate?
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var receiveImageView: UIImageView!
  @IBOutlet weak var receiveMessageView: UIView!
  @IBOutlet weak var receiveMessage: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    bindReceiveMessageView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    self.layer.applySketchShadow(alpha: 0.04,
                                 x: 2,
                                 y: 2,
                                 blur: 4,
                                 spread: 0)
    self.layer.cornerRadius = 2
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
    self.receiveImageView.image = nil
    self.receiveMessage.text = ""
  }
}

extension ReceiveImageMessageCell {
  func configure(model: ChatModel) {
    self.receiveImageView.image = UIImage(named: "confirm")
    self.receiveMessage.text = "\(model.name)님의 인증 메세지"
    
    self.dateLabel.text = model.time.suffix(5).description
  }
  
  func bindReceiveMessageView() {
    self.receiveMessageView.rx.tapGesture()
      .when(.recognized)
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        owner.delegate?.receiveImageMessageCell()
      })
      .disposed(by: rx.disposeBag)
  }
}
