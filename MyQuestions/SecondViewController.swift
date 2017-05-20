//
//  SecondViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
  var questionItem: Results<RealmDB>!
//  var categoryItem: Results<CategoryList>!
  
  // Pickerに格納されている文字列
  var categoryString: [String?] = ["国語","数学", "社会", "理科", "英語"]
  // Pickerで選択した文字列の格納場所
  var didCategorySelect = String()
  // TableViewで選択したデータのIDの格納場所
  var selectId = Int()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self)
//    categoryItem = realm.objects(CategoryList.self)
    
//    let editCategoryList = realm.objects(CategoryList.self).value(forKey: "categoryname")
//    let categoryString = editCategoryList as? [String]
//    categoryPickerView.selectRow(0, inComponent: 0, animated: false)
//    if let categoryString = categoryString {
//      didCategorySelect = categoryString[0]
//    }
    nowLevel.text = "5"
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var nowLevel: UILabel!
  
  @IBOutlet weak var titleTextView: UITextField!
  @IBOutlet weak var questionTextView: UITextField!
  @IBOutlet weak var answerTextView: UITextField!
  @IBOutlet weak var categoryPickerView: UIPickerView!
  
  
  @IBAction func tapScreen(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  @IBAction func levelSlider(_ sender: UISlider) {
    nowLevel.text = String(Int(sender.value))
  }
  
  // pickerViewの列数
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  // pickerViewの行数
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoryString.count
  }
  // pickerViewのセルを表示
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categoryString[row]
  }
  // pickerViewのセルを選択
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    didCategorySelect = (categoryString[row])!
  }
  
//  func createRealmDB(name: String, category: [String]){
//    let categoryList = List<CategoryList>()
//    for categorys in category {
//      let newCategory = CategoryList()
//      newCategory.categorylist = categorys
//      categoryList.append(newCategory)
//    }
//  }
  
  // データを保存
  @IBAction func saveButton(_ sender: Any) {
    // 未入力項目がないか確認
    if (titleTextView.text != "" || questionTextView.text != ""
      || answerTextView.text != "" || didCategorySelect == "選択してください"){
      
      // 新しいインスタンスを生成
      let newRealmDB = RealmDB()
      // textField等に入力したデータをnewRealmDBに代入
      newRealmDB.title = titleTextView.text!
      newRealmDB.question = questionTextView.text!
      newRealmDB.answer = answerTextView.text!
      newRealmDB.category = didCategorySelect
      newRealmDB.level = nowLevel.text!
      // 既にデータが他に作成してある場合
      if questionItem.count != 0 {
        newRealmDB.id = questionItem.max(ofProperty: "id")! + 1
      }
      
      // 上記で代入したテキストデータを永続化
      let realm = try! Realm()
      questionItem = realm.objects(RealmDB.self)
      try! realm.write({ () -> Void in
        realm.add(newRealmDB, update: false)
      })
      // 保存したことを知らせるアラート表示
      let alertController = UIAlertController(title: "保存しました", message: "問題一覧に戻ります", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      reset()
      
    }else {
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
    nowLevel.text! = String()
  }
  
  // Doneボタンを押した際キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

