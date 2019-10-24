//
//  ViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 07/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import UIKit
import iOSDropDown
import Starscream

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

//    let socket = WebSocket(url: NSURL(string: "ws://111.93.235.82:301/devices/live")! as URL)
//
//    func websocketDidConnect(socket: WebSocketClient) {
//        print("websocketDidConnect")
//    }
//
//    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("websocketDidDisconnect")
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("websocketDidReceiveMessage")
//        print(text)
//    }
//
//    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("websocketDidReceiveData")
//        print(data)
//    }
//
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var DeivceAddButton: UIBarButtonItem!
    @IBOutlet weak var DeviceInfoView: UIView!
    
    @IBOutlet weak var CancelBT: UIButton!
    @IBOutlet weak var OKBT: UIButton!
    
    @IBOutlet weak var EntityIDTextField: UITextField!
    @IBOutlet weak var PanIDDropDown: DropDown!
    @IBOutlet weak var FriendlyNameTextField: UITextField!
    @IBOutlet weak var TypeDropDown: DropDown!
    @IBOutlet weak var OwnIDTextField: UITextField!
    @IBOutlet weak var DurationTextField: UITextField!
    @IBOutlet weak var PreLoadTextField: UITextField!
    @IBOutlet weak var SyncTimeTextField: UITextField!
    @IBOutlet weak var LowPowerModeSwitch: UISwitch!
    @IBOutlet weak var SSLSwitch: UISwitch!
    
    var PassData = [String]()
    
    let fileManager = FileManager()
    
    var httpURL: String!
    
    var IDlist = [Array<String>]()
    
    var PanIDList = [String]()

    let test = CustomActivityIndicator()
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        
//        self.socket.delegate = self
//        self.socket.connect()
        
        
        self.DeviceInfoView.isHidden = true
        self.CancelBT.layer.borderColor = UIColor.lightGray.cgColor
        self.CancelBT.layer.borderWidth = 1.5
        self.OKBT.layer.borderColor = UIColor.lightGray.cgColor
        self.OKBT.layer.borderWidth = 1.5
        self.DeviceInfoView.layer.borderColor = UIColor.lightGray.cgColor
        self.DeviceInfoView.layer.borderWidth = 2
        
        self.NavigationBar.title = "Deviece List"
        self.TableView.dataSource = self
        self.TableView.delegate = self
        
        let httpFunc = httpFuncList()
        self.IDlist = httpFunc.imeiGet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        let httpFunc = httpFuncList()
        self.PanIDList = httpFunc.panIDListGet()
        self.PanIDDropDown.optionArray = self.PanIDList
        self.TypeDropDown.optionArray = ["M","S"]
    }
    
    @IBAction func testdd(_ sender: UIBarButtonItem) {
        print("TEST")
    }
    
    @IBAction func CancelBTPush(_ sender: UIButton) {
        print("CancelBTPush")
        self.DeviceInfoView.isHidden = true
    }
    
    @IBAction func OKBTPush(_ sender: UIButton) {
        print("OKBTPush")
        self.DeviceInfoView.isHidden = true
        
        let httpFunc = httpFuncList()
        httpFunc.createDevice(IMEI: self.EntityIDTextField.text!, Name: self.FriendlyNameTextField.text!, PanId: self.PanIDDropDown.text!)
        
        httpFunc.initCreateDevice(IMEI: self.EntityIDTextField.text!, Type: String(self.TypeDropDown.selectedIndex!+1), OwnID: self.OwnIDTextField.text!, PreLoad: self.PreLoadTextField.text!, Duration: self.DurationTextField.text!, SyncTime: self.SyncTimeTextField.text!, LPM: String(self.LowPowerModeSwitch.isOn), SSL: String(self.SSLSwitch.isOn))
        
        self.IDlist.removeAll()
        self.IDlist = httpFunc.imeiGet()
        self.TableView.reloadData()
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
            print(indexPath.row)
            print(self.IDlist[indexPath.row][0])
            let httpFunc = httpFuncList()
            httpFunc.deviceDelete(IMEI: self.IDlist[indexPath.row][0])
            self.IDlist.removeAll()
            self.IDlist = httpFunc.imeiGet()
            self.TableView.reloadData()
        }
    }
    
}

