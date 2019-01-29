//
//  NodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class DescendantNodeView: AbstractNodeView {
    required init(view: CanvasView, node: NodeModel) {
        super.init(view: view, node: node)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panHandler(recongnizer:UIPanGestureRecognizer){
        if !self.view.getSelectedModeStatus(){
            if recongnizer.state == .began{
                self.previousPosition = recongnizer.location(in: self.superview)
                self.superview?.bringSubviewToFront(self)
            }else if let unwrappedPreviousPanPosition = self.previousPosition,recongnizer.state == .changed{
                let movedPosition = recongnizer.location(in: self.superview)
                let deltaX = movedPosition.x - unwrappedPreviousPanPosition.x
                let deltaY = movedPosition.y - unwrappedPreviousPanPosition.y
                let newPosition = CGPoint(x: self.frame.origin.x + deltaX,
                                          y: self.frame.origin.y + deltaY)
                if self.ableToMove(newPosition: newPosition){
                    self.frame.origin.x = newPosition.x
                    self.frame.origin.y = newPosition.y
                    self.previousPosition = movedPosition
                    self.node.setPosition(position: newPosition)
                    self.view.nodeMoved(node: self.node)
                }
            }
        }
    }
    
    override func setUpView() {
        super.setUpView()
        self.backgroundColor = .orange
    }
    
    override func changeNodeViewColor(isSelected:Bool){
        if isSelected == true{
            self.backgroundColor = .yellow
        }else{
            self.backgroundColor = .orange
        }
    }
}
