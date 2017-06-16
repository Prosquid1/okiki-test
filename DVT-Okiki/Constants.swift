//
//  Constants.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//

let APP_NAME = "DVT-Okiki"
let WEATHER_APP_ID = "c1df3a3f4318a9c56d0ce47de4711f11"

let MSG_GET_LOCATION_DATA = "Getting Location Details"
let MSG_FETCH_SERVER_DATA = "Fetching weather details"

let WIND_MEASUREMENT_UNIT = "m/s"


func getConstantTemp(temp : Double) -> String {

    //Openweather.rg is currently working with Kelvin (Temperature)
    //The only temperature that can logically go that high
    //The conversion for this also matched Lagos' temperature
    
    return String(Int(temp - 273.15)) + "°C"
    
}
