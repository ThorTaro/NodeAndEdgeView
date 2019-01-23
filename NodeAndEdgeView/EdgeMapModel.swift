//
//  EdgeMapModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

struct EdgeMapModel {
    private var edges = [EdgeModel](){
        didSet{
            print("New edge appended")
        }
    }
    
    mutating func addEdge(newEdge:EdgeModel) -> Bool{
        if !self.edges.contains(newEdge){
            self.edges.append(newEdge)
            return true
        }else{
            print("This edge is already created")
            return false
        }
    }
    
    public func getAllEdges(){
        print("-------All Edge Status-------")
        for edge in self.edges{
            print("Parent ID:", edge.getStatus().parentNode?.getID() ?? "None")
            print("Child ID:", edge.getStatus().childNode?.getID() ?? "Node")
        }
        print("--------------")
    }
    
    public func searchEdges(containedNode:NodeModel) -> [EdgeModel]{
        var resultEdges = [EdgeModel]()
        for edge in self.edges{
            if let unwrappedParentNode = edge.getNodePair().parentNode, unwrappedParentNode == containedNode{
                resultEdges.append(edge)
            }else if let unwrappedChildNode = edge.getNodePair().childNode, unwrappedChildNode == containedNode{
                resultEdges.append(edge)
            }
        }
        return resultEdges
    }
}
