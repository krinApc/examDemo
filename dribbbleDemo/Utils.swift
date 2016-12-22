//
//  Utils.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/22.
//  Copyright © 2016年 rin. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func saveImage(image: UIImage, name: String) {
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("\(name).png")
            if let pngImageData = UIImagePNGRepresentation(image) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print("SAVE FAILED!!! name=\(name)")
        }
    }
    
    class func readImage(name: String) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent("\(name).png").path
        if FileManager.default.fileExists(atPath: filePath) {
            return UIImage(contentsOfFile: filePath)!
        }
        
        return nil
    }
    
    class func dateFromString(string: String, format: String) -> NSDate {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)! as NSDate
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date as Date)
    }
}
