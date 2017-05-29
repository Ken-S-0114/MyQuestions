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
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  @IBOutlet weak var limitPickerView: UIPickerView!

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

//  func pickImageFromLibrary() {
//    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//      //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
//      let controller = UIImagePickerController()
//      controller.delegate = self
//      //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
//      //以下はカメラロールの例
//      //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
//      controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
//      self.present(controller, animated: true, completion: nil)
//    }
//  }
//  
//  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//    if info[UIImagePickerControllerOriginalImage] != nil {
//      //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報)をUIImageにCastする
//      let startVC: StartViewController = UIApplication.shared.delegate as! StartViewController //AppDelegateのインスタンスを取得
//      StartViewController.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
//    //写真選択後にカメラロール表示ViewControllerを閉じる
//    picker.dismiss(animated: true, completion: nil)
//  }
//
}
