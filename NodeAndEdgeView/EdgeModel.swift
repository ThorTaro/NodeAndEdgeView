//
//  EdgeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class EdgeModel:Equatable, Hashable{
    static func == (lhs: EdgeModel, rhs: EdgeModel) -> Bool {
        return (lhs.parentNode == rhs.parentNode && lhs.childNode == rhs.childNode) || (lhs.parentNode == rhs.childNode && lhs.childNode == rhs.parentNode)
        // CAUTION
        // 単純にEdgeの重複を避けるだけならこれでもいいんだけど，多分これだとparentNodeと一緒にchildNodeも連動して消すって機能は実現しにくいんじゃないかなと思う
        // parentNodeを中心側から(?)って決めておかないと意味わかんないことになると思う
    }
    
    private weak var parentNode:NodeModel?
    private weak var childNode:NodeModel?
    
    var hashValue:Int{
        return self.parentNode.hashValue ^ self.childNode.hashValue
    }
    
    init(parentNode:NodeModel?, childNode:NodeModel?) {
        self.parentNode = parentNode
        self.childNode = childNode
    }
    
    public func getNodePair() -> (parentNode:NodeModel?, childNode:NodeModel?){
        return (self.parentNode, self.childNode)
    }
    
    public func getStatus() -> (parentNode:NodeModel?,childNode:NodeModel?){
        return (self.parentNode, self.childNode)
    }
}
