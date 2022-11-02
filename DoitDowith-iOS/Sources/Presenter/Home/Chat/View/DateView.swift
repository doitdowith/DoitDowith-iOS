//
//  DateView.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/10/31.
//

import UIKit

class DateView: UITableViewHeaderFooterView {
  static let identifier: String = "ChatViewSectionHeader"
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.font = UIFont(name: "Pretendard-Regular", size: 11)
    label.textColor = UIColor(red: 169/255, green: 175/255, blue: 185/255, alpha: 1)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var separateLine: UIView = {
    let line = UIView()
    line.backgroundColor = UIColor(red: 218/255, green: 223/255, blue: 236/255, alpha: 1)
    line.translatesAutoresizingMaskIntoConstraints = false
    return line
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureContents()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.dateLabel.text = ""
  }
}

extension DateView {
  func configure(date: String) {
    self.dateLabel.text = date
  }
  func configureContents() {
    contentView.addSubview(dateLabel)
    contentView.addSubview(separateLine)
    
    NSLayoutConstraint.activate([
      self.dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      self.dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
      self.separateLine.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
      self.separateLine.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: 10),
      self.separateLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      self.separateLine.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
}
