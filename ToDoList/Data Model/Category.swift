//
//  Category.swift
//  ToDoList
//
//  Created by 黎光宸 on 2019/2/14.
//  Copyright © 2019年 黎光宸. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String=""
    let items = List<item>()
}
