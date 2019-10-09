//
//  GraphViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 09/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit
import iOSDropDown

class GraphViewController: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DropDownTextField: DropDown!

    let format = DateFormatter()
    
    var IMEI:String = ""
    
    var EntityInfo = [Array<String>]()
    var GraphData:String = ""
    var DataArray:[Array<Substring>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.NavigationBar.title = IMEI
        print(IMEI)
        self.DropDownTextField.didSelect { (selectedText, index, id) in
            self.dropDownDidSelect(selectedText: selectedText, index: index, id: id)
        }
        
        let httpFunc = httpFuncList()
        
        self.format.dateFormat = "/dd/MM/yyyy"
        let formattedDate = self.format.string(from: self.DatePicker.date)
        self.EntityInfo = httpFunc.graphDataListGet(IMEI: IMEI, SelectDate: formattedDate)
        
        var DropDownList:[String] = []
        for i in self.EntityInfo{
            DropDownList.append(i[0])
        }
        self.DropDownTextField.optionArray = DropDownList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
        
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print("ChangeDate")
        print("Select Date : ",sender.date)
        let formattedDate = self.format.string(from: sender.date)
        
        let httpFunc = httpFuncList()
        self.EntityInfo = httpFunc.graphDataListGet(IMEI: IMEI, SelectDate: formattedDate)
        
        var DropDownList:[String] = []
        for i in self.EntityInfo{
            DropDownList.append(i[0])
        }
        self.DropDownTextField.optionArray = DropDownList
    }
    
    func dropDownDidSelect(selectedText: String, index: Int, id: Int) {
        print("SelectedText : ", selectedText)
        print(self.EntityInfo[index])
        let httpFunc = httpFuncList()
        self.GraphData = httpFunc.graphDataGet(IMEI: IMEI, SelectDate: self.EntityInfo[index][1])
        for i in self.GraphData.split(separator: "\r\n"){
            let ConverData = i.split(separator: ",")
            self.DataArray.append(ConverData)
        }
        for i in self.DataArray{
            print("x : ", i[1], "y :", i[2], "z : ",i[3])
        }
    }
    
}

