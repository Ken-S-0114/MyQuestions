//
//  resultViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/17.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
  
  var correct: Int = 0
  var wrong: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
      correct = appDelegate.correct
      wrong = appDelegate.wrong
      correctLabel.text = String("\((correct / (correct + wrong)) * 100)%")
      correctproportionView.text = ("\(correct+wrong)問中\(correct)問正解しました")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBOutlet weak var correctLabelView: UILabel!
  @IBOutlet weak var correctLabel: UILabel!
  @IBOutlet weak var correctproportionView: UILabel!

}
