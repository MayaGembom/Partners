//
//  Expence.swift
//  Partners
//
//  Created by Maya on 29/06/2022.
//

import Foundation

class Expence {
    var uuid:String
    var title:String
    var paidby:String
    var date:String
    var expence:Double
    
    init(uuid:String, title:String, paidby:String, date:String, expence:Double){
        self.uuid = uuid
        self.title = title
        self.paidby = paidby
        self.date = date
        self.expence = expence
    }
}
