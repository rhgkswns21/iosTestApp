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
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        print("LogViewController")
        print(self.IMEI)
        print(self.PanID)
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMM"
        let formattedDate = format.string(from: self.DatePicker.date)
        var PanIDNum = self.PanID
        PanIDNum.removeFirst()
        PanIDNum.removeFirst()
        let httpFunc = httpFuncList()
        self.LogListData = httpFunc.logListGet(PanID: PanIDNum, SelectDate: formattedDate)
        
        for i in self.LogListData {
            if i.contains("dtct_20191010") {
                print(i)
            }
        }
    }
    
    @IBAction func DatePickerCalueChanged(_ sender: UIDatePicker) {
        print("DatePickerCalueChanged")
        print(sender.date)
    }
    
}
