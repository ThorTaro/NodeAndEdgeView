//
//  EdgeMapModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/21.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

struct RelationshipViewModel {
    private var relationships = [RelationshipModel]()
    
    mutating func addRelationship(newRelationship:RelationshipModel) -> Bool{
        if !self.relationships.contains(newRelationship){
            self.relationships.append(newRelationship)
            return true
        }else{
            print("This edge is already created")
            return false
        }
    }
    
    mutating func removeRelationships(relationships:[RelationshipModel]){
        for relationship in relationships{
            if let i = self.relationships.index(of:relationship){
                self.relationships.remove(at: i)
            }
        }
    }
    
    public func getAllRelationships(){
        print("-------All Edge Status-------")
        for relationship in self.relationships{
            print("Parent ID:", relationship.getStatus().srcWordModel?.getID() ?? "None")
            print("Child ID:", relationship.getStatus().dstWordModel?.getID() ?? "None")
        }
        print("--------------")
    }
    
    public func searchTargetRelationships(containedWordModel:WordModel) -> [RelationshipModel]{
        var result = [RelationshipModel]()
        for relationship in self.relationships{
            if let unwrappedParentNode = relationship.getRelationshipPair().srcWordModel, unwrappedParentNode == containedWordModel{
                result.append(relationship)
            }else if let unwrappedChildNode = relationship.getRelationshipPair().dstWordModel, unwrappedChildNode == containedWordModel{
                result.append(relationship)
            }
        }
        return result
    }
}
