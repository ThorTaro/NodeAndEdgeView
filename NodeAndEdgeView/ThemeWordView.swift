//
//  AncestorNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/28.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ThemeWordView: AbstractWordView {
    required init(targetView: ScrollView, wordModel: WordModel, position: CGPoint) {
        super.init(targetView: targetView, wordModel: wordModel, position: position)
        self.defaultViewHeight = 150 // ***MAGIC NUMBER***
        self.defaultViewWidth = 400
        self.currentViewWidth = self.defaultViewWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createLayer() {
        self.skinPath.removeAllPoints()
        self.skinLayer.removeFromSuperlayer()
        self.skinPath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                         y: 0,
                                                         width: self.frame.width,
                                                         height: self.frame.height),
                                     cornerRadius: self.frame.height / 2)
        self.skinLayer.strokeColor = UIColor.magenta.cgColor
        self.skinLayer.fillColor = UIColor.magenta.cgColor
        self.skinLayer.borderWidth = 0
        self.skinLayer.path = self.skinPath.cgPath
        self.layer.addSublayer(self.skinLayer)
        self.targetView.wordViewMoved(movedWordModel: self.wordModel, newPosition: self.frame.origin)
    }
    
    override func toggleWordViewColor(isSelected:Bool){
        if isSelected == true{
            self.skinLayer.strokeColor = UIColor.yellow.cgColor
            self.skinLayer.fillColor = UIColor.yellow.cgColor
        }else{
            self.skinLayer.strokeColor = UIColor.magenta.cgColor
            self.skinLayer.fillColor = UIColor.magenta.cgColor
        }
    }
    
    override func setText(text: String) {
        self.currentText = text
        self.textLabel.text = self.currentText
        let adjustedWidth = text.getWidthOfString(usingFont: self.textLabel.font) + self.defaultViewHeight
        
        if adjustedWidth <= self.defaultViewWidth{
            self.currentViewWidth = self.defaultViewWidth
        }else if adjustedWidth >  self.defaultViewWidth, adjustedWidth <= self.maxViewWidth{
            self.currentViewWidth = adjustedWidth
        }else if adjustedWidth > self.maxViewWidth{
            self.currentViewWidth = self.maxViewWidth
        }
        self.frame.origin.x = self.targetView.getContentViewMaxSize().midX - self.currentViewWidth / 2 
        self.setNeedsLayout()
    }
}
