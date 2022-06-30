//
//  Group.swift
//  Partners
//
//  Created by Maya on 25/06/2022.
//

import Foundation


class Group {
    var uuid:String
    var name:String
    var expences:[String]
    var imgUrl:String
    
    init(uuid:String, name:String){
        self.uuid = uuid
        self.name = name
        self.expences = ["init"]
        self.imgUrl = "https://firebasestorage.googleapis.com/v0/b/superme-e69d5.appspot.com/o/images%2Fimg_profile_pic.JPG?alt=media&token=5970cec0-9663-4ddd-9395-ef2791ad938d"
    }
}
