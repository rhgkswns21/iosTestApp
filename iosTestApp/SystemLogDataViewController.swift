//
//  SystemLogDataViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 29/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit

class SystemLogDataViewController: UIViewController{
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    @IBOutlet weak var LogTextView: UITextView!
    
    var NaviTitle = ""
    var LogTextData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        print(self.NaviTitle)
        self.NavigationItem.title = self.NaviTitle
        
        let syslogfunc = SysLogFunc()
//        print()
        
//        self.LogTextView.text = self.LogTextView.text
        self.LogTextView.text = syslogfunc.readLogFile(selectortLogFile: self.NaviTitle)
    }

}
