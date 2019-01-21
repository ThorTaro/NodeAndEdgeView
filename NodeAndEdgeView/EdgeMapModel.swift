//
//  EdgeMapModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

struct EdgeMapModel {
    private var edges = [EdgeModel]()
    
    mutating func addEdge(newEdge:EdgeModel){
        self.edges.append(newEdge)
    }
}
