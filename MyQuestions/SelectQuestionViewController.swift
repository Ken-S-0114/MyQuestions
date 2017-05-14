//
//  SelectQuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class SelectQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var questionItem: Results<RealmDB>!
  var selectId: [Int] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
  }
  
  @IBOutlet weak var questionTableView: UITableView!
  
  @IBAction func decisionButton(_ sender: UIBarButtonItem) {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    appDelegate.selectId = selectId //appDelegateの変数を操作
    _ = navigationController?.popViewController(animated: true)
  }
  
  // セルが選択された時に呼び出される
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at:indexPath)
    let object = questionItem[indexPath.row]
    // チェックマークを入れる
    cell?.accessoryType = .checkmark
    // 配列に指定した問題ID格納
    selectId.append(contentsOf: [object.id])
  }
  
  // セルの選択が外れた時に呼び出される
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at:indexPath)
    let object = questionItem[indexPath.row]
    // チェックマークを外す
    cell?.accessoryType = .none
    // 配列から指定の問題ID削除
    selectId.remove(at: object.id)
  }
  
  // セルの数を返す
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let questionItem = questionItem {
      return questionItem.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let object = questionItem[indexPath.row]
    cell.textLabel?.text = object.category
    
    // セルが選択された時の背景色を消す
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
  }
  
}
