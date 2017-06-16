//
//  DVTLocationResolver.swift
//  DVT-Okiki
//
//  Created by Oyeleke Okiki on 15/06/2017.
//  Copyright © 2017 Oyeleke Okiki. All rights reserved.
//


import UIKit
import SwiftSpinner


func animateSetTextAppearance(text:String, label: UILabel){
    
    UIView.animate(withDuration: 0.5, delay: 0.4,
           options: [.repeat, .autoreverse, .curveEaseIn],
             animations: {
                    label.alpha = 1
                    label.text = text
                },
            completion: nil
            )
    
    
}

func animateSetTextMagnify(text:String, label: UILabel){
    
    
    
}

public func startLoader (message : String ){
    
    //Create a new message if there is no spinner or edit message in view
    
    if (SwiftSpinner.sharedInstance.animating == false){
        
        SwiftSpinner.show(message)
        
        return;
    }
    
    
    SwiftSpinner.sharedInstance.titleLabel.text = message
    
    
    
}

public func dismissLoader (){
    SwiftSpinner.hide()
}





