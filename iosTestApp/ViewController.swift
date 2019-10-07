//
//  ViewController.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 07/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var TableView: UITableView!
    
    let fileManager = FileManager()
    
    var httpURL: String!
    
    var IDlist = [Array<String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.NavigationBar.title = "Deviece IMEI"
        self.TableView.dataSource = self
        
        self.httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        imeiGet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    private func readStringFromTxtFile(with name: String) -> String {
        guard let path = Bundle.main.url(forResource: name, withExtension: "txt")
            else { return "" }
        do {
            let content = try String(contentsOf: path, encoding: .utf8)
            return content
        } catch { return "" }
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

    func imeiGet() {
        print("imeiGet")
        let url = URL(string: self.httpURL+":3105/Identity/entities")
        var request = URLRequest(url: url!)
        request.httpMethod = "get"

        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            guard error == nil && data != nil else {
                if let err = error {
                    print(err.localizedDescription)
                }
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)

                    let data = str.data(using: .utf8)!
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>]

                    for i in (json ?? nil)! {
                        let addData = [i["entityId"], i["panId"]]
                        self.IDlist.append(addData as! [String])
                    }
                    DispatchQueue.main.async {
                        self.TableView.reloadData()
                    }
                }
            }else{
                print("data nil")
            }
        })
        task.resume()
    }
}

