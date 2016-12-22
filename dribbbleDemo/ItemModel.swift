//
//  ItemModel.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/22.
//  Copyright © 2016年 rin. All rights reserved.
//

import Foundation
import RealmSwift

class ItemModel: Object {
    dynamic var normal: String? = nil
    dynamic var title: String? = nil
    dynamic var avatar_url: String? = nil
    dynamic var name: String? = nil
    dynamic var html_url: String? = nil
    dynamic var read_date: NSDate? = nil
}
