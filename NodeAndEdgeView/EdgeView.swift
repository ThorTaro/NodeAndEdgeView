//
//  EdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/22.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeView:CAShapeLayer{
    private weak var parentNodeView:AbstractNodeView?
    private weak var childNodeView:AbstractNodeView?
    private var edge = UIBezierPath()
    
    init(parentNodeView:AbstractNodeView?, childNodeView:AbstractNodeView?) {
        self.parentNodeView = parentNodeView
        self.childNodeView = childNodeView
        super.init()
        self.drawEdge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawEdge(){
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childNodeView else {
            print("Edge drawing failed")
            return
        }
        
        self.edge.move(to: unwrappedParentNodeView.center)
        self.edge.addLine(to: unwrappedChildNodeView.center)
        self.edge.close()
        self.lineWidth = 10.0
        self.strokeColor = UIColor.lightGray.cgColor
        self.path = edge.cgPath
    }
    
    public func redrawEdge(){
        self.edge.removeAllPoints()
        self.drawEdge()
    }
    
    public func removeEdgeView(){
        self.removeFromSuperlayer()
    }
}
