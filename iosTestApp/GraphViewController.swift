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
    
    @IBOutlet weak var GrapDrawView: UIView!
    
    let xGraph = LineChartView()
    let yGraph = LineChartView()
    let zGraph = LineChartView()
    
    let format = DateFormatter()
    
    var IMEI:String = ""
    
    var EntityInfo = [Array<String>]()
    
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
        graphDraw()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
        
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print("ChangeDate")
        print("Select Date : ",sender.date)
        
        let activityIndicator = CustomActivityIndicator()
        activityIndicator.showActivityIndicator(uiView: self.view)
        
        let formattedDate = self.format.string(from: sender.date)
        
        let httpFunc = httpFuncList()
        self.EntityInfo = httpFunc.graphDataListGet(IMEI: IMEI, SelectDate: formattedDate)
        
        var DropDownList:[String] = []
        for i in self.EntityInfo{
            DropDownList.append(i[0])
        }
        self.DropDownTextField.text = ""
        self.DropDownTextField.optionArray = DropDownList
        
        activityIndicator.hideActivityIndicator(uiView: self.view)
    }
    
    func dropDownDidSelect(selectedText: String, index: Int, id: Int) {
        print("SelectedText : ", selectedText)
        print(self.EntityInfo[index])
        
        let activityIndicator = CustomActivityIndicator()
        activityIndicator.showActivityIndicator(uiView: self.view)

        var GraphData:String = ""
        var DataArray:[Array<Substring>] = []
        
        let httpFunc = httpFuncList()
        GraphData = httpFunc.graphDataGet(IMEI: IMEI, SelectDate: self.EntityInfo[index][1])
        for i in GraphData.split(separator: "\r\n"){
            let ConverData = i.split(separator: ",")
            DataArray.append(ConverData)
        }
        var XData:[Float] = []
        var YData:[Float] = []
        var ZData:[Float] = []
        for i in DataArray{
            XData.append((Float(i[1])!))
            YData.append((Float(i[2])!))
            ZData.append((Float(i[3])!))
        }
        updataGraph(numbers: XData, color: NSUIColor.red, selectGraph: self.xGraph, param: "X")
        updataGraph(numbers: YData, color: NSUIColor.blue, selectGraph: self.yGraph, param: "Y")
        updataGraph(numbers: ZData, color: NSUIColor.yellow, selectGraph: self.zGraph, param: "Z")
        
        activityIndicator.hideActivityIndicator(uiView: self.view)
    }
    
    func updataGraph(numbers: [Float], color: NSUIColor, selectGraph: LineChartView, param: String) {
        print("updataGraph")
        
        var lineCharEntry = [ChartDataEntry]()
        
        for i in 0..<numbers.count {
            let value = ChartDataEntry(x: Double(i), y: Double(numbers[i]))
            lineCharEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries: lineCharEntry, label: "Number")
        
        line1.colors = [color]
        
        line1.drawCircleHoleEnabled = false
        line1.drawCirclesEnabled = false
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        selectGraph.data?.setValueTextColor(color)
        selectGraph.xAxis.labelTextColor = color
        selectGraph.xAxis.labelPosition = XAxis.LabelPosition.bottom
        selectGraph.legend.enabled = false
        selectGraph.chartDescription?.text = param
        selectGraph.chartDescription?.textColor = color
        let left: YAxis = selectGraph.getAxis(YAxis.AxisDependency.left)
        left.labelTextColor = color
        let right: YAxis = selectGraph.getAxis(YAxis.AxisDependency.right)
        right.labelTextColor = color
        
        selectGraph.highlightPerDragEnabled = false
        selectGraph.highlightPerTapEnabled = false
        
        data.setDrawValues(false)
        
        selectGraph.data = data
    }
    
    func graphDraw() {
        self.GrapDrawView.addSubview(self.xGraph)
        self.GrapDrawView.addSubview(self.yGraph)
        self.GrapDrawView.addSubview(self.zGraph)
        
        let margins = GrapDrawView.layoutMarginsGuide
        
        self.xGraph.translatesAutoresizingMaskIntoConstraints = false
        self.yGraph.translatesAutoresizingMaskIntoConstraints = false
        self.zGraph.translatesAutoresizingMaskIntoConstraints = false
        
        self.xGraph.noDataTextColor = UIColor.label
        self.yGraph.noDataTextColor = UIColor.label
        self.zGraph.noDataTextColor = UIColor.label
        
        self.xGraph.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.xGraph.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.xGraph.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.xGraph.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        self.xGraph.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/3, constant: -4.0).isActive = true
        
        self.yGraph.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.yGraph.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.yGraph.topAnchor.constraint(equalTo: self.xGraph.bottomAnchor).isActive = true
        self.yGraph.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        self.yGraph.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/3, constant: -4.0).isActive = true
        
        self.zGraph.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.zGraph.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.zGraph.topAnchor.constraint(equalTo: self.yGraph.bottomAnchor).isActive = true
        self.zGraph.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
        self.zGraph.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/3, constant: -4.0).isActive = true
        
    }
}

