//
//  AbstractNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/29.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class AbstractWordView: UIView{
    unowned var targetView:ScrollView
    unowned var wordModel:WordModel

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
    public var defaultViewWidth:CGFloat = 300.0
    public var defaultViewHeight:CGFloat = 100.0
    public let maxViewWidth:CGFloat = 800.0
    public var currentViewWidth:CGFloat = 0.0
    public var currentText = String()
    
    required init(targetView:ScrollView, wordModel:WordModel, position:CGPoint) {
        self.targetView = targetView
        self.wordModel = wordModel
        super.init(frame: CGRect(origin: position, size: CGSize.zero))
        self.currentViewWidth = self.defaultViewWidth
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
        self.setNeedsLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func longPressHandler(recognizer:UILongPressGestureRecognizer){
        if self.targetView.getModeStatus() == .normal, recognizer.state == .began{
            self.targetView.wordViewSelected(selectedWordModel: self.wordModel, to: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.targetView.getModeStatus() == .normal{
            self.superview?.bringSubviewToFront(self)
        }else if self.targetView.getModeStatus() == .relationshipCreation{
            if let touchesLocation = touches.first?.location(in: self), let touchedView = self.hitTest(touchesLocation, with: event) as? AbstractWordView, !self.targetView.isRelationshipLooped(dst: touchedView.wordModel){
                self.targetView.createRelationship(with: touchedView.wordModel)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setViewAndLayer()
    }
    
    public func setViewAndLayer(){
        self.backgroundColor = .clear
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y)
        self.frame.size = CGSize(width: self.currentViewWidth, height: self.defaultViewHeight)
        self.createLayer()
        self.adjustInsideContentView(delta: self.errorOutsideContentView(createdViewFrame: self.frame))
        self.textLabel.frame = self.bounds
        self.textLabel.font = UIFont(name: "HiraginoSans-W0", size: self.frame.height/2)
        self.addSubview(self.textLabel)
    }
    
    public func createLayer(){
        // For override func
    }
    
    public func isAbleToMove(newPosition:CGPoint) -> Bool{
        let contentView = self.targetView.getContentViewMaxSize()
        var viewFrameAfterMoved = self.frame
        viewFrameAfterMoved.origin.x = newPosition.x
        viewFrameAfterMoved.origin.y = newPosition.y
        if viewFrameAfterMoved.minX >= contentView.minX && viewFrameAfterMoved.minY >= contentView.minY && viewFrameAfterMoved.maxX <= contentView.maxX && viewFrameAfterMoved.maxY <= contentView.maxY{
            return true
        }else{
            return false
        }
    }
    
    private func adjustInsideContentView(delta:CGPoint){
        self.frame.origin.x -= delta.x
        self.frame.origin.y -= delta.y
        self.targetView.wordViewMoved(movedWordModel: self.wordModel, newPosition: self.frame.origin)
    }
    
    private func errorOutsideContentView(createdViewFrame:CGRect) -> CGPoint{
        let contentView = self.targetView.getContentViewMaxSize()
        var deltaX:CGFloat = 0.0
        var deltaY:CGFloat = 0.0
        
        if createdViewFrame.minY < contentView.minY{
            deltaY = createdViewFrame.minX - contentView.minY
        }
        if createdViewFrame.minX < contentView.minX{
            deltaX = createdViewFrame.minX - contentView.minX
        }
        if createdViewFrame.maxY > contentView.maxY{
            deltaY = createdViewFrame.maxY - contentView.maxY
        }
        if createdViewFrame.maxX > contentView.maxX{
            deltaX = createdViewFrame.maxX - contentView.maxX
        }
        
        return CGPoint(x: deltaX, y: deltaY)
    }
    
    public func removeWordView(){
        self.removeFromSuperview()
    }
    
    public func setText(text:String){
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
        
        self.setNeedsLayout()
    }
    
    public func getViewCenterPosition() -> CGPoint{
        return CGPoint(x: self.defaultViewWidth/2, y: self.defaultViewHeight/2)
    }
    
    public func toggleWordViewColor(isSelected:Bool){
        // for override func
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

