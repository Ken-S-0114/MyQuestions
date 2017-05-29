//
//  ConfigurationViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
  
  var limitCounter: [Int] = ([Int])(1...5)  // 回答回数を選択
  var limit: Int = 1                        // 回答回数
  var rateCheck = Bool()
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    limit = limitCounter[0]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    limit = appDelegate.limit
    rateCheck = appDelegate.rateCheck
    if (rateCheck == true){
      rateSwitchView.isOn = true
    }else{
      rateSwitchView.isOn = false
    }
    limitPickerView.selectRow((limit)-1, inComponent: 0, animated: true)
  }
  
  @IBOutlet weak var limitPickerView: UIPickerView!
  @IBOutlet weak var rateLabelView: UILabel!
  @IBOutlet weak var rateSwitchView: UISwitch!
  
  @IBAction func rateSwitch(_ sender: UISwitch) {
    if (sender.isOn){
      rateCheck = true
    }else {
      rateCheck = false
    }
    appDelegate.rateCheck = rateCheck
  }
  
  @IBAction func decisionButton(_ sender: Any) {
    appDelegate.limit = limit//appDelegateの変数を操作
    _ = navigationController?.popViewController(animated: true)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return limitCounter.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(limitCounter[row])
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    limit = limitCounter[row]
  }
}
