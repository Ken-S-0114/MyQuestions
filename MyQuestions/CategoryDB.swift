//
//  CategoryDB.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/21.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryDB: Object {
    
    dynamic var id: Int = 0
    dynamic var name: String = ""
   // dynamic var color: String = ""
    
    override static func primaryKey() -> String? {
      return "id"
    }
}
