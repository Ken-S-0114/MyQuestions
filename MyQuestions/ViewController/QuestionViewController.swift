//
//  QuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class QuestionViewController: UIViewController, UITextFieldDelegate {
  
  var questionItem: Results<RealmDB>!
  var selectId: [Int] = []    // 選択された問題(Id)
  var selectAnswer: String?   // 問題の答え
  var answerCount: Int = 1    // 回答回数
  var limitCount: Int = 1     // 回答回数上限
  var correct: Int = 0        // appDelegate用正解数
  var wrong: Int = 0          // appDelegate用不正解数
  var mark: [String] = []     // appDelegate用○×マーク
  var correctMark: Int = 0    // RealmDB用正解数
  var wrongMark: Int = 0      // RealmDB用不正解数
  var i: Int = 0              // 配列から指定の問題を取り出す変数
  var selectCount: Int = 1    // 問題番号表示用
  var rateCheck = Bool()
  
  let settingKey = "value"
  let setting = UserDefaults.standard
  
  // 再生する audio ファイルのパスを取得
  // 正解時
  let correctPath = Bundle.main.bundleURL.appendingPathComponent("Quiz-Correct_Answer01-1.mp3")
  var correctPlayer = AVAudioPlayer()
  // 不正解時（まだチャンスあり）
  let wrong2Path = Bundle.main.bundleURL.appendingPathComponent("Quiz-Wrong_Buzzer02-2.mp3")
  var wrong2Player = AVAudioPlayer()
  // 不正解時
  let wrongPath = Bundle.main.bundleURL.appendingPathComponent("Quiz-Wrong_Buzzer02-3.mp3")
  var wrongPlayer = AVAudioPlayer()
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    limitCount = setting.integer(forKey: settingKey)
    selectId = appDelegate.selectId
    
    let realm = try! Realm()
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectId[i] as AnyObject)
    if let selectRealmDB = selectRealmDB {
      categoryLabel.text = selectRealmDB.category
      titleLabel.text = selectRealmDB.title
      questionLabel.text = selectRealmDB.question
      levelLabel.text = selectRealmDB.level
      correctMark = selectRealmDB.correctMark
      wrongMark = selectRealmDB.wrongMark
      // Realmに格納してある特定の答え
      selectAnswer = selectRealmDB.answer
    }
    // 答えの欄を初期化
    answerTextField.text = ""
    
    // 決定ボタン表示
    checkButtonView.isEnabled = true
    // 次の問題ボタン非表示
    nextQuestionButtonView.isEnabled = false
    // 現在の問題数表示
    selectCount = appDelegate.selectCount
    self.navigationItem.title = String("第\(selectCount)/\(selectId.count)問")
    // 戻るボタン非表示
    self.navigationItem.hidesBackButton = true
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if answerTextField.isFirstResponder {
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
  
  
  @IBAction func breakButton(_ sender: Any) {
    _ = navigationController?.popToRootViewController(animated: true)
  }
  @IBAction func nextQuestionButton(_ sender: Any) {
    if i < selectId.count {
      answerCount = 1    // 回答回数
      //      correctPlayer.stop()
      //      wrong2Player.stop()
      //      wrongPlayer.stop()
      // 画面の再表示
      viewDidLoad()
    }else {
      selectCount = 1
      appDelegate.correct = correct
      appDelegate.wrong = wrong
      appDelegate.mark = mark
      performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
  }
  
  // 答え合わせ
  @IBAction func checkButton(_ sender: Any) {
    rateCheck = appDelegate.rateCheck
    
    // 答えが入力されているか確認
    if answerTextField.text != "" {
      // 正解の場合
      if answerTextField.text == selectAnswer! {
        // 正解BGM
        soundPlayer(&correctPlayer, path: correctPath, count: 0)
        let alertController = UIAlertController(title: "正解", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        correct += 1
        mark += ["○"];
        //　iPad用クラッシュさせないために
        alertController.popoverPresentationController?.sourceView = self.view;
        alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
        
        present(alertController, animated: true, completion: nil)
        
        if rateCheck {
          // resultRealmDBに結果を蓄積
          let resultRealmDB = RealmDB()
          resultRealmDB.id = selectId[i]
          resultRealmDB.category = (categoryLabel.text)!
          resultRealmDB.title = (titleLabel.text)!
          resultRealmDB.question = (questionLabel.text)!
          resultRealmDB.answer = selectAnswer!
          resultRealmDB.level = (levelLabel.text)!
          
          resultRealmDB.correctMark = correctMark + 1
          resultRealmDB.wrongMark = wrongMark
          
          // 上記で代入したテキストデータを永続化
          let realm = try! Realm()
          try! realm.write({ () -> Void in
            realm.add(resultRealmDB, update: true)
          })
          
        }
        // 次の問題準備
        selectCount += 1
        i += 1
        appDelegate.selectCount = selectCount
        
        // ボタンの表示を操作
        checkButtonView.isEnabled = false
        nextQuestionButtonView.isEnabled = true
      }
        // 答えが間違っている場合
      else if answerTextField.text != selectAnswer! {
        // 設定した回数以内か確認
        if answerCount < limitCount {
          // 不正解BGM
          soundPlayer(&wrong2Player, path: wrong2Path, count: 0)
          let alertController = UIAlertController(title: "不正解", message: "残りあと\((limitCount)-answerCount)回", preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
          alertController.addAction(alertAction)
          
          //　iPad用クラッシュさせないために
          alertController.popoverPresentationController?.sourceView = self.view;
          alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
          
          present(alertController, animated: true, completion: nil)
          answerCount += 1
          
        }else {
          // 不正解BGM
          soundPlayer(&wrongPlayer, path: wrongPath, count: 0)
          let alertController = UIAlertController(title: "不正解\n答え：\(selectAnswer!)", message: nil, preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "確認", style: .default, handler: nil)
          alertController.addAction(alertAction)
          wrong += 1
          mark += ["×"];
          
          //　iPad用クラッシュさせないために
          alertController.popoverPresentationController?.sourceView = self.view;
          alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
          
          present(alertController, animated: true, completion: nil)
          
          if rateCheck {
            // resultRealmDBに結果を蓄積
            let resultRealmDB = RealmDB()
            resultRealmDB.id = selectId[i]
            
            resultRealmDB.category = (categoryLabel.text)!
            resultRealmDB.title = (titleLabel.text)!
            resultRealmDB.question = (questionLabel.text)!
            resultRealmDB.answer = selectAnswer!
            resultRealmDB.level = (levelLabel.text)!
            
            resultRealmDB.wrongMark = wrongMark + 1
            resultRealmDB.correctMark = correctMark
            
            // 上記で代入したテキストデータを永続化
            let realm = try! Realm()
            try! realm.write({ () -> Void in
              realm.add(resultRealmDB, update: true)
            })
            
          }
          // 次の問題準備
          selectCount += 1
          i += 1
          appDelegate.selectCount = selectCount
          
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
        
        //　iPad用クラッシュさせないために
        alertController.popoverPresentationController?.sourceView = self.view;
        alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
        
        present(alertController, animated: true, completion: nil)
      }
    }
  }
  
  // Doneボタンを押した際キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  fileprivate func soundPlayer(_ player:inout AVAudioPlayer, path: URL, count: Int) {
    do {
      player = try AVAudioPlayer(contentsOf: path, fileTypeHint: nil)
      player.numberOfLoops = count
      player.play()
    } catch {
      print("エラーが発生しました！")
    }
  }
  
}
