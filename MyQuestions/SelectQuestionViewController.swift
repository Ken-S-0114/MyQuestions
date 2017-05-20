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
  var selectedCells:[String:Bool]=[String:Bool]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    let cell = self.questionTableView.dequeueReusableCellWithIdentifier("selectCell") as! selectCell
//    let indexPath = self.questionTableView.indexPath(for: questionTableView)
//    let key = "\(indexPath.section)-\(indexPath.row)"
//    if let selected = selectedCells[key]{
//      cell.accessoryType=UITableViewCellAccessoryType.Checkmark
//    }else{
//      cell.accessoryType=UITableViewCellAccessoryType.None
//    }
//    
//    return cell
//  }
  
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
    selectId.append(object.id)
  }
  
  // セルの選択が外れた時に呼び出される
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at:indexPath)
    let object = questionItem[indexPath.row]
    // チェックマークを外す
    cell?.accessoryType = .none
    // 配列に指定した問題ID削除
    _ = selectId.remove(element: object.id)

  }
  
  // セルの数を返す
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let questionItem = questionItem {
      return questionItem.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath)
    let object = questionItem[indexPath.row]
    cell.textLabel?.text = object.category
    
    // セルが選択された時の背景色を消す
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    return cell
  }

}

// 削除する際に使用(選択したセルに格納されている値と一致する値のみ削除）
extension Array where Element: Equatable {
  mutating func remove(element: Element) -> Bool {
    guard let index = index(of: element) else { return false }
    remove(at: index)
    return true
  }
  
  mutating func remove(elements: [Element]) {
    for element in elements {
      _ = remove(element: element)
    }
  }
}
