//
//  DVTHelper.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//


import Foundation
import SystemConfiguration
import UIKit




/*-EXTENSIONS-*/



extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}

extension Dictionary {
    mutating func update(_ other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


/*
 Append 2 strings with a comma delimeter
 */

extension String {
    mutating func joinNonEmptyString(_ newString :String) {
        
        if (self.isEmpty){
            
            self = newString
            
        } else {
            
            self += ", " + newString
            
        }
    }
    
    
}





/*-STRUCTS-*/
struct Typealiases {
    typealias JSONDict = [String:Any]
}


/*-METHODS-*/

func downloadImage(url: URL, imageView : UIImageView) {
    print("Download Started")
    getDataFromUrl(url: url) { (data, response, error)  in
        guard let data = data, error == nil else { return }
        print(response?.suggestedFilename ?? url.lastPathComponent)
        print("Download Finished")
        DispatchQueue.main.async() { () -> Void in
            imageView.image = UIImage(data: data)
        }
    }
}



func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
    URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        completion(data, response, error)
        }.resume()
}

func getHour() -> Int{
    
    return Calendar.current.component(.hour, from: Date())
    
    
}


/*
Custom 12-hour clock implementation from Epoch Timestamp
*/

func getHourFromTimeStamp(unixTimestamp : Int) -> Int {
    
    let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
    
    let hour = Calendar.current.component(.hour, from: date)
    
    if (hour > 12) {
        
        return (24 - hour)
        
    }
    
    return hour
}

/*
 Formatted Day + 12-hour clock
 */

func getFormattedDayTime() -> String {
    
    let date = Date()
    
    let weekDay = date.dayOfWeek()
    
    let hour = Calendar.current.component(.hour, from: date)
    
    let minutes = Calendar.current.component(.minute, from: date)
    
     let minuteString = String(format: "%02d", minutes)
    
    if (hour == 0 ){
    
        return weekDay! + " \(12):\(minuteString)" + " AM"
        
    }
    
    
    if (hour == 12 ){
        
        return weekDay! + " \(12):\(minuteString)" + " PM"
        
    }
    
    
    
    if (hour > 12) {
        
        return weekDay! + " \(24 - hour):\(minuteString)" + " PM"
        
    }
    
    
    return weekDay! + " \(hour):\(minuteString)" + " AM"
}


func getHourMinutesFromTimeStamp(unixTimestamp : Int) -> String {
    
    let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
    
    let hour = Calendar.current.component(.hour, from: date)
    
    let minutes = Calendar.current.component(.minute, from: date)
    
    
    let minuteString = String(format: "%02d", minutes)
    
    if (hour == 0 ){
        
        return "\(12):\(minuteString)" + " AM"
        
    }
    
    
    if (hour == 12 ){
        
        return "\(12):\(minuteString)" + " PM"
        
    }
    
    
    if (hour > 12) {
        
        return "\(24 - hour):\(minuteString) PM"
        
    }
    
    return "\(hour):\(minuteString) AM"
}





/*-CLASSES-*/

class DVTHelper {
    
    func showAlert (message : String, viewController : UIViewController){
        
        let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        viewController.present(alert, animated: true){}
  
    }
    
}
