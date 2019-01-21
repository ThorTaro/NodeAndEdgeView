//
//  EdgeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeModel{
    private weak var parentNode:NodeModel?
    private weak var childNode:NodeModel?
    
    init(parentNode:NodeModel?, childNode:NodeModel?) {
        self.parentNode = parentNode
        self.childNode = childNode
    }
    
    public func setParentNode(parentNode:NodeModel){
        self.parentNode = parentNode
    }
    
    public func setChildNode(childNode:NodeModel){
        self.childNode = childNode
    }
}
