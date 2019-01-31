//
//  AbstractNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/29.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class AbstractNodeView: UIView{
    unowned var view:CanvasView
    unowned var node:NodeModel

    public let skinLayer = CAShapeLayer()
    public var skinPath = UIBezierPath()
    public var textLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    public var previousPosition:CGPoint?
    public var defaultWidth:CGFloat = 200.0
    public var defaultHeight:CGFloat = 50.0
    public let maxWidth:CGFloat = 800.0
    public var currentWidth:CGFloat = 0.0
    public var currentText = String()
    
    required init(view:CanvasView, node:NodeModel) {
        self.view = view
        self.node = node
        super.init(frame: CGRect(origin: self.node.getPosition() , size: CGSize.zero))
        self.currentWidth = self.defaultWidth
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
        self.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            if let touchesLocation = touches.first?.location(in: self), let touchedView = self.hitTest(touchesLocation, with: event) as? AbstractNodeView, !self.view.isLooped(childNode: touchedView.node){
                self.view.createEdge(childNode: touchedView.node)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        self.setupView()
    }
    
    public func setupView(){
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        self.frame.size = CGSize(width: self.currentWidth, height: self.defaultHeight)
        self.createLayer()
        self.adjustPosition(delta: self.outsideContainer(createdFrame: self.frame))
        self.textLabel.frame = self.bounds
        self.textLabel.font = UIFont.systemFont(ofSize: self.textLabel.frame.height / 2)
        self.addSubview(self.textLabel)
    }
    
    public func createLayer(){
        
    }
    
    public func ableToMove(newPosition:CGPoint) -> Bool{
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
    
    public func changeNodeViewColor(isSelected:Bool){
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.skinPath.contains(point) {
            return super.hitTest(point, with: event)
        }
        return nil
    }
}

extension String{
    public func getWidthOfString(usingFont font: UIFont) -> CGFloat{
        let attributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: attributes)
        return size.width
    }
}

