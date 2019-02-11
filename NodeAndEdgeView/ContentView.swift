//
//  Container.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ContentView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.drawGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGrid(){
        let gridLayer = CAShapeLayer()
        let containerWidth = Int(self.frame.width)
        let containerHeight = Int(self.frame.height)
        let horizonGap = containerWidth / 50
        let verticalGap = containerHeight / 50
        let gridPath = UIBezierPath()
        
        for i in 0...50{
            gridPath.move(to: CGPoint(x: i * horizonGap, y: 0))
            gridPath.addLine(to: CGPoint(x: i * horizonGap, y: containerHeight))
            gridPath.move(to: CGPoint(x: 0, y: i * verticalGap))
            gridPath.addLine(to: CGPoint(x: containerWidth, y: i * verticalGap))
        }
        
        gridLayer.strokeColor = UIColor.lightGray.cgColor
        gridLayer.lineWidth = 1
        gridLayer.path = gridPath.cgPath
        self.layer.addSublayer(gridLayer)
    }
}
