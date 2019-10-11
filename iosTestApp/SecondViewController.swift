//
//  SecondViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 07/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
        
    @IBOutlet weak var GraphBT: UIBarButtonItem!
    
    @IBOutlet weak var IMEILabel: UILabel!
    
    @IBOutlet weak var PanIdTextField: UITextField!
    @IBOutlet weak var TypeTextField: UITextField!
    @IBOutlet weak var OwnIdTextField: UITextField!
    @IBOutlet weak var DurationTextField: UITextField!
    @IBOutlet weak var PreLoadTextField: UITextField!
    @IBOutlet weak var SyncTimeTextField: UITextField!
    
    @IBOutlet weak var LowPowerModeSwitch: UISwitch!
    @IBOutlet weak var SslSwitch: UISwitch!
    
    @IBOutlet weak var SampleBT: UIButton!
    @IBOutlet weak var ReStartBT: UIButton!
    @IBOutlet weak var ReBootBT: UIButton!
    
    @IBOutlet weak var SaveBT: UIButton!
    
    var IMEI:String = ""
    var PanId:String = ""
    //0role, 1ownID, 2PreLoad, 3Duration, 4SyncTime, 5LowPowerMode, 6SSL
    var EntityInfo:[Any] = []
    let TypeString = ["M","S"]
    
    var touchFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        print("SecondView : ", self.IMEI)
        print("SecondView : ", self.PanId)
        
        self.IMEILabel.text = self.IMEI
        
        makeHttpUrl()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        self.touchFlag = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    @IBAction func GraphBTPush(_ sender: UIBarButtonItem) {
        print("GraphBTPush")
        if self.touchFlag == false{
            self.touchFlag = true
            self.performSegue(withIdentifier: "showGraphViewController", sender: self)
        }
    }
    
    @IBAction func SampleBTPush(_ sender: UIButton) {
        print("SampleBTPush")
        let httpFunc = httpFuncList()
        httpFunc.remoteCommand(SendData: self.PanId.uppercased(), Command: "Sample")
    }
    
    @IBAction func ReStartBTPush(_ sender: UIButton) {
        print("ReStartBTPush")
        let httpFunc = httpFuncList()
        httpFunc.remoteCommand(SendData: self.IMEI, Command: "Restart")
    }
    
    @IBAction func ReBootBTPusg(_ sender: UIButton) {
        print("ReBootBTPusg")
        let httpFunc = httpFuncList()
        httpFunc.remoteCommand(SendData: self.IMEI, Command: "Reboot")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGraphViewController" {
            let graphVC = segue.destination as! GraphViewController
            graphVC.IMEI = self.IMEI
        }
    }
    
    func makeHttpUrl() {
        print("makeHttpUrl")
        
        let httpFunc = httpFuncList()
        self.EntityInfo = httpFunc.deviceInfoGet(IMEI: IMEI)
        
        self.PanIdTextField.text = PanId
        self.TypeTextField.text = self.TypeString[(self.EntityInfo[0] as! Int) - 1]
        self.OwnIdTextField.text = String(self.EntityInfo[1] as! String)
        self.DurationTextField.text = String(self.EntityInfo[3] as! Int)
        self.PreLoadTextField.text = String(self.EntityInfo[2] as! Int)
        self.LowPowerModeSwitch.isOn = self.EntityInfo[5] as! Bool
        self.SyncTimeTextField.text = String(self.EntityInfo[4] as! Int)
        self.SslSwitch.isOn = self.EntityInfo[6] as! Bool
    }
    
    @IBAction func saveBTPush(_ sender: UIButton) {
        print("testBTPush")
        let httpFunc = httpFuncList()
        let rawData = httpFunc.deviceRawDataGet(IMEI: IMEI)
        print(rawData)
        var rawDict = self.convertToDictionary(text: rawData)

        if self.TypeTextField.text == "M"{
            rawDict!["role"] = 1
        }
        else{
            rawDict!["role"] = 2
        }
        
        rawDict!["ownId"] = self.OwnIdTextField.text
        rawDict!["preload"] = Int(self.PreLoadTextField.text!)
        rawDict!["duration"] = Int(self.DurationTextField.text!)
        rawDict!["syncTime"] = Int(self.SyncTimeTextField.text!)
        rawDict!["lowPowerMode"] = self.LowPowerModeSwitch.isOn
        rawDict!["useSSL"] = self.SslSwitch.isOn
        
        let editData = self.convertToJSON(rawData: rawDict!)
        httpFunc.editDevice(IMEI: IMEI, data: editData)
    }
    
    private func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    private func convertToJSON(rawData: [String: Any]) -> String {
        var theJSONText:String = ""
        if let theJSONData = try? JSONSerialization.data(withJSONObject: rawData, options: []){
            theJSONText = String(data: theJSONData, encoding: .ascii)!
        }
        return theJSONText
    }
    
    @IBAction func LowPowerModeValueChanged(_ sender: UISwitch) {
        print("LowPowerModeValueChanged")
    }
    
    @IBAction func SSLValueChanged(_ sender: UISwitch) {
        print("SSLValueChanged")
    }
    
}
