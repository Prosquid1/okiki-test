//
//  ViewController.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//

//Weather UI Inspiration from: https://dribbble.com/shots/3483265-Weather-App

import UIKit
import Alamofire


class ViewController: UIViewController {

    var openWeatherResponse : OpenWeatherReponse!
    
    @IBOutlet weak var locationLabel : UILabel!
    
    @IBOutlet weak var dateLabel : UILabel!
    
    @IBOutlet weak var temperatureImageView : UIImageView!
    
    @IBOutlet weak var temperatureLabel : UILabel!
    
    @IBOutlet weak var temperatureMinLabel : UILabel!
    @IBOutlet weak var temperatureMaxLabel : UILabel!
    
    @IBOutlet weak var weatherTypeLabel : UILabel!
    
    
    @IBOutlet weak var windSpeedLabel : UILabel!
    
    @IBOutlet weak var sunPositionHeaderLabel : UILabel!
    
    @IBOutlet weak var sunPositionValueLabel : UILabel!
    
    @IBOutlet weak var humidityValueLabel : UILabel!
    
    
    var locationString : String = ""
    
    
    let locationWithAddress = DVTLocationResolver();
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
    
        super.viewDidLayoutSubviews()
        
        startLoader(message: MSG_GET_LOCATION_DATA)
        
        locationWithAddress.getAdress { result in
            
            if let city = result["Street"] as? String {
                
                self.locationString = city
                
            } 
            
            if let country = result["Country"] as? String {
                
                if (self.locationString.isEmpty){
                    
                    self.locationString = country
                    
                } else {
                
                    self.locationString.joinNonEmptyString(country)
                }
                
               
                
            }
            
            
            if let longitude = result["Longitude"] as? Double {
                
                //Ideally Latitude cannot come without Longitude
                
                if let latitude = result["Latitude"] as? Double {
                    
                    self.getWeatherFromServer(latitude: latitude, longitude: longitude)
                    
                } else {
                
                    print ("No LATITUDE")
                    
                }
                
                
            } else {

                dismissLoader()
                
                print ("No longitude")
                
            }
            
            
        }
        
    }

    
    
    
    
    func getWeatherFromServer(latitude : Double, longitude : Double){
        
        let weatherUrl = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=" + WEATHER_APP_ID
       
        
        //let weatherUrl = "http://samples.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=" + "b1b15e88fa797225412429c1c50c122a1"
        
        
        //Show Spinner
        startLoader(message: MSG_FETCH_SERVER_DATA)

        
        //print("weatherUrl: " + weatherUrl)
        
        Alamofire.request(weatherUrl).validate().responseString { response in
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("json SUCCESS \(JSON)" )
                    
                    self.openWeatherResponse = OpenWeatherReponse(JSONString:JSON )
                    
                    self.initializeViewsOnLoad()
                    
                    print ("weatherResponse ::  \(self.openWeatherResponse.weather.weatherDescription)" )
                    
                case .failure(let error):
                    
                    dismissLoader()
                    
                    print("json FAILURE \(error)" )
                    DVTHelper().showAlert(message: "Error 4xx / 5xx: \(error)", viewController: self)
                    
                }
        }
        
    }
    
    
    /*
     Initialize all view components and fill with data
     */
    
    func initializeViewsOnLoad(){
    
        dismissLoader()
        
        let icon = openWeatherResponse.weather.weatherDescriptionIcon
        
        if  (!icon.isEmpty) {
            
            let iconUrl = "http://openweathermap.org/img/w/\(icon).png"
            
            
            if let checkedUrl = URL(string: iconUrl) {
                temperatureImageView.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl, imageView: temperatureImageView)
            }
        }
    
        
        
        locationLabel.text = locationString
        
        dateLabel.text = getFormattedDayTime()
        
        
        weatherTypeLabel.text = openWeatherResponse.weather.weatherDescription.capitalized
        
        
        let hour = getHour()
        
        var sunPositionTime = "";
        
        if ( hour >= 6 && hour <= 18 ){
            
            sunPositionHeaderLabel.text = "SUNSET"
            
            
        } else {
        
            sunPositionHeaderLabel.text = "SUNRISE"
            
        }
        
        sunPositionTime = getHourMinutesFromTimeStamp( unixTimestamp: openWeatherResponse.sys.sunsetTimeSeconds)
        
        sunPositionValueLabel.text = sunPositionTime
        
        
        let windSpeed = openWeatherResponse.wind.speed
        
        windSpeedLabel.text = ("\(windSpeed)" + WIND_MEASUREMENT_UNIT)
        
        
        temperatureLabel.text = getConstantTemp(temp: openWeatherResponse.main.temp)
        
        temperatureMinLabel.text = getConstantTemp(temp: openWeatherResponse.main.temp_min)
        
        temperatureMaxLabel.text = getConstantTemp(temp: openWeatherResponse.main.temp_max)
        
        
        animateSetTextAppearance( text: String(openWeatherResponse.main.humidity), label : humidityValueLabel )
        
        //humidityValueLabel.text = String(openWeatherResponse.main.humidity)
        
        
    
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
        
        // Dispose of any resources that can be recreated.
    }


}

