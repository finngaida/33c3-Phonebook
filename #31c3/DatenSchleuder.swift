//
//  DatenSchleuder.swift
//  #31c3
//
//  Created by Finn Gaida on 27.12.15.
//  Copyright © 2015 Finn Gaida. All rights reserved.
//

import Foundation

class DatenSchleuder: NSObject {

    class func phonebook() throws -> [Number] {
        
        do {
            let data = try NSData(contentsOfURL: NSURL(string: "https://eventphone.de/guru2/phonebook?event=32C3&s=&page=1&format=json")!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [Dictionary<String, String>]
            let res = json?.map({ (number) -> Number in
                return Number(xtension: number["extension"]!, name: number["name"]!, type: PhoneType.Default, location: number["location"]!)
            })
            
            return res!
            
        } catch {
            throw error
        }
        
    }
    
}

enum PhoneType {
    case Default
}

struct Number {
    let xtension: String
    let name: String
    let type: PhoneType
    let location: String
}
