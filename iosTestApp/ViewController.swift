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
}

