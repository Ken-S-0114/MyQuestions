//
//  AddCategoryViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/17.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class AddCategoryViewController: UIViewController {
  
  var categoryItem: Results<CategoryDB>!
  var check: Bool = true        // 同じジャンル名があるかチェックする変数
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let realms = try! Realm()
    categoryItem = realms.objects(CategoryDB.self)
    // doneButtonView.isEnabled = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func tapScreen(_ sender: Any) {
    self.view.endEditing(true)
  }
  @IBOutlet weak var newCategoryTextField: UITextField!
  @IBOutlet weak var doneButtonView: UIBarButtonItem!
  
  @IBAction func doneButton(_ sender: UIBarButtonItem) {
    var i: Int = 0;
    // 新しいインスタンスを生成
    let newAddCategory = CategoryDB()
    //textField等に入力したデータをnewAddCategoryに代入
    newAddCategory.name = newCategoryTextField.text!
    //既にデータが他に作成してある場合
    if categoryItem.count != 0 {
      newAddCategory.id = categoryItem.max(ofProperty: "id")! + 1
    }
    
    // 上記で代入したテキストデータを永続化
    let realms = try! Realm()
    categoryItem = realms.objects(CategoryDB.self)
    
    while_i: while categoryItem.count > i {
      // 同じジャンル名があるかDB上でチェック
      if newAddCategory.name == categoryItem[i].name {
        // 同じ名前のジャンルが既に存在している場合
        let alertController = UIAlertController(title: "保存失敗", message: "同じ名前のジャンルが既に存在します", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        check = false
        break while_i
      }
      i += 1
      check = true
    }
    
    if !newAddCategory.name.isEmpty && check {
      try! realms.write({ () -> Void in
        realms.add(newAddCategory, update: false)
      })
      
      // 保存したことを知らせるアラート表示
      let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      //_ = self.navigationController?.popViewController(animated: true)
      let pop: String = appDelegate.pop
      print(pop)
      switch pop {
        case "Second":
          _ = navigationController?.popToViewController(SecondViewController(), animated: true)
        print("Secondに移動")
        case "Edit":
        _ = navigationController?.popToViewController(EditViewController(), animated: true)
        print("Editに移動")
      default:
        print("エラー")
      }
    }
      // 答えが未入力の場合
    else {
      let alertController = UIAlertController(title: "保存失敗", message: "ジャンル名が入力されていません", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
    }
    
  }
}
