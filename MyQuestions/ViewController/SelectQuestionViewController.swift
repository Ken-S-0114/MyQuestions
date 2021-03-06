//
//  SelectQuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class SelectQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  var questionItem: Results<RealmDB>!
  var selectId: [Int] = []  // 選択された問題番号
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
    // 入力されていなくてもDoneキーが押せる
    searchTextBar.enablesReturnKeyAutomatically = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectId = appDelegate.selectId
    questionTableView.reloadData()
  }
  
  @IBOutlet weak var searchTextBar: UISearchBar!
  @IBOutlet weak var questionTableView: UITableView!
  
  @IBAction func decisionButton(_ sender: UIBarButtonItem) {
    appDelegate.selectId = selectId //appDelegateの変数を操作
    _ = navigationController?.popViewController(animated: true)
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let searchText: String
    if text.isEmpty {
      // 文字が削除されたとき
      // 末尾の1文字を削除した文字を検索ワードとします
      // 制限事項：カーソルを移動して末尾でない文字を削除した場合でも末尾を削除した文字で検索を行います
      let searchBarText = searchBar.text!
      let index = searchBarText.endIndex
      searchText = searchBarText.substring(to: index)
      //let index = searchBarText.endIndex.advanced(by: -1)
      //searchText = searchBarText.substringToIndex(index)
    } else {
      // 文字入力されたとき
      // 制限事項：文字変換したときに変換前の文字と変換後の文字を結合した文字で検索してしまう
      // 例："あい"を"愛"に変換したときsearchTextは"あい愛"になります
      // 変換後にfunc searchBar(..., textDidChange ...)が呼ばれるため、このタイミングでsearchを行ってしまうが、すぐに後追いでtextDidChangeのsearchを実行することで回避
      let searchBarText = NSMutableString(string: searchBar.text!)
      searchBarText.insert(text, at: range.location)
      searchText = searchBarText as String
    }
    search(text: searchText)
    return true
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    search(text: searchBar.text!)
  }
  
  func search(text: String){
    questionItem = try! Realm().objects(RealmDB.self).filter("title CONTAINS %@ OR answer CONTAINS %@ OR category CONTAINS %@", text, text, text)
    questionTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text == "" {
      questionItem = try! Realm().objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
      questionTableView.reloadData()
    }
    searchTextBar.endEditing(true)
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
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath) as! SelectCell
    let object = questionItem[indexPath.row]
    var correctMark: Float = 0.0
    var wrongMark: Float = 0.0
    var rate: Float = 0.0
    
    correctMark = Float(object.correctMark)
    wrongMark = Float(object.wrongMark)
    
    // nan表示にさせないための処理
    if object.correctMark == 0 {
      rate = 0.0
    }else{
      // 正答率を算出
      rate = ((correctMark / (correctMark + wrongMark)) * 100)
    }
    // 小数第１位までを表示
    let CGrate: CGFloat = CGFloat(rate)
    let CGRate = String(format: "%.01f", Float(CGrate))
    
    cell.setCell(category: String(object.category), rate: "正答率:\(CGRate)%", title: String(object.title))
    
    // セルが選択された時の背景色を消す
    cell.selectionStyle = UITableViewCellSelectionStyle.none
    
    // 選択済みの問題にはチェックマークを初期値としてつける
    if selectId != [] {
      for _ in 0..<questionItem.count{
        for i in 0..<selectId.count {
          if indexPath.row == selectId[i] {
            cell.accessoryType = .checkmark
          }
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
