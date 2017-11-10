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
    
  @objc dynamic var id: Int = 0
  @objc dynamic var title: String = ""
  @objc dynamic var question: String = ""
  @objc dynamic var answer: String = ""
  @objc dynamic var category: String = ""
  @objc dynamic var level: String = ""
  @objc dynamic var correctMark: Int = 0
  @objc dynamic var wrongMark: Int = 0
  @objc dynamic var date = NSDate()

//  convenience init(name: String) {
//    self.init()
//    self.title = title
//    self.question = question
//    self.answer = answer
//    self.category = category
//    self.level = level
//    self.correctMark = correctMark
//    self.wrongMark = wrongMark
//    self.date = date
//  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}
