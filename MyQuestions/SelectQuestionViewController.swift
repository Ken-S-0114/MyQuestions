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
  var selectId: [Int] = []  // 選択された問題番号
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectId = appDelegate.selectId
//    print(selectId.count)
//    print(selectId)
//    print(questionItem)
    questionTableView.reloadData()
  }
  
  
  @IBOutlet weak var questionTableView: UITableView!
  
  @IBAction func decisionButton(_ sender: UIBarButtonItem) {
    appDelegate.selectId = selectId //appDelegateの変数を操作
    _ = navigationController?.popViewController(animated: true)
  }
  
  // セルが選択された時に呼び出される
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at:indexPath)
    let object = questionItem[indexPath.row]
    if  cell?.accessoryType != .checkmark {
      // チェックマークを入れる
      cell?.accessoryType = .checkmark
      // 配列に指定した問題ID格納
      selectId.append(object.id)
    }else {
      // チェックマークを外す
      cell?.accessoryType = .none
      // 配列に指定した問題ID削除
      _ = selectId.remove(element: object.id)
    }
    
  }
  
  // セルの選択が外れた時に呼び出される
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at:indexPath)
    let object = questionItem[indexPath.row]
    if  cell?.accessoryType == .checkmark {
      // チェックマークを外す
      cell?.accessoryType = .none
      // 配列に指定した問題ID削除
      _ = selectId.remove(element: object.id)
    }else {
      // チェックマークを入れる
      cell?.accessoryType = .checkmark
      // 配列に指定した問題ID格納
      selectId.append(object.id)
    }
    
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
    cell.textLabel?.text = object.title
    
    // セルが選択された時の背景色を消す
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    
    // 選択済みの問題にはチェックマークを初期値としてつける
    for _ in 0..<questionItem.count{
      for i in 0..<selectId.count {
        if (indexPath.row == selectId[i]){
          cell.accessoryType = .checkmark
        }
      }
    }
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
