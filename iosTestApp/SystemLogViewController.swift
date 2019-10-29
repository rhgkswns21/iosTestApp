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
    var selectTextFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.LogFileListTableView.dataSource = self
        self.LogFileListTableView.delegate = self
        
        let syslogfunc = SysLogFunc()
        self.sysLogFileListArry = syslogfunc.getLogFileList()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.sysLogFileListArry[indexPath.row])
        
        self.selectTextFile = self.sysLogFileListArry[indexPath.row]
        self.performSegue(withIdentifier: "showSystemLogDataViewController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sysLogFileListArry.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: nil)

        cell.textLabel?.text = self.sysLogFileListArry[indexPath.row]

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSystemLogDataViewController" {
            let sysLogDataVC = segue.destination as! SystemLogDataViewController
            sysLogDataVC.NaviTitle = self.selectTextFile
        }
    }
}

