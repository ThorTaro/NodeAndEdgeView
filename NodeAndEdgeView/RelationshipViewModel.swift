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
        print("-------All Relationships-------")
        for relationship in self.relationships{
            print("SRC ID:", relationship.getStatus().srcWordModel?.getID() ?? "None")
            print("DST ID:", relationship.getStatus().dstWordModel?.getID() ?? "None")
        }
        print("--------------")
    }
    
    public func getRelatedRelationships(targetWordModel:WordModel) -> [RelationshipModel]{
        var result = [RelationshipModel]()
        for relationship in self.relationships{
            if let scrWordModel = relationship.getRelationshipPair().srcWordModel, scrWordModel == targetWordModel{
                result.append(relationship)
            }else if let dstWordModel = relationship.getRelationshipPair().dstWordModel, dstWordModel == targetWordModel{
                result.append(relationship)
            }
        }
        return result
    }
    
    public func getSelectedRelationshipModel() -> RelationshipModel?{
        var resultRelationshipModel:RelationshipModel?
        for relationship in self.relationships where relationship.getIsSelectedStatus(){
            resultRelationshipModel = relationship
        }
        return resultRelationshipModel
    }
}
