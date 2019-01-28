//
//  AbstractNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/29.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class AbstractNodeView:UIView{
    unowned var view:CanvasView
    unowned var node:NodeModel
    private var previousPosition:CGPoint?
    private var textLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let defaultWidth:CGFloat = 200.0
    private let defaultHeight:CGFloat = 50.0
    private let maxWidth:CGFloat = 800.0
    private var currentWidth:CGFloat = 0.0
    private var currentText = String()
    
    required init(view:CanvasView, node:NodeModel) {
        self.view = view
        self.node = node
        super.init(frame: CGRect(origin: self.node.getPosition() , size: CGSize.zero))
        self.currentWidth = self.defaultWidth
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(pan)
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
            self.view.nodeSelected(selectedNode: self.node, isSelected: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.view.getSelectedModeStatus(){
            self.superview?.bringSubviewToFront(self)
        }else{
            if let touchesLocation = touches.first?.location(in: self), let touchedView = self.hitTest(touchesLocation, with: event) as? DescendantNodeView, !self.view.isLooped(childNode: touchedView.node){
                self.view.createEdge(childNode: touchedView.node)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUpView()
    }
    
    open func setUpView(){
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        self.frame.size = CGSize(width: self.currentWidth, height: self.defaultHeight)
        self.backgroundColor = .orange
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.adjustPosition(delta: self.outsideContainer(createdFrame: self.frame))
        self.textLabel.frame = self.bounds
        self.textLabel.font = UIFont.systemFont(ofSize: self.textLabel.frame.height / 2)
        self.addSubview(self.textLabel)
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
    
    public func changeNodeViewColor(isSelected:Bool){
        if isSelected == true{
            self.backgroundColor = .yellow
        }else{
            self.backgroundColor = .orange
        }
    }
    
    public func removeNodeView(){
        self.removeFromSuperview()
    }
    
    public func setText(text:String){
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
        self.setNeedsLayout()
    }
    
    public func getDefaultCenter() -> CGPoint{
        return CGPoint(x: self.defaultWidth/2, y: self.defaultHeight/2)
    }
}

//extension String{
//    public func getWidthOfString(usingFont font: UIFont) -> CGFloat{
//        let attributes = [NSAttributedString.Key.font: font]
//        let size = self.size(withAttributes: attributes)
//        return size.width
//    }
//}

