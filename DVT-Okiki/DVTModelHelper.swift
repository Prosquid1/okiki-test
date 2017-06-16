//
//  DVTModelHelper.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//

import Foundation



//Sample OWRMain response
//"main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75}

class OWRMain : NSObject {
    
    var humidity = Int()
    var temp = Double()
    var temp_min = Double()
    var temp_max = Double()
    
    convenience init( values :[String: AnyObject]) {
        self.init()
        
        for (key, value) in values {
            let keyName = key as String
            
            if (self.responds(to:NSSelectorFromString(keyName))) {
                self.setValue(value, forKey: keyName)
            }
        }
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        
        
        if key == "humidity" {
            
            if let humidityValue = value as? Int {
                humidity = humidityValue
            }
            
        } else if key == "temp" {
            
            if let tempValue = value as? Double {
                temp = tempValue
            }
            
        } else if key == "temp_min" {
            
            if let tempMinValue = value as? Double {
                temp_min = tempMinValue
            }
            
        } else if key == "temp_max" {
            
            if let tempMaxValue = value as? Double {
                temp_max = tempMaxValue
            }
        }
        
    }
    
    
}


//Sample OWRWind response:
//"wind":{"speed":5.52,"deg":311}
class OWRWind : NSObject {
    
    
    var speed = Double()
    
    convenience init( values :[String: AnyObject]) {
        self.init()
        
        for (key, value) in values {
            let keyName = key as String
            
            if (self.responds(to:NSSelectorFromString(keyName))) {
                
                
                if let speedValue = value as? Double {
                    
                    speed = speedValue
                    
                }
                
                
            }
        }
    }
    
    
    
}


//Sample OWRWeather response:
//"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}]

class OWRWeather : NSObject {
    
    var weatherDescription : String = ""
    var weatherDescriptionIcon : String = ""
    
    convenience init( weatherValueArray :[[String: AnyObject]]) {
        self.init()
        
        //Since a weather can have multiple values, the plan is to append every weather's description
        //https://openweathermap.org/weather-conditions
        
        for value in weatherValueArray {
            
            for (key, value) in value {
                
                let keyName = key as String
                
                
                print("KeyName " + keyName)
                print("value \(value)")
                
                self.setValue(value, forKey: keyName)
                
                
            }
            
            
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        
        if key == "description" {
            
            
            if let mainValue = value as? String {
                
                //Custom Join to reflect mutiple weather descriptions
                
                //weather : [{description : "Clear Sky" ....}, {description : "Other Description" ....} ] becomes
                //OWRWeather.weatherDescription : "Clear Sky, Other Description"
                
                weatherDescription.joinNonEmptyString(mainValue)
                
                
                
            }
        } else if (key == "icon") {
            
            //We're working with the icon of the first weather item
            if let mainValue = value as? String {
                
                if (weatherDescriptionIcon.isEmpty){
                    
                    weatherDescriptionIcon = mainValue
                    
                }
            }
        } else{
            
            print("Key not in use")
            
        }
        
    }
}


//Sample OWRSys response
//: {"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863}
class OWRSys : NSObject {
    
    
    var sunriseTimeSeconds = Int()
    var sunsetTimeSeconds = Int()
    
    convenience init( values :[String: AnyObject]) {
        self.init()
        
        for (key, value) in values {
            //let keyName = key as String
            
            
            if (key == "sunrise") {
                
                if let sunriseValue = value as? Int {
                    
                    sunriseTimeSeconds = sunriseValue
                    
                } else {
                    
                    print("TypeOf Sunrise: \(type(of:value))")
                }
                
            } else if (key == "sunset") {
                
                if let sunsetValue = value as? Int {
                    
                    sunsetTimeSeconds = sunsetValue
                    
                } else {
                    
                    print("TypeOf Sunset: \(type(of:value))")
                    
                }
                
            } else {
                
                print("Key is: " + key)
            }
            
            
            
            
            
        }
    }
    
    
    
}



//Classic OpenWeatherResponse

/*
 "weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],
 
 "main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75}
 
 "wind":{"speed":5.52,"deg":311},"clouds":{"all":0}
 
 "sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863}
 */


class OpenWeatherReponse : NSObject {
    
    var main = OWRMain()
    var weather = OWRWeather()
    var wind = OWRWind()
    var sys = OWRSys()
    
    
    init(JSONString: String) {
        super.init()
        
        
        let JSONData = JSONString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        do {
            
            let JSONDictionary: Dictionary = try JSONSerialization.jsonObject(with: JSONData!, options: []) as! [String: AnyObject]
            
            for (key, value) in JSONDictionary {
                
                let keyName = key as String
                let keyValue = value as AnyObject
                
                // If property exists
                
                if (!keyValue.isKind(of: NSNull.self)){
                    
                    
                    if (keyName == "weather" ){
                        
                        weather = OWRWeather(weatherValueArray: keyValue as! [[String : AnyObject]])
                        
                    } else if (keyName == "main" ){
                        
                        main = OWRMain(values: keyValue as! [String : AnyObject])
                        
                    } else if (keyName == "wind" ){
                        
                        wind = OWRWind(values: keyValue as! [String : AnyObject])
                        
                    } else if (keyName == "sys" ){
                        
                        sys = OWRSys(values: keyValue as! [String : AnyObject])
                    }
                    
                    
                }
            }
            
        } catch let error as NSError {
            print("Failed to set: \(error.localizedDescription)")
        }
        
    }
}



/*
 
 json SUCCESS {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
 
 
 Native Helper class to detect Internet connection
 class Reachability {
 
 
 
 static func reachabilityForInternetConnection() ->  Bool {
 
 var zeroAddress = sockaddr_in()
 zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
 zeroAddress.sin_family = sa_family_t(AF_INET)
 
 guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
 SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
 }) else {
 return false
 }
 
 var flags : SCNetworkReachabilityFlags = []
 if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
 return false
 }
 
 let isReachable = flags.contains(.Reachable)
 let needsConnection = flags.contains(.ConnectionRequired)
 return (isReachable && !needsConnection)
 
 }
 }
 */


