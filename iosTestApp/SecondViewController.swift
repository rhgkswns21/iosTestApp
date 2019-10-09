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
    
    var IMEI:String = ""
    var PanId:String = ""
    //0role, 1ownID, 2PreLoad, 3Duration, 4SyncTime, 5LowPowerMode, 6SSL
    var EntityInfo:[Any] = []
    let TypeString = ["M","S"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        print("SecondView : ", IMEI)
        print("SecondView : ", PanId)
        
        self.IMEILabel.text = IMEI
        
        makeHttpUrl()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning")
    }
    
    @IBAction func GraphBTPush(_ sender: UIBarButtonItem) {
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
    
}
