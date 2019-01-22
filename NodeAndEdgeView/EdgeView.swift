//
//  EdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/22.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeView:CAShapeLayer{
    private weak var parentNodeView:NodeView?
    private weak var childNodeView:NodeView?
    
    init(parentNodeView:NodeView?, childNodeView:NodeView?) {
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
        
        let edge = UIBezierPath()
        edge.move(to: unwrappedParentNodeView.center)
        edge.addLine(to: unwrappedChildNodeView.center)
        edge.close()
        self.lineWidth = 10.0
        self.strokeColor = UIColor.orange.cgColor
        self.path = edge.cgPath
    }
}
