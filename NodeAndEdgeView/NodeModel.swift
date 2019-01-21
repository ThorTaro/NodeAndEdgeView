//
//  NodeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class NodeModel:Equatable, Hashable{
    private let id = NSUUID()
    private var isSelected:Bool = false
    
    internal var hashValue: Int{
        return self.id.hashValue
    }
    
    static func == (lhs: NodeModel, rhs: NodeModel) -> Bool {
        return lhs.id.isEqual(rhs.id)
    }
    
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
    
    public func selected(bool:Bool){
        self.isSelected = bool
    }
    
    public func getID() -> String{
        return self.id.uuidString
    }
    
    public func getStatus() -> Bool{
        return self.isSelected
    }
    
}
