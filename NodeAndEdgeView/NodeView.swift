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
        if recongnizer.state == .began{
            self.previousPosition = recongnizer.location(in: self.superview)
            self.superview?.bringSubviewToFront(self)
        }else if let unwrappedPreviousPanPosition = self.previousPosition, recongnizer.state == .changed{
            let movedPosition = recongnizer.location(in: self.superview)
            let deltaX = movedPosition.x - unwrappedPreviousPanPosition.x
            let deltaY = movedPosition.y - unwrappedPreviousPanPosition.y
            let newPosition = CGPoint(x: self.frame.origin.x + deltaX,
                                      y: self.frame.origin.y + deltaY)
            self.frame.origin.x = newPosition.x
            self.frame.origin.y = newPosition.y
            self.previousPosition = newPosition
            self.node.setPosition(position: newPosition)
            self.view.nodeMoved(node:node)
        }
    }
    
    @objc func longPressHandler(recognizer:UILongPressGestureRecognizer){
        if recognizer.state == .began{
            print("nodeView longPressed")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
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
    }
}

