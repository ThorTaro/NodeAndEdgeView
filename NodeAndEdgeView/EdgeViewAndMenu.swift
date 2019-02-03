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
    private unowned var model:EdgeModel
    private weak var parentNodeView:AbstractNodeView?
    private weak var childNodeView:AbstractNodeView?
    private var edgePath = UIBezierPath()
    private var edgeLayer = CAShapeLayer()
    
    private var button:UIButton = {
        let button = UIButton()
            button.frame.size = CGSize(width: 30, height: 30)
            button.backgroundColor = .clear
            button.setImage(UIImage(named: "DeleteIcon"), for: .normal)
        return button
    }()
    
    required init(canvas:CanvasView, edge:EdgeModel, parentNodeView:AbstractNodeView?, childNodeView:AbstractNodeView?) {
        self.canvas = canvas
        self.model = edge
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
        let basePositions = self.setStartPositionAndEndPosition()
        
        self.edgePath = self.makeRectPath(parentPosition: basePositions.startPosition, childPosition: basePositions.endPosition, lineWidth: 30)
    }
    
    private func setStartPositionAndEndPosition() -> (startPosition:CGPoint, endPosition:CGPoint){
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childNodeView else {
            print("Edge drawing failed")
            return (startPosition:CGPoint.zero, endPosition:CGPoint.zero)
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
        
        return (startPosition:startPosition, endPosition:endPosition)
    }
    
    private func makeRectPath(parentPosition:CGPoint, childPosition:CGPoint, lineWidth:CGFloat) -> UIBezierPath{
        let path = UIBezierPath()
        let halfWidth:CGFloat = lineWidth/2
        if parentPosition.x == childPosition.x{
            path.move(to: CGPoint(x: parentPosition.x + halfWidth, y: parentPosition.y))
            path.addLine(to: CGPoint(x: childPosition.x + halfWidth, y: childPosition.y))
            path.addLine(to: CGPoint(x: childPosition.x - halfWidth, y: childPosition.y))
            path.addLine(to: CGPoint(x: parentPosition.x - halfWidth, y: parentPosition.y))
            path.close()
        }else if parentPosition.y == childPosition.y{
            path.move(to: CGPoint(x: parentPosition.x, y: parentPosition.y + halfWidth + 1))
            path.move(to: CGPoint(x: childPosition.x, y: childPosition.y + halfWidth + 1))
            path.move(to: CGPoint(x: childPosition.x, y: childPosition.y - halfWidth * 2 + 1))
            path.move(to: CGPoint(x: parentPosition.x, y: parentPosition.y - halfWidth * 2 + 1))
            path.close()
        }else{
            let m:CGFloat = (parentPosition.y - childPosition.y)/(parentPosition.x - childPosition.x)
            let m_p:CGFloat = -1/m
            let delta:CGFloat = sqrt(pow(halfWidth, 2.0)/(pow(m_p, 2.0) + 1))
            
            path.move(to: CGPoint(x: parentPosition.x + delta, y: m_p * (parentPosition.x + delta) + parentPosition.y - m_p * parentPosition.x
            ))
            path.addLine(to: CGPoint(x: childPosition.x + delta, y: m_p * (childPosition.x + delta) + childPosition.y - m_p * childPosition.x))
            path.addLine(to: CGPoint(x: childPosition.x - delta, y: m_p * (childPosition.x - delta) + childPosition.y - m_p * childPosition.x))
            path.addLine(to: CGPoint(x: parentPosition.x - delta, y: m_p * (parentPosition.x - delta) + parentPosition.y - m_p * parentPosition.x))
            path.addLine(to: CGPoint(x: parentPosition.x + delta, y: m_p * (parentPosition.x + delta) + parentPosition.y - m_p * parentPosition.x))
            path.close()
        }
        return path
    }
    
    private func createLayer(){
        self.edgeLayer.fillColor = UIColor.lightGray.cgColor
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
        self.backgroundColor = .blue
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
        self.edgePath.removeAllPoints()
        self.edgeLayer.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    
    @objc func didTapped(sender:UIButton){
        if self.canvas.getSelectedModeStatus(){
            self.canvas.EdgeViewWillDelete(edge: self.model)
        }
    }
    
    public func showButton(){
        self.button.isHidden = false
    }
    
    public func hideButton(){
        self.button.isHidden = true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
}
