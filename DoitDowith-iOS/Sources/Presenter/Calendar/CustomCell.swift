//
//  CustomCell.swift
//  DoitDowith-iOS
//
//  Created by 이예림 on 2022/12/07.
//

import Foundation
import FSCalendar

class CustomCell: FSCalendarCell {
    static let identifier: String = "CustomCell"
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        
        self.titleLabel.textAlignment = .left
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 13).isActive = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCell {
    func configure(model: [String]) {
        let colors = [UIColor(r: 255, g: 226, b: 226), UIColor(r: 227, g: 245, b: 213), UIColor(r: 25, g: 226, b: 226)]
        
        for (index, event) in model.enumerated() {
            let label = UILabel()
            label.text = event
            label.backgroundColor = colors[index]
            label.textColor = UIColor(r: 48, g: 53, b: 61)
            label.font = label.font.withSize(9)
            label.heightAnchor.constraint(equalToConstant: 19).isActive = true

            self.stackView.addArrangedSubview(label)
        }
    }
}
