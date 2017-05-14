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
  // Pickerに格納されている文字列
  var categoryString: NSArray = ["時事問題", "数学"]
  // Pickerで選択した文字列の格納場所
  var didCategorySelect = String()
  // TableViewで選択されたデータのID
  var selectedId = Int()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let editRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectedId as AnyObject)
    titleTextView.text? = (editRealmDB?.title)!
    questionTextView.text? = (editRealmDB?.question)!
    answerTextView.text? = (editRealmDB?.answer)!
    // 特定の文字列を検索、何個目かをInt型として返す
    let setCategory: Int = categoryString.index(of: editRealmDB?.category as Any)
    categoryPickerView.selectRow(setCategory, inComponent: 0, animated: false)
    didCategorySelect = (editRealmDB?.category)!
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
  @IBOutlet weak var nowLabel: UILabel!
  
  @IBOutlet weak var titleTextView: UITextField!
  @IBOutlet weak var questionTextView: UITextField!
  @IBOutlet weak var answerTextView: UITextField!
  @IBOutlet weak var categoryPickerView: UIPickerView!
  
  @IBAction func levelSlider(_ sender: UISlider) {
    nowLabel.text = String(Int(sender.value))
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
    return categoryString[row] as? String
  }
  // セルを選択
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    didCategorySelect = (categoryString[row] as? String)!
  }
  
  // データの上書き保存
  @IBAction func resaveButton(_ sender: Any) {
    // 新しいインスタンスを生成
    let editRealmDB = RealmDB()
    // textField等に入力したデータをeditRealmDBに代入
    editRealmDB.title = titleTextView.text!
    editRealmDB.question = questionTextView.text!
    editRealmDB.answer = answerTextView.text!
    editRealmDB.category = didCategorySelect
    editRealmDB.id = selectedId
    //editRealmDB.level =
    
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
    dismiss(animated: true, completion: nil)
    reset()
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