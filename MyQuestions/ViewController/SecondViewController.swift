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
  var categoryItem: Results<CategoryDB>!
  var categoryString: [String?] = []  // Pickerに格納されている文字列
  var didCategorySelect = String()    // Pickerで選択した文字列の格納場所
  var count: Int = 0                  // CategoryDBに保存してあるデータ数
  var i: Int = 0                      // 比較する変数
  var check: Bool = true              // 同じジャンル名があるかチェックする変数
  //AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let realm = try! Realm()
    let realms = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    categoryItem = realms.objects(CategoryDB.self)
    
    count = categoryItem.count
    // CategoryDBに保存してある値を配列に格納
    while count>i {
      let object = categoryItem[i]
      categoryString += [object.name]
      i += 1
    }
    // 比較する変数の初期化
    i = 0
    
    if !categoryString.isEmpty {
      categoryPickerView.selectRow(0, inComponent: 0, animated: true)
      didCategorySelect = categoryString[0]!
    }
    
    // 枠のカラー
    questionTextView.layer.borderColor = UIColor.gray.cgColor
    
    // 枠の幅
    questionTextView.layer.borderWidth = 0.5
    
    // 枠を角丸にする場合
    questionTextView.layer.cornerRadius = 10.0
    questionTextView.layer.masksToBounds = true
    // levelの初期値
    nowLevel.text = "5"
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let realms = try! Realm()
    categoryItem = realms.objects(CategoryDB.self)
    
    if !categoryString.isEmpty {
      categoryPickerView.selectRow(0, inComponent: 0, animated: true)
      didCategorySelect = categoryString[0]!
    }

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

      categoryPickerView.reloadAllComponents()

    }
    
  }
  
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var nowLevel: UILabel!
  
  @IBOutlet weak var titleTextView: UITextField!
  @IBOutlet weak var questionTextView: UITextView!
  @IBOutlet weak var answerTextView: UITextField!
  @IBOutlet weak var categoryPickerView: UIPickerView!
  
  @IBAction func addCategoryButton(_ sender: Any) {
    let realms = try! Realm()
    self.categoryItem = realms.objects(CategoryDB.self)
    let alert = UIAlertController(title: "新規カテゴリー", message: nil, preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "OK", style: .default, handler: {
      (action:UIAlertAction!) -> Void in
      
      var i: Int = 0;
      // 新しいインスタンスを生成
      let newAddCategory = CategoryDB()
      //textField等に入力したデータをnewAddCategoryに代入
      newAddCategory.name = alert.textFields![0].text!
//      //既にデータが他に作成してある場合
//      if self.categoryItem.count != 0 {
//        newAddCategory.id = self.categoryItem.max(ofProperty: "id")! + 1
//      }
      
      while_i: while self.categoryItem.count > i {
        // 同じジャンル名があるかDB上でチェック
        if newAddCategory.name == self.categoryItem[i].name {
          // アクションシートの親となる UIView を設定
          alert.popoverPresentationController?.sourceView = self.view
          // 吹き出しの出現箇所を CGRect で設定 （これはナビゲーションバーから吹き出しを出す例）
          alert.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
          // 同じ名前のジャンルが既に存在している場合
          let alertController = UIAlertController(title: "保存失敗", message: "同じ名前のジャンルが既に存在します", preferredStyle: .actionSheet)
          let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
          alertController.addAction(alertAction)
          
          //　iPad用クラッシュさせないために
          alertController.popoverPresentationController?.sourceView = self.view;
          alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!

          self.present(alertController, animated: true, completion: nil)
          self.check = false
          break while_i
        }
        i += 1
        self.check = true
      }
      
      if !newAddCategory.name.isEmpty && self.check {
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        
        // 吹き出しの出現箇所を CGRect で設定 （これはナビゲーションバーから吹き出しを出す例）
        alert.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
        let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler:{
          (action: UIAlertAction!) -> Void in
          // 1つ前の画面に戻る
//          self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(alertAction)
        
        //　iPad用クラッシュさせないために
        alertController.popoverPresentationController?.sourceView = self.view;
        alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
        
        self.present(alertController, animated: true, completion: nil)
        
        //既にデータが他に作成してある場合
        if self.categoryItem.count != 0 {
          newAddCategory.id = self.categoryItem.max(ofProperty: "id")! + 1
        }

        
        //上記で代入したテキストデータを永続化
        try! realms.write({ () -> Void in
          realms.add(newAddCategory, update: false)
        })
        self.viewWillAppear(true)
        
        let object = self.categoryItem[0]
        self.categoryString += [object.name]
        self.didCategorySelect = self.categoryString[0]!
      }
      else if newAddCategory.name.isEmpty {
        // アクションシートの親となる UIView を設定
        alert.popoverPresentationController?.sourceView = self.view
        
        // 吹き出しの出現箇所を CGRect で設定 （これはナビゲーションバーから吹き出しを出す例）
        alert.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!
        let alertController = UIAlertController(title: "入力されていません", message: "作成画面に戻ります", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        //　iPad用クラッシュさせないために
        alertController.popoverPresentationController?.sourceView = self.view;
        alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!

        self.present(alertController, animated: true, completion: nil)

      }
    })
    alert.addAction(saveAction)
    
    // キャンセルボタンの設定
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(cancelAction)
    
    // UIAlertControllerにtextFieldを追加
    alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
      textField.placeholder = "カテゴリーを入力してください"
    })
    present(alert, animated: true, completion: nil)
    
    
    
  }
  
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
    if let didCategoryString = categoryString[row] {
      didCategorySelect = didCategoryString
    }
  }
  
  
  // データを保存
  @IBAction func saveButton(_ sender: Any) {
    // 未入力項目がないか確認
    if titleTextView.text != "" && questionTextView.text != "" && answerTextView.text != "" && !categoryString.isEmpty {
      
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
      let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      
      //　iPad用クラッシュさせないために
      alertController.popoverPresentationController?.sourceView = self.view;
      alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!

      present(alertController, animated: true, completion: nil)
      reset()
      }else {
      // 未入力を知らせるアラート表示
      let alertController = UIAlertController(title: "未入力項目が存在します", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      
      //　iPad用クラッシュさせないために
      alertController.popoverPresentationController?.sourceView = self.view;
      alertController.popoverPresentationController?.sourceRect = (self.navigationController?.navigationBar.frame)!

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

