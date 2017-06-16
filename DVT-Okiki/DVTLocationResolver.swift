//
//  DVTLocationResolver.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//




import MapKit


/*
 Resolve Location , return co-ordinates, city and country name
 */

class DVTLocationResolver {
    
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var locationDetails = [String: Any]()
    
    
    func getAdress(completion: @escaping (Typealiases.JSONDict) -> ()) {
        
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                
                var locationDetails = [String: Any]()
                
                if error != nil {
                    print("Error getting location: \(error)")
                } else {
                    let placeArray = placemarks as [CLPlacemark]!
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    
                    //Key - City , Value: AddressDictionary
                    locationDetails.update(placeMark.addressDictionary as! Dictionary<String, Any>)
                    
                    //Passing the Longitude and Latitude to avoid importing MapKit in the ViewController
                    //CLLocationDegrees are a typealias of Double, so no need to cast
                    
                    
                    locationDetails.update(["Longitude" : self.currentLocation.coordinate.longitude])
                    locationDetails.update(["Latitude" : self.currentLocation.coordinate.latitude])
                    
                    completion(locationDetails)
                }
            }
        }
    }
}





