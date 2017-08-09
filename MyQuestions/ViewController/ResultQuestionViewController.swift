//
//  ResultQuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/30.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class ResultQuestionViewController: UIViewController {
  
  var questionItem: Results<RealmDB>!
  // TableViewで選択されたデータのID
  var selectTableId = Int()
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    
    // 選択された問題番号
    selectTableId = appDelegate.selectTableId
    
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectTableId as AnyObject)
    categoryLabel.text = selectRealmDB?.category
    titleLabel.text = selectRealmDB?.title
    questionLabel.text = selectRealmDB?.question
    answerLabel.text = selectRealmDB?.answer
    levelLabel.text = selectRealmDB?.level
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabelView: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabelView: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var levelLabelView: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  
}
