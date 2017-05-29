//
//  EditViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/12.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
  var questionItem: Results<RealmDB>!
  var categoryItem: Results<CategoryDB>!
  var count: Int = 0      // CategoryDBに保存してあるデータ数
  var l: Int = 0          // UIPickerの初期位置を格納
  var i: Int = 0          // 比較する変数
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  // Pickerに格納されている文字列
  var categoryString: [String?] = []
  // Pickerで選択した文字列の格納場所
  var didCategorySelect = String()
  // TableViewで選択されたデータのID
  var selectTableId = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    reset()
    // Do any additional setup after loading the view.
    let realm = try! Realm()
    let realms = try! Realm()
    
    questionItem = realm.objects(RealmDB.self)
    categoryItem = realms.objects(CategoryDB.self)
    
    // 選択された問題番号
    selectTableId = appDelegate.selectTableId
    
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let editRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectTableId as AnyObject)
    titleTextView.text = editRealmDB?.title
    questionTextView.text = editRealmDB?.question
    answerTextView.text = editRealmDB?.answer
    if let category = editRealmDB?.category {
      didCategorySelect = category
    }
    nowLabel.text = editRealmDB?.level
    
    // Picker処理
    count = categoryItem.count
    // CategoryDBに保存してある値を配列に格納
    while count > i {
      let object = categoryItem[i]
      categoryString += [object.name]
      // 配列に同じジャンル名があるか検索
      if(didCategorySelect == object.name) {
        l = i     // 同じジャンル名の配列番号記憶
      }
      i += 1
    }
    categoryPickerView.reloadAllComponents()
    // 初期位置セット
    categoryPickerView.selectRow(l, inComponent: 0, animated: true)
    // 比較する変数の初期化
    i = 0
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let realms = try! Realm()
    categoryItem = realms.objects(CategoryDB.self)
    // 変更後の数
    let recount: Int = categoryItem.count
    // 変更前の数と比べる
    if(recount != count){
      // 配列の中身を初期化
      categoryString = []
      // CategoryDBに保存してある値を配列にあるだけ再度格納
      while recount>i {
        let object = categoryItem[i]
        categoryString += [object.name]
        if(didCategorySelect == object.name) {
          // 同じジャンル名の配列番号記憶
          l = i
        }
        i += 1
      }
      categoryPickerView.reloadAllComponents()
      i = 0
      // 個数更新
      count = recount
      // 初期位置セット
      categoryPickerView.selectRow(l, inComponent: 0, animated: true)
    }
  }
  
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var nowLabel: UILabel!
  
  @IBOutlet weak var titleTextView: UITextField!
  @IBOutlet weak var questionTextView: UITextField!
  @IBOutlet weak var answerTextView: UITextField!
  @IBOutlet weak var categoryPickerView: UIPickerView!
  
  @IBAction func addCategory(_ sender: Any) {
    appDelegate.pop = ""
    appDelegate.pop = "Edit"
    performSegue(withIdentifier: "addCategorySegue2", sender: nil)
  }
  
  @IBAction func levelSlider(_ sender: UISlider) {
    nowLabel.text = String(Int(sender.value))
  }
  
  @IBAction func tapScreen(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  // 列数
  func  numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  // 行数
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoryString.count
  }
  // セルに表示
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categoryString[row]
  }
  // セルを選択
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if let didCategoryString = categoryString[row] {
      didCategorySelect = didCategoryString
    }
  }
  
  // データの上書き保存
  @IBAction func resaveButton(_ sender: Any) {
    if ((titleTextView.text != "") && (questionTextView.text != "") && (answerTextView.text != "") && (categoryString.isEmpty == false)){
      // 新しいインスタンスを生成
      let editRealmDB = RealmDB()
      // textField等に入力したデータをeditRealmDBに代入
      editRealmDB.title = titleTextView.text!
      editRealmDB.question = questionTextView.text!
      editRealmDB.answer = answerTextView.text!
      editRealmDB.category = didCategorySelect
      editRealmDB.level = nowLabel.text!
      editRealmDB.id = selectTableId
      
      // 上記で代入したテキストデータを永続化
      let realm = try! Realm()
      try! realm.write({ () -> Void in
        realm.add(editRealmDB, update: true)
      })
      
      // 上書き保存したことを知らせるアラート表示
      let alertController = UIAlertController(title: "保存しました", message: "上書き保存します", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      _ = navigationController?.popViewController(animated: true)
    }
    else {
      // 未入力を知らせるアラート表示
      let alertController = UIAlertController(title: "未入力項目が存在します", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  
  // 入力項目を全てリセット
  func reset() {
    titleTextView.text! = String()
    questionTextView.text! = String()
    answerTextView.text! = String()
    categoryPickerView.selectRow(0, inComponent: 0, animated: false)
    //nowLevel.text! = String()
  }
  
  // Doneボタンを押した際キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}
