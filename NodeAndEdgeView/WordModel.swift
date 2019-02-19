//
//  NodeModel.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/19.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class WordModel:Equatable, Hashable{
    private let id = NSUUID()
    private var word = String()
    private var isSelected:Bool = false
    private var isThemeWord:Bool = false
    
    internal var hashValue: Int{
        return self.id.hashValue
    }
    
    static func == (lhs: WordModel, rhs: WordModel) -> Bool {
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
    
    public func toggleIsSelected(bool:Bool){
        self.isSelected = bool
    }
    
    public func getID() -> String{
        return self.id.uuidString
    }
    
    public func getIsSelectedStatus() -> Bool{
        return self.isSelected
    }
    
    public func setWord(newWord:String){
        self.word = newWord
    }
    
    public func getWord() -> String{
        return self.word
    }
    
    public func becomeThemeWord(){
        self.isThemeWord = true
    }
    
    public func getIsThemeWordStatus() -> Bool{
        return self.isThemeWord
    }
}
