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
        self.view.nodeMoved(node: self.node)
    }
    
    override func changeNodeViewColor(isSelected:Bool){
        if isSelected == true{
            self.skinLayer.strokeColor = UIColor.yellow.cgColor
            self.skinLayer.fillColor = UIColor.yellow.cgColor
        }else{
            self.skinLayer.strokeColor = UIColor.orange.cgColor
            self.skinLayer.fillColor = UIColor.orange.cgColor
        }
    }
}
