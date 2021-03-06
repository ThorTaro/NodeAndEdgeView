//
//  NodeMapModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

struct WordViewModel {
    private var wordModels = [WordModel]()
    
    mutating func appendNewWordModel(position:CGPoint) -> WordModel{
        let newWordModel = WordModel(position: position)
        self.wordModels.append(newWordModel)
        return newWordModel
    }
    
    mutating func removeWordModel(targetWordModel:WordModel){
        if let i = self.wordModels.index(of:targetWordModel){
            self.wordModels.remove(at: i)
        }
    }
    
    public func getAllWordMdels() -> [WordModel]{
        return self.wordModels
    }
    
    public func getAllWordModelStatus(){
        print("-------All Node Status-------")
        for wordModel in wordModels{
            print("Node ID:\(wordModel.getID())")
            print("Text :\(wordModel.getWord())")
            let bool = wordModel.getIsSelectedStatus()
            print("isSelected:\(bool)")
        }
        print("--------------")
    }
    
    public func getSelectedWordModel() -> WordModel?{
        var resultWordModel:WordModel?
        for wordModel in self.wordModels where wordModel.getIsSelectedStatus(){
            resultWordModel = wordModel
        }
        return resultWordModel
    }
    
    public func getFirstCreatedWordModel() -> WordModel?{
        return self.wordModels.first
    }
    
    public func wordModelToThemeWord(targetWordModel:WordModel){
        if let i = self.wordModels.index(of:targetWordModel){
            self.wordModels[i].becomeThemeWord()
        }
    }
    
    public func getIsThemeWordStatus(targetWordModel:WordModel?) -> Bool{
        guard let targetWordModel = targetWordModel else{
            return false
        }
        
        if let i = self.wordModels.index(of:targetWordModel){
            return self.wordModels[i].getIsThemeWordStatus()
        }
        return false
    }
    
    public func updateWordModelPosition(targetWordModel:WordModel, newPosition:CGPoint){
        if let i = self.wordModels.index(of:targetWordModel){
            self.wordModels[i].setPosition(position: newPosition)
        }
    }
    
    public func getWordModelPosition(targetWordModel:WordModel) -> CGPoint{
        if let i = self.wordModels.index(of:targetWordModel){
            return self.wordModels[i].getPosition()
        }else{
            return CGPoint.zero
        }
    }
}
