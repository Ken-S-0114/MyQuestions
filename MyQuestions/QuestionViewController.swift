//
//  QuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionViewController: UIViewController {

  
  var questionItem: Results<RealmDB>!
  var selectId: [Int] = []
  var selectAnswer: String?
  var answerCount: Int = 0
  var limitCount: Int = 1
  var correct: Int = 0
  var wrong: Int = 0
  
  var i: Int = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    selectId = appDelegate.selectId
    limitCount = appDelegate.limit
    
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    // 選択されたIDからRealmDBに保存してあるデータを表示

    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectId[i] as AnyObject)
    categoryLabel.text? = (selectRealmDB?.category)!
    titleLabel.text? = (selectRealmDB?.title)!
    questionLabel.text? = (selectRealmDB?.question)!
    levelLabel.text? = ("難易度: \((selectRealmDB?.level)!)")
    // 答えの欄を初期化
    answerTextField.text = ""
    // Realmに格納してある特定の答え
    selectAnswer = (selectRealmDB?.answer)!
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if(answerTextField.isFirstResponder) {
      answerTextField.resignFirstResponder()
    }
  }
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabelView: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabelView: UILabel!
  @IBOutlet weak var answerTextField: UITextField!
  @IBOutlet weak var levelLabel: UILabel!

  @IBAction func nextQuestionButton(_ sender: Any) {
    if (i < selectId.count) {
      viewDidLoad()
    }else {
      let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
      appDelegate.correct = correct
      appDelegate.wrong = wrong
      performSegue(withIdentifier: "resultSegue", sender: nil)
    }

  }
  
  // 答え合わせ
  @IBAction func checkButton(_ sender: Any) {
    // 答えが入力されているか確認
    if (answerTextField.text != "") {
      // 正解
      if (answerTextField.text == selectAnswer!) {
        let alertController = UIAlertController(title: "正解", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        correct += 1
        present(alertController, animated: true, completion: nil)
      }
      // 答えが間違っている場合
      else if (answerTextField.text != selectAnswer!) {
        // 設定した回数以内か確認
        if (answerCount < limitCount) {
          let alertController = UIAlertController(title: "不正解", message: "残りあと\((limitCount-1)-answerCount)回", preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
          alertController.addAction(alertAction)
          present(alertController, animated: true, completion: nil)
          answerCount += 1
        }else {
          let alertController = UIAlertController(title: "不正解\n答え：\(selectAnswer!)", message: nil, preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "確認", style: .default, handler: nil)
          alertController.addAction(alertAction)
          wrong += 1
          present(alertController, animated: true, completion: nil)
        }
      }
    // 答えが未入力
    else {
      let alertController = UIAlertController(title: "答えが入力されていません", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      }
    }
    // 次のIdへ
    i += 1
    print(i)
    print(selectId.count)
  }
  
  
}
