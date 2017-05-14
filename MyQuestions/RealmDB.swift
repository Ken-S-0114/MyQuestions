//
//  RealmDB.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB: Object {
    
  dynamic var id = 0
  dynamic var title = String()
  dynamic var question = String()
  dynamic var answer = String()
  dynamic var category = String()
  dynamic var level = String()
  dynamic var date = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}
