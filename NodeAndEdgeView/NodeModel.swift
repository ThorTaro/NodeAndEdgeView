//
//  NodeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class NodeModel{
    private var position:CGPoint
    
    init(position:CGPoint){
        self.position = position
    }
    
    public func getPosition() -> CGPoint{
        return self.position
    }
    
    public func setPosition(position:CGPoint){
        self.position = position
    }
}
