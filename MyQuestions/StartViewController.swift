//
//  StartViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var selectId: [Int] = []    // SelectQuestionViewControllerで選択された問題番号
  var limit = Int()
  // AppDelegateのインスタンスを取得
  let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // ボタン操作を無効
    startButtonView.isEnabled = false
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    limitLabel.text = "正答回数：\(limit)回"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    selectId = appDelegate.selectId
    limit = appDelegate.limit
    selectIdLabel.text = "問題数：\(selectId.count)問"
    limitLabel.text = "正答回数：\(limit)回"
    
    // 問題が選択している場合
    if (selectId.isEmpty == false) {
      // ボタン操作を有効
      startButtonView.isEnabled = true
    }else {
      // ボタン操作を無効
      startButtonView.isEnabled = false
    }
  }
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var selectIdLabel: UILabel!
  @IBOutlet weak var limitLabel: UILabel!
  @IBOutlet weak var startButtonView: UIButton!
  @IBAction func selectBackground(_ sender: Any) {
    pickImageFromLibrary()  //ライブラリから写真を選択する
  }
  
  
  @IBAction func configurationButton(_ sender: Any) {
    performSegue(withIdentifier: "selectQuestionSegue", sender: nil)
  }
  
  @IBAction func startButton(_ sender: Any) {
    if (selectId.isEmpty == false) {
      performSegue(withIdentifier: "testSegue", sender: nil)
    }
  }
  
  func pickImageFromLibrary() {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
      //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
      let controller = UIImagePickerController()
      controller.delegate = self
      //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
      //以下はカメラロールの例
      //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
      controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
      self.present(controller, animated: true, completion: nil)
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if info[UIImagePickerControllerOriginalImage] != nil {
      //didFinishPickingMediaWithInfo通して渡された情報(選択された画像情報)をUIImageにCastする
      backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    //写真選択後にカメラロール表示ViewControllerを閉じる
    picker.dismiss(animated: true, completion: nil)
  }
}
