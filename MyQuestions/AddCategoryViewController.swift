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
  
 // var categoryItem: Results<CategoryList>!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let realmc = try! Realm()
 //   categoryItem = realmc.objects(CategoryList.self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func doneButton(_ sender: Any) {
    // 新しいインスタンスを生成
   // let newAddCategory = CategoryList()
    // textField等に入力したデータをnewAddCategoryに代入
    //newAddCategory.categorylist = [newCategoryTextField.text!]
    // 既にデータが他に作成してある場合
//    if categoryItem.count != 0 {
//      newAddCategory.id = categoryItem.max(ofProperty: "id")! + 1
//    }
//    
//    // 上記で代入したテキストデータを永続化
//    let realmc = try! Realm()
//    categoryItem = realmc.objects(CategoryList.self)
//    try! realmc.write({ () -> Void in
//      realmc.add(newAddCategory, update: false)
//    })
//    
//    // 保存したことを知らせるアラート表示
//    let alertController = UIAlertController(title: "保存しました", message: "問題作成に戻ります", preferredStyle: .alert)
//    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alertController.addAction(alertAction)
//    present(alertController, animated: true, completion: nil)
//    
//    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBOutlet weak var newCategoryTextField: UITextField!
}
