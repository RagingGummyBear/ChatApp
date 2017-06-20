//
//  ChatModel.swift
//  ChatApp
//
//  Created by Viktorija Anchevska on 10/13/16.
//  Copyright © 2016 Viktorija Anchevska. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    
    var username: String!
    var message: String!
    
    init(dict: Dictionary<String, String>){
        username = dict["username"]
        message = dict["message"]
    }
    init(displayName : String, message :String ){
        username = displayName;
        self.message = message;
    }

}
