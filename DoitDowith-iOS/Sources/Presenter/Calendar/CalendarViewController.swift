//
//  CalendarViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBAction func prevBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
    }
    
    private func scrollCurrentPage(isPrev: Bool) {
        let cal = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = isPrev ? -1 : 1
        
        self.currentPage = cal.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CustomCell.identifier,
                                                      for: date,
                                                      at: position) as? CustomCell else {
            return FSCalendarCell()
        }
                
        switch dateFormatter.string(from: date) {
        case "2022-12-08":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        case "2022-12-09":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        case "2022-12-10":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        case "2022-12-11":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        case "2022-12-12":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        case "2022-12-13":
            cell.configure(model: ["15분 홈트하기"])
            return cell
        default:
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        calendarView.register(CustomCell.self,
                              forCellReuseIdentifier: CustomCell.identifier)
        print("dd")
        
        calendarView.calendarHeaderView.backgroundColor = UIColor.white
        calendarView.calendarWeekdayView.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
