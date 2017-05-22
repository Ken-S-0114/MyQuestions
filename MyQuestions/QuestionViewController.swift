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
  var selectId: [Int] = []    // 選択された問題(Id)
  var selectAnswer: String?   // 問題の答え
  var answerCount: Int = 0    // 回答回数
  var limitCount: Int = 1     // 回答回数上限
  var correct: Int = 0        // appDelegate用正解数
  var wrong: Int = 0          // appDelegate用不正解数
  var mark: [String] = []     // appDelegate用○×マーク
  var correctmark: Int = 0    // RealmDB用正解数
  var wrongmark: Int = 0      // RealmDB用不正解数
  var i: Int = 0              // 問題数と比較する変数
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    selectId = appDelegate.selectId
    limitCount = appDelegate.limit
    
    let realm = try! Realm()
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectId[i] as AnyObject)
    //categoryLabel.text? = (selectRealmDB?.category)!
    titleLabel.text = (selectRealmDB?.title)!
    questionLabel.text = (selectRealmDB?.question)!
    levelLabel.text = (selectRealmDB?.level)!
    correctmark = (selectRealmDB?.correctmark)!
    wrongmark = (selectRealmDB?.wrongmark)!
    
    // 答えの欄を初期化
    answerTextField.text = ""
    // Realmに格納してある特定の答え
    selectAnswer = (selectRealmDB?.answer)!
    
    checkButtonView.isEnabled = true
    nextQuestionButtonView.isEnabled = false
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
  @IBOutlet weak var levelLabelView: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var nextQuestionButtonView: UIBarButtonItem!
  @IBOutlet weak var checkButtonView: UIButton!

  @IBAction func nextQuestionButton(_ sender: Any) {
    if (i < selectId.count) {
      // 画面の再表示
      viewDidLoad()
    }else {
      //AppDelegateのインスタンスを取得
      let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.correct = correct
      appDelegate.wrong = wrong
      appDelegate.mark = mark
      performSegue(withIdentifier: "resultSegue", sender: nil)
    }

  }
  
  // 答え合わせ
  @IBAction func checkButton(_ sender: Any) {
    let resultRealmDB = RealmDB()
    resultRealmDB.title = (titleLabel.text)!
    resultRealmDB.question = (questionLabel.text)!
    resultRealmDB.answer = selectAnswer!
    resultRealmDB.level = (levelLabel.text)!
    
       // 答えが入力されているか確認
    if (answerTextField.text != "") {
      // 正解の場合
      if (answerTextField.text == selectAnswer!) {
        let alertController = UIAlertController(title: "正解", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        correct += 1
        mark += ["○"];
        present(alertController, animated: true, completion: nil)
        
        // resultRealmDBに結果を蓄積
        resultRealmDB.id = selectId[i]
        resultRealmDB.correctmark = correctmark + 1
        resultRealmDB.wrongmark = wrongmark
        
        // ボタンの表示を操作
        checkButtonView.isEnabled = false
        nextQuestionButtonView.isEnabled = true
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
          mark += ["×"];
          present(alertController, animated: true, completion: nil)
          
          // resultRealmDBに結果を蓄積
          resultRealmDB.id = selectId[i]
          resultRealmDB.wrongmark = wrongmark + 1
          resultRealmDB.correctmark = correctmark
          
          // ボタンの表示を操作
          checkButtonView.isEnabled = false
          nextQuestionButtonView.isEnabled = true
        }
      }
    // 答えが未入力の場合
    else {
      let alertController = UIAlertController(title: "答えが入力されていません", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
    }
    // 上記で代入したテキストデータを永続化
    let realm = try! Realm()
    try! realm.write({ () -> Void in
      realm.add(resultRealmDB, update: true)
    })

  }
    // 次の問題準備
    i += 1
  }
  
  
}
