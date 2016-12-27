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
            let data = try Data(contentsOf: URL(string: "https://eventphone.de/guru2/phonebook?event=33C3&s=&page=1&format=json")!, options: NSData.ReadingOptions.mappedIfSafe)
            
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Dictionary<String, String>]
            let res = json?.map({ (number) -> Number in
                return Number(xtension: number["extension"]!, name: number["name"]!, type: PhoneType.default, location: number["location"]!)
            })
            
            return res!
            
        } catch {
            throw error
        }
        
    }
    
}

enum PhoneType {
    case `default`
}

struct Number {
    let xtension: String
    let name: String
    let type: PhoneType
    let location: String
}
