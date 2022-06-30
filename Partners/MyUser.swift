//
//  MyUser.swift
//  Partners
//
//  Created by Maya on 25/06/2022.
//

import Foundation

class MyUser {
    var uuid:String
    var name:String
    var imgUrl:String
    var groups:[String]
    
    init(uuid:String, name:String){
        self.uuid = uuid
        self.name = name
        self.imgUrl = "https://firebasestorage.googleapis.com/v0/b/partners-df211.appspot.com/o/system%2Fdefault_Profile.png?alt=media&token=c6a92131-1978-49c0-a688-ef653e6309f4"
        self.groups = ["init"]
    }
    
}
