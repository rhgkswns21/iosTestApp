//
//  GraphViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 09/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit

class GraphViewController: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    var IMEI:String = ""
    
    var EntityInfo:[Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.NavigationBar.title = IMEI
        print(IMEI)
    }
        
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print("ChangeDate")
        print("Select Date : ",sender.date)
        let format = DateFormatter()
        format.dateFormat = "/dd/MM/yyyy"
        let formattedDate = format.string(from: sender.date)
        
        let httpFunc = httpFuncList()
        self.EntityInfo = httpFunc.graphDataListGet(IMEI: IMEI, SelectDate: formattedDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
}

