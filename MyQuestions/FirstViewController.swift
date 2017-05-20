//
//  FirstViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var questionItem: Results<RealmDB>!
  var selectId :Int = 0
  var correctmark: Float = 0.0
  var wrongmark: Float = 0.0
  var rate: Float = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let realm = try! Realm()
    questionItem = realm.objects(RealmDB.self).sorted(byKeyPath: "id", ascending: true)    
    questionTableView.reloadData()
  }
  
  @IBOutlet weak var questionTableView: UITableView!
  
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
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "questionCell")
    let object = questionItem[indexPath.row]
    rate = ((Float(object.correctmark)) / ((Float(object.correctmark))+(Float(wrongmark))))
    cell.textLabel?.text = object.title
    cell.detailTextLabel?.text = ("正答率:\(rate)%")
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectObject = questionItem[indexPath.row]
    selectId = selectObject.id
    performSegue(withIdentifier: "questionSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "questionSegue") {
      let editVC: EditViewController = segue.destination as! EditViewController
      editVC.selectedId = selectId
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

