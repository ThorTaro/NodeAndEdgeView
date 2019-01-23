//
//  NodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class NodeView: UIView {
    unowned var view:CanvasView
    unowned var node:NodeModel
    private var previousPosition:CGPoint?
    
    required init(view:CanvasView, node:NodeModel) {
        self.view = view
        self.node = node
        super.init(frame: CGRect(origin: self.node.getPosition() , size: CGSize.zero))
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        self.addGestureRecognizer(pan)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
        
        self.setNeedsLayout()
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
    
    @objc func longPressHandler(recognizer:UILongPressGestureRecognizer){
        if !self.view.getSelectedModeStatus(), recognizer.state == .began{
            print("Node ID:\(self.node.getID()) selected")
            self.view.nodeSelected(selectedNode: self.node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.view.getSelectedModeStatus(){
            self.superview?.bringSubviewToFront(self)
        }else{
            if let touchesLocation = touches.first?.location(in: self), let touchedView = self.hitTest(touchesLocation, with: event) as? NodeView, !self.view.isLooped(childNode: touchedView.node){
                self.view.createEdge(childNode: touchedView.node)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUpView()
        
    }
    
    private func setUpView(){
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: 200,
                            height: 50)
        self.backgroundColor = .orange
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.adjustPosition(delta: self.outsideContainer(createdFrame: self.frame))
    }
    
    private func ableToMove(newPosition:CGPoint) -> Bool{
        let container = self.view.getCanvasLimitSize()
        var movedViewFrame = self.frame
        movedViewFrame.origin.x = newPosition.x
        movedViewFrame.origin.y = newPosition.y
        if movedViewFrame.minX >= container.minX && movedViewFrame.minY >= container.minY && movedViewFrame.maxX <= container.maxX && movedViewFrame.maxY <= container.maxY{
            return true
        }else{
            return false
        }
    }
    
    private func adjustPosition(delta:CGPoint){
        self.frame.origin.x -= delta.x
        self.frame.origin.y -= delta.y
        self.node.setPosition(position: CGPoint(x: self.frame.origin.x,
                                                y: self.frame.origin.y))
    }
    
    private func outsideContainer(createdFrame:CGRect) -> CGPoint{
        let container = self.view.getCanvasLimitSize()
        var deltaX:CGFloat = 0.0
        var deltaY:CGFloat = 0.0
        
        if createdFrame.minY < container.minY{
            deltaY = createdFrame.minX - container.minY
        }
        if createdFrame.minX < container.minX{
            deltaX = createdFrame.minX - container.minX
        }
        if createdFrame.maxY > container.maxY{
            deltaY = createdFrame.maxY - container.maxY
        }
        if createdFrame.maxX > container.maxX{
            deltaX = createdFrame.maxX - container.maxX
        }
        
        return CGPoint(x: deltaX, y: deltaY)
    }
    
    public func changeNodeViewColor(){
        if self.backgroundColor == .orange{
            self.backgroundColor = .magenta
        }else{
            self.backgroundColor = .orange
        }
    }
}

