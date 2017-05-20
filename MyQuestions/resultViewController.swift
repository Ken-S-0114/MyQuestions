//
//  resultViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/17.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class resultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
//  var questionItem: Results<RealmDB>!
  var selectId: [Int] = []
  var correct: Float = 0.00
  var wrong: Float = 0.00
  var mark: [String] = []
  var i: Int = 0
  var l: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //AppDelegateのインスタンスを取得

      let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
      selectId = appDelegate.selectId
      correct = Float(appDelegate.correct)
      wrong = Float(appDelegate.wrong)
      mark = appDelegate.mark
      
      correctLabel.text = String("\((correct / (correct + wrong)) * 100)%")
      correctproportionView.text = ("\(Int(correct+wrong))問中\(Int(correct))問正解しました")
      
      /* appDelegate 初期化 */
      appDelegate.correct = 0
      appDelegate.wrong = 0
      appDelegate.mark = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBOutlet weak var correctLabelView: UILabel!
  @IBOutlet weak var correctLabel: UILabel!
  @IBOutlet weak var correctproportionView: UILabel!
  @IBOutlet weak var resultTableView: UITableView!

  @IBAction func resultButton(_ sender: Any) {
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1;
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectId.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
    let realm = try! Realm()
    // 選択されたIDからRealmDBに保存してあるデータを表示
    let selectRealmDB = realm.object(ofType: RealmDB.self, forPrimaryKey: selectId[i] as AnyObject)
    if let selectTitle = selectRealmDB?.title {
      cell.setCell(number: "第\(String(describing: l))問", title: String(describing: selectTitle), mark: String(mark[indexPath.row]))
    }
    l += 1
    i += 1
    return cell
  }
  
}




