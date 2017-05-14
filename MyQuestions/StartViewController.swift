//
//  StartViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  var selectId: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    selectId = appDelegate.selectId
    selectIdLabel.text! = selectId.description
  }
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var selectIdLabel: UILabel!

  @IBAction func configurationButton(_ sender: Any) {
     performSegue(withIdentifier: "configurationSegue", sender: nil)
  }

  @IBAction func startButton(_ sender: Any) {
     performSegue(withIdentifier: "testSegue", sender: nil)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
