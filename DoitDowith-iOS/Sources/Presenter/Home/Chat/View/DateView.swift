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
    label.textColor = UIColor.coolGray2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var separateLine: UIView = {
    let line = UIView()
    line.backgroundColor = UIColor.primaryColor5
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
    addSubview(dateLabel)
    addSubview(separateLine)
    
    NSLayoutConstraint.activate([
      self.dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      self.dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
      self.separateLine.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
      self.separateLine.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor, constant: 10),
      self.separateLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      self.separateLine.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
}
