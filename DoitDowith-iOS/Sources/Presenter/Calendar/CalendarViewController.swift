//
//  CalendarViewController.swift
//  DoitDowith-iOS
//
//  Created by 김영균 on 2022/09/20.
//

import UIKit
import FSCalendar

struct Mission: Codable {
    let data: [Datumm]
}

// MARK: - Datumm
struct Datumm: Codable {
    let startDate: String
    let title: [String]

    enum CodingKeys: String, CodingKey {
        case startDate
        case title
    }
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBAction func prevBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        scrollCurrentPage(isPrev: false)
    }
    
    var model: [Datumm] = []
    
    private func scrollCurrentPage(isPrev: Bool) {
        getCalendar()
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
    
    func getCalendar() {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let requestModel = RequestModel(url: "http://117.17.198.38:8080/api/v1/calendar/my",
                                        method: .get,
                                        parameters: nil,
                                        model: Mission.self,
                                        header: ["Authorization": "Bearer \(token)"])

        DispatchQueue.global().async { [weak self] in
            NetworkLayer.shared.request(model: requestModel) { [weak self] (response) in
                guard let self = self else { return }
                if response.error != nil {
                    // handle error
                }

                if let data = response.data {
                    print(data)
                    // use data in your app
                    DispatchQueue.main.async { [weak self] in
                        self?.model = data.data
                        self?.calendarView.reloadData()
                    }
                }
            }
        }
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(withIdentifier: CustomCell.identifier,
                                                      for: date,
                                                      at: position) as? CustomCell else {
            return FSCalendarCell()
        }
        cell.initConfigure()

        let formattedDate = dateFormatter.string(from: date)

        model.forEach {
            if formattedDate == $0.startDate {
                cell.configure(model: $0.title)
            }
        }
        return cell
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
        
        getCalendar()
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
