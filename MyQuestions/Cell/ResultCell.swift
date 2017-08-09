//
//  ResultCell.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/20.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var markLabel: UILabel!
  
  // カスタムセル（３列表示）
  func setCell(number: String, title: String, mark: String){
    numberLabel.text = number
    titleLabel.text = title
    markLabel.text = mark
  }
}
