//
//  SysLogFunc.swift
//  iosTestApp
//
//  Created by Hanjun Ko on 25/10/2019.
//  Copyright © 2019 Hanjun Ko. All rights reserved.
//

import Foundation

class SysLogFunc {
    
    let fileManager = FileManager.default
    var documentsDir:URL
    var syslogDirectory:URL
    var todayLogFile:URL
    var nowDate:String
    let today = Date()
    let format = DateFormatter()
    
    
    init() {
        
        self.format.dateFormat = "yyyyMMdd"
        self.nowDate = format.string(from: self.today)

        self.documentsDir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.syslogDirectory = self.documentsDir.appendingPathComponent("SysLog")
        self.todayLogFile = self.syslogDirectory.appendingPathComponent(self.nowDate + ".txt")
    }
    
    func directoryList() {
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: self.documentsDir.path)
            let tetet = try fileManager.subpathsOfDirectory(atPath: self.documentsDir.path)
            print(tetet)
            //Check SysLog Dir
            if contents.contains("SysLog") {
                do {
                    var text:String = readLogFile(selsetLogFile: self.nowDate + ".txt")
                        
                        let textFormat = DateFormatter()
                        textFormat.dateFormat = "HH:mm:ss"
                        text.append(textFormat.string(from: self.today) + "    Device Start\n\r")
                    do {
                        try text.write(to: self.todayLogFile, atomically: false, encoding: .utf8)
                    }
                }
            }
            else {
                //Make SysLogDir
                do {
                    try fileManager.createDirectory(atPath: self.syslogDirectory.path, withIntermediateDirectories: false, attributes: nil)
                    do {
                        var text:String = readLogFile(selsetLogFile: self.nowDate + ".txt")
                        
                        let textFormat = DateFormatter()
                        textFormat.dateFormat = "HH:mm:ss"
                        text.append(textFormat.string(from: self.today) + "    Device Start\n\r")
                        do {
                            try text.write(to: self.todayLogFile, atomically: false, encoding: .utf8)
                        }
                    }
                    catch let error as NSError {
                        print("Error Writing File : \(error.localizedDescription)")
                    }
                }
                catch let error as NSError {
                    print("Error creating directory: \(error.localizedDescription)")
                }
            }
        }
        catch let error as NSError {
            print("Error access directory: \(error)")
        }
    }
    
    func readLogFile(selsetLogFile: String) -> String{
        do {
            let logText = try String(contentsOf: self.todayLogFile, encoding: .utf8)
            return logText
        }
        catch let error as NSError {
            print("Error Reading File : \(error.localizedDescription)")
        }
        
        return ""
    }
    
    func getLogFileList() -> [String]{
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: self.syslogDirectory.path)
            return contents
        }
        catch {
            print("Error access directory : \(error.localizedDescription)")
        }
        return [""]
    }

}
