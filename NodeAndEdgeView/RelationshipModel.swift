//
//  EdgeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class RelationshipModel:Equatable, Hashable{
    static func == (lhs: RelationshipModel, rhs: RelationshipModel) -> Bool {
        return (lhs.scrWordModel == rhs.scrWordModel && lhs.dstWordModel == rhs.dstWordModel) || (lhs.scrWordModel == rhs.dstWordModel && lhs.dstWordModel == rhs.scrWordModel)
    }
    
    private weak var scrWordModel:WordModel?
    private weak var dstWordModel:WordModel?
    
    var hashValue:Int{
        return self.scrWordModel.hashValue ^ self.dstWordModel.hashValue
    }
    
    init(scrWordModel:WordModel?, dstWordModel:WordModel?) {
        self.scrWordModel = scrWordModel
        self.dstWordModel = dstWordModel
    }
    
    public func getRelationshipPair() -> (srcWordModel:WordModel?, dstWordModel:WordModel?){
        return (self.scrWordModel, self.dstWordModel)
    }
    
    public func getStatus() -> (srcWordModel:WordModel?,dstWordModel:WordModel?){
        return (self.scrWordModel, self.dstWordModel)
    }
}
