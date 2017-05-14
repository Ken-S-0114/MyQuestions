//
//  QuestionViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  var questionItem: Results<RealmDB>!
  var selectQuestion: String?
  var selectAnswer: String?
  var answerCount: Int = 0
  var limitCount: Int?
  
  //  override func viewDidLoad() {
  //    super.viewDidLoad()
  //    // Do any additional setup after loading the view.
  //    questionTextView.text = selectQuestion
  //    answerCount = 0
  //
  //    // button.addTarget(self, action: #selector(self.tappedButton), for: .touchUpInside)
  //  }
  //
  //  override func didReceiveMemoryWarning() {
  //    super.didReceiveMemoryWarning()
  //    // Dispose of any resources that can be recreated.
  //  }
  //
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if(answerTextField.isFirstResponder) {
      answerTextField.resignFirstResponder()
    }
  }
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabelView: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabelView: UILabel!
  @IBOutlet weak var answerTextField: UITextField!
  @IBOutlet weak var levelLabel: UILabel!

  @IBAction func nextQuestionButton(_ sender: Any) {
  }
  
  // 答え合わせ
  @IBAction func checkButton(_ sender: Any) {
    if (answerTextField.text != "") {
      if (answerTextField.text == selectAnswer!) {
        let alertController = UIAlertController(title: "正解", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
      }else if (answerTextField.text != selectAnswer!) {
        if (answerCount < limitCount!) {
          let alertController = UIAlertController(title: "不正解", message: "残りあと\((limitCount!-1)-answerCount)回", preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
          alertController.addAction(alertAction)
          present(alertController, animated: true, completion: nil)
          answerCount += 1
        }else {
          let alertController = UIAlertController(title: "不正解\n答え：\(selectAnswer!)", message: nil, preferredStyle: .alert)
          let alertAction = UIAlertAction(title: "確認", style: .default, handler: nil)
          alertController.addAction(alertAction)
          present(alertController, animated: true, completion: nil)
        }
      }else {
        let alertController = UIAlertController(title: "答えが入力されていません", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "もう一度", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
      }
    }
  }
  
  
}
