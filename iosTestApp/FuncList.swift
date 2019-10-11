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
    private var DataTimeList = [Array<String>]()
    
    func readStringFromTxtFile(with name: String) -> String {
        guard let path = Bundle.main.url(forResource: name, withExtension: "txt")
            else { return "" }
        do {
            let content = try String(contentsOf: path, encoding: .utf8)
            return content
        } catch { return "" }
    }
    
    //Deivce Imei & PanId List Get
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
            if self.errorCheck(error: error, data: data) {
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
    
    //DeviceInfo Data Get
    func deviceInfoGet(IMEI: String) -> [Any]{
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3105/Identity/entities/"+IMEI+"/config")
        var request = URLRequest(url: url!)
        request.httpMethod = "get"
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            if self.errorCheck(error: error, data: data) {
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)

                    let data = str.data(using: .utf8)!
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
    
    //DeviceInfo Data List Get
    func graphDataListGet(IMEI: String, SelectDate: String) -> [Array<String>]{
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3737/influx/live/datalist/"+IMEI+SelectDate)
        var request = URLRequest(url: url!)
        request.httpMethod = "get"
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            if self.errorCheck(error: error, data: data) {
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)

                    let data = str.data(using: .utf8)!
                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Dictionary<String,String>]
                    
                    for i in (json) {
                        let addData = [i["time"], i["timestamp"]]
                        self.DataTimeList.append(addData as! [String])
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
        
        return self.DataTimeList
    }
    
    //DeviceInfo Data Get
    func graphDataGet(IMEI: String, SelectDate: String) -> String{
        var DataString:String = ""
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3737/influx/live/data/"+IMEI+"/"+SelectDate)
        var request = URLRequest(url: url!)
        request.httpMethod = "get"
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            if self.errorCheck(error: error, data: data) {
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    let str = String(strData)

                    let data = str.data(using: .utf8)!
                    let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Dictionary<String,Any>]

                    DataString = json[0]["status"] as! String

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
        
        return DataString
    }
    
    
    //DeviceInfo RemoteCommand
    func remoteCommand(SendData: String, Command: String){
       
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3001/FOTA/action")
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bodyString = "{\"appName\":\"SHM\",\"deviceList\":\"" + SendData + "\",\"action\":\"" + Command + "\"}"
        
        let body = bodyString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        request.httpBody = body
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if self.errorCheck(error: error, data: data) {
                return
            }
            done = true
        })
        task.resume()
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    //DeviceInfo Row Data Get
    func deviceRawDataGet(IMEI: String) -> String{
        var str:String = ""
        
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3105/Identity/entities/"+IMEI+"/config")
        var request = URLRequest(url: url!)
        request.httpMethod = "get"
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            //error 일경우 종료
            if self.errorCheck(error: error, data: data) {
                return
            }
            //data 가져오기
            if let _data = data {
                if let strData = NSString(data: _data, encoding: String.Encoding.utf8.rawValue) {
                    str = String(strData)
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
        
        return str
    }
    
    //DeviceInfo RemoteCommand
    func editDevice(IMEI: String, data: String){
       
        httpURL = readStringFromTxtFile(with: "info_data").trimmingCharacters(in: ["\n"])
        var done = false
        
        let url = URL(string: self.httpURL+":3105/Identity/entities/" + IMEI + "/config")
        var request = URLRequest(url: url!)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let bodyString = "{\"appName\":\"SHM\",\"deviceList\":\"" + SendData + "\",\"action\":\"" + Command + "\"}"
        let bodyString = data
        
        let body = bodyString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        request.httpBody = body
        
        let httpession = URLSession.shared
        let task = httpession.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if self.errorCheck(error: error, data: data) {
                return
            }
            print(data)
            done = true
        })
        task.resume()
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
    }
    
    private func errorCheck(error: Error?, data: Data?) -> Bool{
        //error 일경우 종료
        guard error == nil && data != nil else {
            if let err = error {
                print("Error : ", err.localizedDescription)
            }
            return true
        }
        return false
    }
    
}
