//
//  FirstViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
  
  var questionItem: Results<RealmDB>!
  var selectCategory = String()
  var selectTableId : Int = 0    // 選択された問題番号
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // 入力されていなくてもDoneキーが押せる
    searchTextBar.enablesReturnKeyAutomatically = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    selectCategory = appDelegate.selectCategory
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).filter("category CONTAINS %@", selectCategory)
    questionTableView.reloadData()
    navigationItem.title = selectCategory
  }
  
  @IBOutlet weak var searchTextBar: UISearchBar!
  @IBOutlet weak var questionTableView: UITableView!
  
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
    questionItem = try! Realm().objects(RealmDB.self).filter("title CONTAINS %@ OR answer CONTAINS %@", text, text)
    questionTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if (searchBar.text == ""){
      questionItem = try! Realm().objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)
      questionTableView.reloadData()
    }
    searchTextBar.endEditing(true)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let questionItem = questionItem {
      return questionItem.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")
    let object = questionItem[indexPath.row]
    var correctMark: Float = 0.0
    var wrongMark: Float = 0.0
    var rate: Float = 0.0
    
    correctMark = Float(object.correctMark)
    wrongMark = Float(object.wrongMark)
    
    // nan表示にさせないための処理
    if (object.correctMark == 0){
      rate = 0.0
    }else{
      // 正答率を算出
      rate = ((correctMark / (correctMark + wrongMark)) * 100)
    }
    // 小数第１位までを表示
    let CGrate: CGFloat = CGFloat(rate)
    let CGRate = String(format: "%.01f", Float(CGrate))
    
    cell?.textLabel?.text = object.title
    cell?.detailTextLabel?.text = "正答率:\(CGRate)%"
    
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
    let selectObject = questionItem[indexPath.row]
    selectTableId = selectObject.id
    performSegue(withIdentifier: "questionSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "questionSegue" {
      appDelegate.selectTableId = selectTableId
    }
  }
  
  // 削除
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCellEditingStyle.delete {
      
      let realm = try! Realm()
      questionItem = realm.objects(RealmDB.self)
      tableView.reloadData()
      try! realm.write {
        realm.delete(self.questionItem[indexPath.row])
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
      }
    }
  }
  
}

