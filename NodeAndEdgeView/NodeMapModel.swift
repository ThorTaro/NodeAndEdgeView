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
    
    mutating func deleteNode(node:NodeModel){
        if let i = self.nodes.index(of:node){
            self.nodes.remove(at: i)
            print("ID:\(node.getID()) deleted")
        }
    }
    
    public func getNodes() -> [NodeModel]{
        return self.nodes
    }
    
    public func getNodesStatus(){
        print("-------All Node Status-------")
        for node in nodes{
            print("Node ID:\(node.getID())")
            print("Text :\(node.getText())")
            let bool = node.getStatus()
            print("isSelected:\(bool)")
        }
        print("--------------")
    }
    
    public func searchSelectedNode() -> NodeModel?{
        var selectedNode:NodeModel?
        for node in self.nodes where node.getStatus(){
            selectedNode = node
        }
        return selectedNode
    }
    
    public func getAncestor() -> NodeModel?{
        return self.nodes.first
    }
    
    public func makeAncestor(ancestorNode:NodeModel){
        if let i = self.nodes.index(of:ancestorNode){
            self.nodes[i].becomeAncestor()
        }
    }
    
    public func isAncestor(node:NodeModel) -> Bool{
        if let i = self.nodes.index(of:node){
            return self.nodes[i].getAttribute()
        }
        return false
    }
}
