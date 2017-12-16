//
//  resultViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/17.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var selectId: [Int] = []    // 選択された問題番号(Id)
  var correct: Float = 0.00   // 正解数
  var wrong: Float = 0.00     // 不正解数
  var rate: Float = 0.0       // 正答率
  var mark: [String] = []     // ○×マーク
  var i: Int = 0              // 選択された問題を格納した配列の順番を指定
  var l: Int = 1              // 問題番号
  
  var questionItem: Results<RealmDB>!
  var selectTableId = Int()    // 選択された問題番号
  
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 代入
    selectId = appDelegate.selectId
    correct = Float(appDelegate.correct)
    wrong = Float(appDelegate.wrong)
    mark = appDelegate.mark
    
    // 正答率を算出
    rate = ((correct / (correct + wrong)) * 100)
    
    // 小数第１位までを表示
    let CGrate: CGFloat = CGFloat(rate)
    let CGRate = String(format: "%.01f", Float(CGrate))
    
    correctLabel.text = String("\(CGRate)%")
    correctproportionView.text = ("\(Int(correct+wrong))問中\(Int(correct))問正解しました")
    
    /* appDelegate 初期化 */
    appDelegate.correct = 0
    appDelegate.wrong = 0
    appDelegate.selectCount = 1
    appDelegate.mark = []
    
    // 戻るボタン非表示
    self.navigationItem.hidesBackButton = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBOutlet weak var correctLabelView: UILabel!
  @IBOutlet weak var correctLabel: UILabel!
  @IBOutlet weak var correctproportionView: UILabel!
  @IBOutlet weak var resultTableView: UITableView!
  
  @IBAction func resultButton(_ sender: Any) {
    _ = navigationController?.popToRootViewController(animated: true)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectId.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // cellの表示方法をResultCellクラスで定義した表式にする
    let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
    
    let realm = try! Realm()
    // 選択されたIdからRealmDBに保存してあるデータを表示
    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectId[i] as AnyObject)
    
    if let selectRealmDB = selectRealmDB {
      cell.setCell(number: "第\(String(l))問", title: String(selectRealmDB.title), mark: String(mark[indexPath.row]))
    }
    if selectId.count > l {
      l += 1    
      i += 1
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if UIDevice.current.userInterfaceIdiom == .phone {
      // 使用デバイスがiPhoneの場合
      return 40
    } else if UIDevice.current.userInterfaceIdiom == .pad {
      // 使用デバイスがiPadの場合
      return 70
    } else {
      return 60
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    let selectObject = questionItem[selectId[indexPath.row]]
    selectTableId = selectObject.id
    performSegue(withIdentifier: "resultQuestionSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "resultQuestionSegue" {
      appDelegate.selectTableId = selectTableId
    }
  }
}




