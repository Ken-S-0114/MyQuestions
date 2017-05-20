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
    
  dynamic var id: Int = 0
  dynamic var title: String = ""
  dynamic var question: String = ""
  dynamic var answer: String = ""
  dynamic var category: String = ""
//  let categorylist = List<CategoryList>()
  dynamic var level: String = ""
  dynamic var correctmark: Int = 0
  dynamic var wrongmark: Int = 0
  dynamic var date = NSDate()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}

class CategoryList: Object {
  dynamic var id: Int = 0
  dynamic var categoryname: String = ""
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
