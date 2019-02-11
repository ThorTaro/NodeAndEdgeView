//
//  NodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class WordView: AbstractWordView {
    required init(targetView: ScrollView, wordModel: WordModel) {
        super.init(targetView: targetView, wordModel: wordModel)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panHandler(recongnizer:UIPanGestureRecognizer){
        if !self.targetView.getWordViewSelectedMode(){
            if recongnizer.state == .began{
                self.previousPosition = recongnizer.location(in: self.superview)
                self.superview?.bringSubviewToFront(self)
            }else if let unwrappedPreviousPanPosition = self.previousPosition,recongnizer.state == .changed{
                let movedPosition = recongnizer.location(in: self.superview)
                let deltaX = movedPosition.x - unwrappedPreviousPanPosition.x
                let deltaY = movedPosition.y - unwrappedPreviousPanPosition.y
                let newViewFrameOrigin = CGPoint(x: self.frame.origin.x + deltaX,
                                          y: self.frame.origin.y + deltaY)
                if self.isAbleToMove(newPosition: newViewFrameOrigin){
                    self.frame.origin.x = newViewFrameOrigin.x
                    self.frame.origin.y = newViewFrameOrigin.y
                    self.previousPosition = movedPosition
                    self.wordModel.setPosition(position: newViewFrameOrigin)
                    self.targetView.wordViewMoved(movedWordModel: self.wordModel)
                }
            }
        }
    }
    
    override func createLayer() {
        self.skinPath.removeAllPoints()
        self.skinLayer.removeFromSuperlayer()
        self.skinPath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.frame.width,
                                                         height: self.frame.height),
                                     cornerRadius: self.frame.height / 2)
        self.skinLayer.strokeColor = UIColor.orange.cgColor
        self.skinLayer.fillColor = UIColor.orange.cgColor
        self.skinLayer.borderWidth = 0
        self.skinLayer.path = self.skinPath.cgPath
        self.layer.addSublayer(self.skinLayer)
        self.targetView.wordViewMoved(movedWordModel: self.wordModel)
    }
    
    override func toggleWordViewColor(isSelected:Bool){
        if isSelected == true{
            self.skinLayer.strokeColor = UIColor.yellow.cgColor
            self.skinLayer.fillColor = UIColor.yellow.cgColor
        }else{
            self.skinLayer.strokeColor = UIColor.orange.cgColor
            self.skinLayer.fillColor = UIColor.orange.cgColor
        }
    }
}
