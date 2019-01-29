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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = .magenta
    }
    
    override func changeNodeViewColor(isSelected:Bool){
        if isSelected == true{
            self.backgroundColor = .yellow
        }else{
            self.backgroundColor = .magenta
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
