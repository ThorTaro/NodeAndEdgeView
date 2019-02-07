//
//  TEST_EdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/04.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeView:CAShapeLayer{
    private weak var parentNodeView:AbstractNodeView?
    private weak var childeNodeView:AbstractNodeView?
    
    private var EdgePath = UIBezierPath()
    private let EdgeWidth:CGFloat = 10.0
    
    required init(parentNodeView:AbstractNodeView?, childeNodeView:AbstractNodeView?) {
        self.parentNodeView = parentNodeView
        self.childeNodeView = childeNodeView
        super.init()
        self.createPath()
        self.createLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createPath(){
        self.EdgePath.removeAllPoints()
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childeNodeView else{
            print("Unwrap Failed")
            return
        }
        
        if unwrappedParentNodeView.center.x == unwrappedChildNodeView.center.x{
            let originY:CGFloat = min(unwrappedParentNodeView.center.y, unwrappedChildNodeView.center.y)
            self.EdgePath = UIBezierPath(rect: CGRect(x: unwrappedParentNodeView.center.x - self.EdgeWidth/2,
                                                      y: originY,
                                                      width: self.EdgeWidth,
                                                      height: CGFloat(fabsf(Float(unwrappedParentNodeView.center.y - unwrappedChildNodeView.center.y)))))
            
        }else if unwrappedParentNodeView.center.y == unwrappedChildNodeView.center.y{
            let originX:CGFloat = min(unwrappedParentNodeView.center.x, unwrappedChildNodeView.center.x)
            self.EdgePath = UIBezierPath(rect: CGRect(x: originX,
                                                      y: unwrappedParentNodeView.center.y - self.EdgeWidth/2,
                                                      width: CGFloat(fabsf(Float(unwrappedParentNodeView.center.x - unwrappedChildNodeView.center.x))),
                                                      height: self.EdgeWidth))
        }else{
            let m:CGFloat = (unwrappedParentNodeView.center.y - unwrappedChildNodeView.center.y)/(unwrappedParentNodeView.center.x - unwrappedChildNodeView.center.x)
            let m_p:CGFloat = (-1)/m
            
            let delta:CGFloat = sqrt(pow(self.EdgeWidth/2, 2.0)/(pow(m_p, 2.0) + 1.0))
            self.EdgePath.move(to: CGPoint(x: unwrappedParentNodeView.center.x + delta,
                                           y: m_p * (unwrappedParentNodeView.center.x + delta) + unwrappedParentNodeView.center.y - m_p * unwrappedParentNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedChildNodeView.center.x + delta,
                                              y: m_p * (unwrappedChildNodeView.center.x + delta) + unwrappedChildNodeView.center.y - m_p * unwrappedChildNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedChildNodeView.center.x - delta,
                                              y: m_p * (unwrappedChildNodeView.center.x - delta) + unwrappedChildNodeView.center.y - m_p * unwrappedChildNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedParentNodeView.center.x - delta,
                                              y: m_p * (unwrappedParentNodeView.center.x - delta) + unwrappedParentNodeView.center.y - m_p * unwrappedParentNodeView.center.x))
            self.EdgePath.close()
        }
    }
    
    public func createLayer(){
        self.fillColor = UIColor.lightGray.cgColor
        self.path = self.EdgePath.cgPath
    }
    
    public func removeEdgeView(){
        self.EdgePath.removeAllPoints()
        self.removeFromSuperlayer()
    }

}
