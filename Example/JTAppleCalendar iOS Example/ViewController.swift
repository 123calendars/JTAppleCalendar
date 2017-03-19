//
//  ViewController.swift
//  JTAppleCalendar iOS Example
//
//  Created by JayT on 2016-08-10.
//
//

import JTAppleCalendar

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!

    @IBOutlet var numbers: [UIButton]!
    @IBOutlet var headerss: [UIButton]!
    @IBOutlet var directions: [UIButton]!
    @IBOutlet var outDates: [UIButton]!
    @IBOutlet var inDates: [UIButton]!
    @IBOutlet var scrollDate: UITextField!
    @IBOutlet var selectFrom: UITextField!
    @IBOutlet var selectTo: UITextField!

    var numberOfRows = 6
    let formatter = DateFormatter()
    var testCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    let firstDayOfWeek: DaysOfWeek = .monday
    let disabledColor = UIColor.lightGray
    let enabledColor = UIColor.blue
    let dateCellSize: CGFloat? = nil
    var monthSize: MonthSize? = MonthSize(defaultSize: 50, months: [75: [.feb, .apr]])
    
    let red = UIColor.red
    let white = UIColor.white
    let black = UIColor.black
    let gray = UIColor.gray
    let shade = UIColor(colorWithHexValue: 0x4E4E4E)

    @IBAction func changeToRow(_ sender: UIButton) {
        numberOfRows = Int(sender.title(for: .normal)!)!

        for aButton in numbers {
            aButton.tintColor = disabledColor
        }
        sender.tintColor = enabledColor
        calendarView.reloadData()
    }

    @IBAction func changeDirection(_ sender: UIButton) {
        for aButton in directions {
            aButton.tintColor = disabledColor
        }
        sender.tintColor = enabledColor

        if sender.title(for: .normal)! == "Horizontal" {
            calendarView.scrollDirection = .horizontal
            calendarView.itemSize = 0
        } else {
            calendarView.scrollDirection = .vertical
            calendarView.itemSize = 25
        }
        calendarView.reloadData()
    }
    
    @IBAction func toggleStrictBoundary(sender: UIButton) {
        hasStrictBoundaries = !hasStrictBoundaries
        if hasStrictBoundaries {
            sender.tintColor = enabledColor
        } else {
            sender.tintColor = disabledColor
        }
        calendarView.reloadData()
    }
    
    @IBAction func headers(_ sender: UIButton) {
        for aButton in headerss {
            aButton.tintColor = disabledColor
        }
        sender.tintColor = enabledColor

        if sender.title(for: .normal)! == "HeadersOn" {
            monthSize = MonthSize(defaultSize: 50, months: [75: [.feb, .apr]])
        } else {
            monthSize = nil
        }
        calendarView.reloadData()
    }

    @IBAction func outDateGeneration(_ sender: UIButton) {
        for aButton in outDates {
            aButton.tintColor = disabledColor
        }
        sender.tintColor = enabledColor

        switch sender.title(for: .normal)! {
        case "EOR":
            generateOutDates = .tillEndOfRow
        case "EOG":
            generateOutDates = .tillEndOfGrid
        case "OFF":
            generateOutDates = .off
        default:
            break
        }
        calendarView.reloadData()

    }

    @IBAction func inDateGeneration(_ sender: UIButton) {
        for aButton in inDates {
            aButton.tintColor = disabledColor
        }
        sender.tintColor = enabledColor

        switch sender.title(for: .normal)! {
            case "First":
                generateInDates = .forFirstMonthOnly
            case "All":
                generateInDates = .forAllMonths
            case "Off":
                generateInDates = .off
        default:
            break
        }

        calendarView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        calendarView.itemSize = CGFloat(53.43 - 20)
        
        
        
        
//        testCalendar = Calendar(identifier: .gregorian)
//        let timeZone = TimeZone(identifier: "Asia/Amman")!
//        testCalendar.timeZone = timeZone
//        
//        let locale = Locale(identifier: "ar_JO")
//        testCalendar.locale = locale

//        calendarView.calendarDataSource = self
//        calendarView.calendarDelegate = self
        // ___________________________________________________________________
        // Registering header cells is optional
        
        calendarView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                              withReuseIdentifier: "PinkSectionHeaderView")
//
        
//        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
//        panGensture.minimumPressDuration = 0.5
//        calendarView.addGestureRecognizer(panGensture)
//        calendarView.rangeSelectionWillBeUsed = true
        
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calendarView.viewWillTransition(to: size, with: coordinator)
    }
    
    var rangeSelectedDates: [Date] = []
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !calendarView.selectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: calendarView.selectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let followingDay = testCalendar.date(byAdding: .day, value: 1, to: date)!
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
    
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func selectDate(_ sender: AnyObject?) {
        let fromDate = formatter.date(from: selectFrom.text!)!
        let toDate = formatter.date(from: selectTo.text!)!
        self.calendarView.selectDates(from: fromDate, to: toDate)
    }

    @IBAction func scrollToDate(_ sender: AnyObject?) {
        let text = scrollDate.text!
        let date = formatter.date(from: text)!
        calendarView.scrollToDate(date)
    }

    @IBAction func printSelectedDates() {
        print("\nSelected dates --->")
        for date in calendarView.selectedDates {
            print(formatter.string(from: date))
        }
        
        
    }

    @IBAction func resize(_ sender: UIButton) {
        calendarView.frame = CGRect(
            x: calendarView.frame.origin.x,
            y: calendarView.frame.origin.y,
            width: calendarView.frame.width,
            height: calendarView.frame.height - 50
        )
        calendarView.reloadData()
    }

    @IBAction func reloadCalendar(_ sender: UIButton) {
        calendarView.reloadData()
        
    }

    @IBAction func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.next) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }

    @IBAction func previous(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.previous) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
    func handleCellConfiguration(cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = black
            } else {
                myCustomCell.dayLabel.textColor = gray
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView else {return }
//        switch cellState.selectedPosition() {
//        case .full:
//            myCustomCell.backgroundColor = .green
//        case .left:
//            myCustomCell.backgroundColor = .yellow
//        case .right:
//            myCustomCell.backgroundColor = .red
//        case .middle:
//            myCustomCell.backgroundColor = .blue
//        case .none:
//            myCustomCell.backgroundColor = nil
//        }
        
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  13
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
}

// MARK : JTAppleCalendarDelegate
extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 03 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.JTApple(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        
        myCustomCell.dayLabel.text = cellState.text
        if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = red
        } else {
            myCustomCell.backgroundColor = white
        }
        
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        return myCustomCell
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func scrollDidEndDecelerating(for calendar: JTAppleCalendarView) {
        self.setupViewsOfCalendar(from: calendarView.visibleDates())
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let date = range.start
        let month = testCalendar.component(.month, from: date)
        
        let header: JTAppleCollectionReusableView
        if month % 2 > 0 {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "WhiteSectionHeaderView", for: indexPath)
            (header as! WhiteSectionHeaderView).title.text = formatter.string(from: date)
        } else {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath)
            (header as! PinkSectionHeaderView).title.text = formatter.string(from: date)
        }
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return monthSize
    }
}
