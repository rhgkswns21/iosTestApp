//
//  ViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 07/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var DeivceAddButton: UIBarButtonItem!
    @IBOutlet weak var DeviceInfoView: UIView!
    
    @IBOutlet weak var CancelBT: UIButton!
    @IBOutlet weak var OKBT: UIButton!
    
    
    var PassData = [String]()
    
    let fileManager = FileManager()
    
    var httpURL: String!
    
    var IDlist = [Array<String>]()

    let test = CustomActivityIndicator()
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.DeviceInfoView.isHidden = true
        self.CancelBT.layer.borderColor = UIColor.lightGray.cgColor
        self.CancelBT.layer.borderWidth = 1.5
        self.OKBT.layer.borderColor = UIColor.lightGray.cgColor
        self.OKBT.layer.borderWidth = 1.5
        
        self.NavigationBar.title = "Deviece List"
        self.TableView.dataSource = self
        self.TableView.delegate = self
        
        let httpFunc = httpFuncList()
        self.IDlist = httpFunc.imeiGet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondViewController" {
            let secondVC = segue.destination as! SecondViewController
            secondVC.IMEI = self.PassData[0]
            secondVC.PanId = self.PassData[1]
            self.PassData.removeAll()
        }
    }
    
    @IBAction func DeviceAddBTPush(_ sender: UIBarButtonItem) {
        print("DeviceAddBTPush")
        
        self.DeviceInfoView.isHidden = false
        
        
//        let margins = self.view.layoutMarginsGuide
//
//        let deviceInfoView = UIView()
//        deviceInfoView.bounds.size = CGSize(width: (8/10)*self.view.bounds.width, height: (8/10)*self.view.bounds.height)
//        deviceInfoView.center = CGPoint(x: self.view.center.x, y: (self.view.center.y)+22)
//        deviceInfoView.backgroundColor = UIColor.gray
//        self.view.addSubview(deviceInfoView)
        
//        deviceInfoView.translatesAutoresizingMaskIntoConstraints = false
        
//        deviceInfoView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//        deviceInfoView.topAnchor.constraint(equalTo: 10).isActive = true
//        deviceInfoView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//        deviceInfoView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//        deviceInfoView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
//        deviceInfoView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 8/10, constant: -4.0).isActive = true
//        deviceInfoView.bottomAnchor.constraint(equalTo: margins.bottom, multiplier: 1/3, constant: -4.0).isActive = true
        
        
        
//        let margins = GrapDrawView.layoutMarginsGuide
//self.xGraph.translatesAutoresizingMaskIntoConstraints = false
        
//        self.xGraph.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//        self.xGraph.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//        self.xGraph.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//        self.xGraph.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
//        self.xGraph.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/3, constant: -4.0).isActive = true
    }
    
    @IBAction func CancelBTPush(_ sender: UIButton) {
        print("CancelBTPush")
        self.DeviceInfoView.isHidden = true
    }
    
    @IBAction func OKBTPush(_ sender: UIButton) {
        print("OKBTPush")
        self.DeviceInfoView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(IDlist[indexPath.row])
        self.PassData.append(IDlist[indexPath.row][0])
        self.PassData.append(IDlist[indexPath.row][1])
        self.performSegue(withIdentifier: "showSecondViewController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.IDlist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: nil)

        cell.detailTextLabel?.text = self.IDlist[indexPath.row][1]
        cell.textLabel?.text = self.IDlist[indexPath.row][0]

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("delete")
        }
    }
}

