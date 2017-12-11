//
//  TopViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/08/08.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  var questionItem: Results<RealmDB>!
  var categoryItem: Results<CategoryDB>!
  var selectCategory = String()
  var categoryString: [String?] = []  // Pickerに格納されている文字列
  var count: Int = 0                  // CategoryDBに保存してあるデータ数
  var i: Int = 0                      // 比較する変数
  var check: Bool = true              // 同じジャンル名があるかチェックする変数
  
  @IBOutlet weak var searchTextBar: UISearchBar!
  @IBOutlet weak var categoryTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let realm = try! Realm()
    categoryItem = realm.objects(CategoryDB.self).sorted(byKeyPath: "id", ascending: true)
    
    count = categoryItem.count
    // CategoryDBに保存してある値を配列に格納
    while count>i {
      let object = categoryItem[i]
      categoryString += [object.name]
      i += 1
    }
    // 比較する変数の初期化
    i = 0
    
    //    // 入力されていなくてもDoneキーが押せる
    //    searchTextBar.enablesReturnKeyAutomatically = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let realm = try! Realm()
    categoryItem = realm.objects(CategoryDB.self).sorted(byKeyPath: "id", ascending: true)

    // 変更後の数
    let recount: Int = categoryItem.count
    // 変更前の数と比べる
    if recount != count {
      // 配列の中身を初期化
      categoryString = []
      // CategoryDBに保存してある値を配列にあるだけ再度格納
      while recount > i {
        let object = categoryItem[i]
        categoryString += [object.name]
        i += 1
      }
      // 比較する変数の初期化
      i = 0
      count = recount
      
      categoryTableView.reloadData()
    }
    
    if let indexPathForSelectedRow = categoryTableView.indexPathForSelectedRow {
      categoryTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
    }
    
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let categoryItem = categoryItem {
      return categoryItem.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
    let realm = try! Realm()
    let categoryCount = realm.objects(RealmDB.self).filter("category CONTAINS %@", categoryString[indexPath.row] as Any)
    cell?.textLabel?.text = categoryString[indexPath.row]
    cell?.detailTextLabel?.text = ("\(String(categoryCount.count))件")
    return cell!
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
    selectCategory = categoryString[indexPath.row]!
    performSegue(withIdentifier: "categorySegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "categorySegue" {
      appDelegate.selectCategory = selectCategory
    }
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let searchText: String
    // 文字が削除されたとき
    if text.isEmpty {
      // 末尾の1文字を削除した文字を検索ワードとする
      // 制限事項：カーソルを移動して末尾でない文字を削除した場合でも末尾を削除した文字で検索を行う
      let searchBarText = searchBar.text!
      let index = searchBarText.endIndex
      searchText = searchBarText.substring(to: index)
      //let index = searchBarText.endIndex.advanced(by: -1)
      //searchText = searchBarText.substringToIndex(index)
    }
      // 文字入力されたとき
    else {
      // 制限事項：文字変換したときに変換前の文字と変換後の文字を結合した文字で検索してしまう
      // 例："あい"を"愛"に変換したときsearchTextは"あい愛"となる
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
    categoryTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if searchBar.text == "" {
      questionItem = try! Realm().objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
      categoryTableView.reloadData()
    }
    searchTextBar.endEditing(true)
  }
  
}
