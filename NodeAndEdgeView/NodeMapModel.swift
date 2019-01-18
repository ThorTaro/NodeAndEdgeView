//
//  NodeMapModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

struct NodeMapModel {
    private var nodes = [NodeModel]()
    
    mutating func addNode(position:CGPoint) -> NodeModel{
        let newNode = NodeModel(position: position)
        self.nodes.append(newNode)
        return newNode
    }
}
