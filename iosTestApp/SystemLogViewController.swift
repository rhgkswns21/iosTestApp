//
//  SystemLogViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 25/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation
import UIKit

class SystemLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var LogFileListTableView: UITableView!
    
    var sysLogFileListArry:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.LogFileListTableView.dataSource = self
        self.LogFileListTableView.delegate = self
        
        let syslogfunc = SysLogFunc()
//        syslogfunc.directoryList()
        self.sysLogFileListArry = syslogfunc.getLogFileList()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.sysLogFileListArry[indexPath.row])
        let syslogfunc = SysLogFunc()
        print(syslogfunc.readLogFile(selsetLogFile: self.sysLogFileListArry[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sysLogFileListArry.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)

        cell.textLabel?.text = self.sysLogFileListArry[indexPath.row]

        return cell
    }
}

