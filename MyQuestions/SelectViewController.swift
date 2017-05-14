//
//  SelectViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/13.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit

class SelectViewController: UIButton {
  
  var baseColor:UIColor = UIColor.lightGray
  private var isMulti:Bool = false
  private let frameShapeLayer:CAShapeLayer = CAShapeLayer()
  private let checkShapeLayer:CAShapeLayer = CAShapeLayer()
  private let framePath:UIBezierPath = UIBezierPath()
  private let checkPath:UIBezierPath = UIBezierPath()
  private let margin:CGFloat = 16
  private let lineWidth:CGFloat = 2
  convenience init(isMulti m: Bool, color c:UIColor) {
    self.init()
    isMulti = m
    tintColor = c
    isSelected = false
    layer.addSublayer(frameShapeLayer)
    layer.addSublayer(checkShapeLayer)
  }
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    if isMulti {
      // frame is rectangle
      framePath.move(to: CGPoint(x:margin, y:margin))
      framePath.addLine(to: CGPoint(x:margin, y:self.frame.height - margin))
      framePath.addLine(to: CGPoint(x:self.frame.height - margin, y:self.frame.height - margin))
      framePath.addLine(to: CGPoint(x:self.frame.height - margin, y:margin))
      framePath.addLine(to: CGPoint(x:margin - lineWidth/2, y:margin))
      framePath.stroke()
      // selected mark is v
      checkPath.move(to: CGPoint(x:margin + 2, y:self.frame.height/2 - 2))
      checkPath.addLine(to: CGPoint(x:self.frame.height/2, y:self.frame.height/2 + 2))
      checkPath.addLine(to: CGPoint(x:self.frame.height - margin + 2, y:margin - 2))
      checkPath.stroke(with: CGBlendMode.clear, alpha: 0)
      checkShapeLayer.strokeColor = tintColor.cgColor
      checkShapeLayer.fillColor = UIColor.clear.cgColor
    } else {
      // frame is circle
      framePath.addArc(withCenter: CGPoint(x:self.frame.height/2, y:self.frame.height/2),
                       radius: self.frame.height - margin*2 - 6,
                       startAngle: 0,
                       endAngle: CGFloat.pi * 2,
                       clockwise: true)
      framePath.stroke()
      // selected mark is filled circle
      checkPath.addArc(withCenter: CGPoint(x:self.frame.height/2, y:self.frame.height/2),
                       radius: self.frame.height - margin*2 - 9,
                       startAngle: 0,
                       endAngle: CGFloat.pi * 2,
                       clockwise: true)
      checkPath.fill(with: CGBlendMode.clear, alpha: 0)
      checkShapeLayer.strokeColor = UIColor.clear.cgColor
      checkShapeLayer.fillColor = tintColor.cgColor
    }
    frameShapeLayer.path = framePath.cgPath
    frameShapeLayer.strokeColor = baseColor.cgColor
    frameShapeLayer.fillColor = UIColor.clear.cgColor
    frameShapeLayer.lineWidth = lineWidth
    checkShapeLayer.path = checkPath.cgPath
    checkShapeLayer.lineWidth = lineWidth
    checkShapeLayer.isHidden = true
  }
  func on(){
    setTitleColor(tintColor, for: .normal)
    frameShapeLayer.strokeColor = tintColor.cgColor
    checkShapeLayer.isHidden = false
    isSelected = true
  }
  func off(){
    setTitleColor(baseColor, for: .normal)
    frameShapeLayer.strokeColor = baseColor.cgColor
    checkShapeLayer.isHidden = true
    isSelected = false
  }
  func toggle(){
    if isSelected { off() }
    else { on() }
  }
  
  
}
