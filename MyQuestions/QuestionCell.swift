//
//  QuestionCell.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/29.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var rateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  func setCell(category: String, rate: String, title: String){
    categoryLabel.text = category
    rateLabel.text = rate
    titleLabel.text = title
  }

}
