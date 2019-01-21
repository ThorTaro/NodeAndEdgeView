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
    
    public func getNodes() -> [NodeModel]{
        return self.nodes
    }
    
    public func getNodesStatus(){
        for node in nodes{
            print("\(node.getID())")
            let bool = node.getStatus()
            print("Status:\(bool)")
        }
    }
    
    public func searchSelectedNode() -> NodeModel?{
        var selectedNode:NodeModel?
        for node in self.nodes where node.getStatus(){
            selectedNode = node
        }
        return selectedNode
    }
}
