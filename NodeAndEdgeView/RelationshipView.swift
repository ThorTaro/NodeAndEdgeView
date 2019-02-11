//
//  TEST_EdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/04.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class RelationshipView:CAShapeLayer{
    private weak var srcWordView:AbstractWordView?
    private weak var dstWordView:AbstractWordView?
    
    private var RelationshipPath = UIBezierPath()
    private let RelationshipWidth:CGFloat = 10.0
    
    required init(srcWordView:AbstractWordView?, dstWordView:AbstractWordView?) {
        self.srcWordView = srcWordView
        self.dstWordView = dstWordView
        super.init()
        self.createPath()
        self.createLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createPath(){
        self.RelationshipPath.removeAllPoints()
        guard let unwrappedScrWordView = self.srcWordView, let unwrappedDstWordView = self.dstWordView else{
            return
        }
        
        if unwrappedScrWordView.center.x == unwrappedDstWordView.center.x{
            let originY:CGFloat = min(unwrappedScrWordView.center.y, unwrappedDstWordView.center.y)
            self.RelationshipPath = UIBezierPath(rect: CGRect(x: unwrappedScrWordView.center.x - self.RelationshipWidth/2,
                                                      y: originY,
                                                      width: self.RelationshipWidth,
                                                      height: CGFloat(fabsf(Float(unwrappedScrWordView.center.y - unwrappedDstWordView.center.y)))))
            
        }else if unwrappedScrWordView.center.y == unwrappedDstWordView.center.y{
            let originX:CGFloat = min(unwrappedScrWordView.center.x, unwrappedDstWordView.center.x)
            self.RelationshipPath = UIBezierPath(rect: CGRect(x: originX,
                                                      y: unwrappedScrWordView.center.y - self.RelationshipWidth/2,
                                                      width: CGFloat(fabsf(Float(unwrappedScrWordView.center.x - unwrappedDstWordView.center.x))),
                                                      height: self.RelationshipWidth))
        }else{
            let m:CGFloat = (unwrappedScrWordView.center.y - unwrappedDstWordView.center.y)/(unwrappedScrWordView.center.x - unwrappedDstWordView.center.x)
            let m_p:CGFloat = (-1)/m
            
            let delta:CGFloat = sqrt(pow(self.RelationshipWidth/2, 2.0)/(pow(m_p, 2.0) + 1.0))
            self.RelationshipPath.move(to: CGPoint(x: unwrappedScrWordView.center.x + delta,
                                           y: m_p * (unwrappedScrWordView.center.x + delta) + unwrappedScrWordView.center.y - m_p * unwrappedScrWordView.center.x))
            self.RelationshipPath.addLine(to: CGPoint(x: unwrappedDstWordView.center.x + delta,
                                              y: m_p * (unwrappedDstWordView.center.x + delta) + unwrappedDstWordView.center.y - m_p * unwrappedDstWordView.center.x))
            self.RelationshipPath.addLine(to: CGPoint(x: unwrappedDstWordView.center.x - delta,
                                              y: m_p * (unwrappedDstWordView.center.x - delta) + unwrappedDstWordView.center.y - m_p * unwrappedDstWordView.center.x))
            self.RelationshipPath.addLine(to: CGPoint(x: unwrappedScrWordView.center.x - delta,
                                              y: m_p * (unwrappedScrWordView.center.x - delta) + unwrappedScrWordView.center.y - m_p * unwrappedScrWordView.center.x))
            self.RelationshipPath.close()
        }
    }
    
    public func createLayer(){
        self.fillColor = UIColor.lightGray.cgColor
        self.path = self.RelationshipPath.cgPath
    }
    
    public func removeRelationshipView(){
        self.RelationshipPath.removeAllPoints()
        self.removeFromSuperlayer()
    }

}
