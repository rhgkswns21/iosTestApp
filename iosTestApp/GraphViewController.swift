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
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var DropDownTextField: DropDown!

    
    @IBOutlet weak var chtChart: LineChartView!
    
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
        var XData:[Float] = []
        for i in self.DataArray{
            print("x : ", i[1], "y :", i[2], "z : ",i[3])
            
            XData.append((Float(i[1]) as! Float))
        }
        updataGraph(numbers: XData)
    }
    
    func updataGraph(numbers:[Float]) {
        
        
        var lineCharEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: Double(numbers[i]))
            lineCharEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineCharEntry, label: "Number")
        
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        
        data.addDataSet(line1)
        
        chtChart.clipsToBounds = false
        chtChart.clipDataToContentEnabled = false
        chtChart.data?.highlightEnabled = false
        chtChart.drawMarkers = false
        chtChart.data?.setValueTextColor(NSUIColor.white)
        chtChart.data?.highlightEnabled = false
        line1.drawCircleHoleEnabled = false
        line1.drawCirclesEnabled = false
        
        chtChart.data = data
        chtChart.chartDescription?.text = "My Chart"
        chtChart.chartDescription?.textColor = NSUIColor.white
        }
    
}

