//
//  item.swift
//  ToDoList
//
//  Created by 黎光宸 on 2019/2/14.
//  Copyright © 2019年 黎光宸. All rights reserved.
//

import Foundation
import RealmSwift

class item: Object {
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
