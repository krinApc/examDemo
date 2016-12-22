//
//  ApiHandler.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import Foundation
import Alamofire

class ApiHandler {
    static var urlPath = "https://api.dribbble.com/v1/shots?access_token=4031b2cd344523f25e958fe811bccf648a7d58a62260722fe5e33c3a42d82a4f"
    
    class func fetchDribbble() -> DataRequest {
        return Alamofire.request(ApiHandler.urlPath).responseJSON { response in

        }
    }
}
