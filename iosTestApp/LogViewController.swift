//
//  LogViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 23/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit

class LogViewController: UIViewController {
    
    var IMEI:String = ""
    var PanID:String = ""
    var LogListData = [String]()
    var NowSelectDate:String = ""
    var PanIDNum:String = ""

    @IBOutlet weak var LogVCNavigationItem: UINavigationItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var LogTextView: UITextView!
    @IBOutlet weak var SearchTextField: UITextField!
    @IBOutlet weak var SearchBT: UIButton!
    
    
    override func viewDidLoad() {
        print("LogViewController")
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        self.NowSelectDate = format.string(from: self.DatePicker.date)
        
        self.PanIDNum = self.PanID
        self.PanIDNum.removeFirst()
        self.PanIDNum.removeFirst()
        
        let httpFunc = httpFuncList()
        self.LogListData = httpFunc.logListGet(PanID: self.PanIDNum, SelectDate: self.NowSelectDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isBeingPresented || isMovingToParent {
            print("viewDidAppear")
            self.LogReLoad()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func DatePickerCalueChanged(_ sender: UIDatePicker) {
        print("DatePickerCalueChanged")
        print(sender.date)
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        let compareDate = format.string(from: self.DatePicker.date)
        
        if self.NowSelectDate != compareDate {
            self.NowSelectDate = compareDate
            self.LogListData.removeAll()
            let httpFunc = httpFuncList()
            self.LogListData = httpFunc.logListGet(PanID: self.PanIDNum, SelectDate: self.NowSelectDate)
        }
        
        self.LogReLoad()
    }
    
    @IBAction func SearchBTPush(_ sender: UIButton) {
        print("SearchBTPush")
        let stringData = self.LogTextView.text
        self.changeAllOccurrence(entireString: stringData ?? "", searchString: self.SearchTextField.text ?? "Now:")
        self.view.endEditing(true)
    }
    
    private func LogReLoad() {
        let activityIndicator = CustomActivityIndicator()
        activityIndicator.showActivityIndicator(uiView: self.view)
        
        self.LogTextView.text.removeAll()
        var logDataString:String = ""
        
        let httpFunc = httpFuncList()
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        let formattedDate = format.string(from: self.DatePicker.date)
        
        for i in self.LogListData {
            if i.contains("dtct_" + formattedDate) {
                if i.contains(IMEI) {
                    logDataString.append(httpFunc.logDataGet(PanID: self.PanIDNum, SelectDate: self.NowSelectDate, FileName: i))
                }
            }
        }
        
        changeAllOccurrence(entireString: logDataString, searchString: "Now:")
        
        activityIndicator.hideActivityIndicator(uiView: self.view)
    }
    
    func changeAllOccurrence(entireString: String,searchString: String){
        
        let attrColor = [NSAttributedString.Key.foregroundColor: UIColor.label]
        let attrStr = NSMutableAttributedString(string: entireString, attributes: attrColor)
        let entireLength = entireString.utf8.count
        var range = NSRange(location: 0, length: entireLength)
        var rangeArr = [NSRange]()
    
        while (range.location != NSNotFound) {
            range = (attrStr.string as NSString).range(of: searchString, options: .caseInsensitive, range: range)
            rangeArr.append(range)
            range = NSRange(location: range.location + range.length, length: entireString.utf8.count - (range.location + range.length))
        }
        
        rangeArr.forEach { (range) in attrStr.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: range) }
        
        self.LogTextView.attributedText = attrStr
        self.LogTextView.isEditable = false
        
        if rangeArr.count > 1 {
            let startindex = entireString.index(entireString.endIndex, offsetBy: -12)
            let endindex = entireString.index(entireString.endIndex, offsetBy: -2)
            let subtext = entireString[startindex ... endindex]
            self.LogVCNavigationItem.title = String(subtext)
        }
        
    }

}
