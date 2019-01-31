//
//  AncestorNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/28.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class AncestorNodeView: AbstractNodeView {
    required init(view: CanvasView, node: NodeModel) {
        super.init(view: view, node: node)
        self.defaultHeight = 75
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createLayer() {
        self.skinPath.removeAllPoints()
        self.skinLayer.removeFromSuperlayer()
        self.skinPath = UIBezierPath(ovalIn: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.frame.width,
                                                    height: self.frame.height))
        self.skinLayer.strokeColor = UIColor.magenta.cgColor
        self.skinLayer.fillColor = UIColor.magenta.cgColor
        self.skinLayer.borderWidth = 0
        self.skinLayer.path = self.skinPath.cgPath
        self.layer.addSublayer(self.skinLayer)
        self.view.nodeMoved(node: self.node)
    }
    
    override func changeNodeViewColor(isSelected:Bool){
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
        let adjustedWidth = text.getWidthOfString(usingFont: self.textLabel.font) + self.defaultHeight
        
        if adjustedWidth <= self.defaultWidth{
            self.currentWidth = self.defaultWidth
        }else if adjustedWidth >  self.defaultWidth, adjustedWidth <= self.maxWidth{
            self.currentWidth = adjustedWidth
        }else if adjustedWidth > self.maxWidth{
            self.currentWidth = self.maxWidth
        }
        self.frame.origin.x = self.view.getCanvasLimitSize().midX - self.currentWidth / 2 
        self.setNeedsLayout()
    }
}
