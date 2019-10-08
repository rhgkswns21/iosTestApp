//
//  FuncList.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 08/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation

class httpFuncList {
    
    private var httpURL = String()
    private var IDlist = [Array<String>]()
    private var entityInfo : [Any] = []
    
    func readStringFromTxtFile(with name: String) -> String {
        guard let path = Bundle.main.url(forResource: name, withExtension: "txt")
            else { return "" }
        do {
            let content = try String(contentsOf: path, encoding: .utf8)
            return content
        } catch { return "" }
    }
    

    func imeiGet() -> [Array<String>] {
        print("imeiGet")
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3105/Identity/entities")
        var request = URLRequest(url: url!)
        request.httpMethod = "get"

        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            guard error == nil && data != nil else {
                if let err = error {
                    print("Error : ", err.localizedDescription)
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
                    done = true
                }
            }else{
                print("data nil")
            }
        })
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        return self.IDlist
    }
    
    //
    func deviceInfoGet(IMEI: String) -> [Any]{
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3105/Identity/entities/"+IMEI+"/config")
//        let url = URL(string: self.httpURL+":3105/Identity/entities")
        var request = URLRequest(url: url!)
        request.httpMethod = "get"
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            guard error == nil && data != nil else {
                if let err = error {
                    print("Error : ", err.localizedDescription)
                }
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)

                    let data = str.data(using: .utf8)!
//                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>]
                    let json : [String:Any] = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                    self.entityInfo.append(json["role"] as! Int)
                    self.entityInfo.append(json["ownId"] as! String)
                    self.entityInfo.append(json["preload"] as! Int)
                    self.entityInfo.append(json["duration"] as! Int)
                    self.entityInfo.append(json["syncTime"] as! Int)
                    self.entityInfo.append(json["lowPowerMode"] as! Bool)
                    self.entityInfo.append(json["useSSL"] as! Bool)
                    
                    done = true
                }
            }else{
                print("data nil")
            }
        })
        
        task.resume()
        
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        print(self.entityInfo)
        return self.entityInfo
    }
    
}
