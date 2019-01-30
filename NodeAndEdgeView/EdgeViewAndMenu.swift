//
//  NewEdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/30.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeViewAndMenu: UIView{
    private unowned var canvas:CanvasView
    private weak var parentNodeView:AbstractNodeView?
    private weak var childNodeView:AbstractNodeView?
    private var edgePath = UIBezierPath()
    private var edgeLayer = CAShapeLayer()
    
    private var button:UIButton = {
        let button = UIButton()
            button.frame.size = CGSize(width: 30, height: 30)
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            button.backgroundColor = .darkGray
        return button
    }()
    
    required init(canvas:CanvasView ,parentNodeView:AbstractNodeView?, childNodeView:AbstractNodeView?) {
        self.canvas = canvas
        self.parentNodeView = parentNodeView
        self.childNodeView = childNodeView
        super.init(frame: CGRect.zero)
        self.button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPath(){
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childNodeView else {
            print("Edge drawing failed")
            return
        }
        var startPosition = CGPoint.zero
        var endPosition = CGPoint.zero
        
        if unwrappedParentNodeView.center.x <= unwrappedChildNodeView.center.x && unwrappedParentNodeView.center.y <= unwrappedChildNodeView.center.y{
            startPosition = CGPoint.zero
            endPosition = CGPoint(x: self.frame.width, y: self.frame.height)
        }else if unwrappedParentNodeView.center.x >= unwrappedChildNodeView.center.x && unwrappedParentNodeView.center.y <= unwrappedChildNodeView.center.y{
            startPosition = CGPoint(x: self.frame.width, y: 0.0)
            endPosition = CGPoint(x: 0.0, y: self.frame.height)
        }else if unwrappedParentNodeView.center.x >= unwrappedChildNodeView.center.x && unwrappedParentNodeView.center.y > unwrappedChildNodeView.center.y{
            startPosition = CGPoint(x: self.frame.width, y: self.frame.height)
            endPosition = CGPoint.zero
        }else if unwrappedParentNodeView.center.x <= unwrappedChildNodeView.center.x && unwrappedParentNodeView.center.y > unwrappedChildNodeView.center.y{
            startPosition = CGPoint(x: 0.0, y: self.frame.height)
            endPosition = CGPoint(x: self.frame.width, y: 0.0)
        }else{
            print("segmentetion error")
        }
        
        self.edgePath.move(to: startPosition)
        self.edgePath.addLine(to: endPosition)
        self.edgePath.close()
    }
    
    private func createLayer(){
        self.edgeLayer.lineWidth = 10.0
        self.edgeLayer.strokeColor = UIColor.lightGray.cgColor
        self.edgeLayer.path = self.edgePath.cgPath
    }
    
    private func getFrame() -> CGRect{
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childNodeView else {
            print("Edge drawing failed")
            return CGRect.zero
        }
        return CGRect(x: min(unwrappedParentNodeView.center.x, unwrappedChildNodeView.center.x),
                      y: min(unwrappedParentNodeView.center.y, unwrappedChildNodeView.center.y),
                      width: abs(unwrappedParentNodeView.center.x - unwrappedChildNodeView.center.x),
                      height: abs(unwrappedParentNodeView.center.y - unwrappedChildNodeView.center.y))
    }
    
    private func setupView(){
        self.frame = self.getFrame()
        self.backgroundColor = .clear
        self.createPath()
        self.createLayer()
        self.layer.insertSublayer(self.edgeLayer, at: 0)
        self.button.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.button.removeFromSuperview()
        self.addSubview(self.button)
        self.hideButton()
    }
    
    public func redrawEdge(){
        self.edgePath.removeAllPoints()
        self.edgeLayer.removeFromSuperlayer()
        self.setupView()
    }
    
    public func removeEdgeView(){
        self.removeFromSuperview()
    }
    
    @objc func didTapped(sender:UIButton){
        if self.canvas.getSelectedModeStatus(){
            print("button tapped")
        }
    }
    
    public func showButton(){
        self.button.isHidden = false
    }
    
    public func hideButton(){
        self.button.isHidden = true
    }
}
