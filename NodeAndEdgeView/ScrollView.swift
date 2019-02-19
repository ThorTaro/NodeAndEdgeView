//
//  CanvasView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit


protocol WordControlDelegate:NSObjectProtocol{
    func createWord(view:ScrollView, position:CGPoint)
    func wordSelected(view:ScrollView, selectedWord:WordModel?)
    func wordMoved(view:ScrollView, movedWord:WordModel, newPosition:CGPoint)
    func wordRemoved(view:ScrollView,targetWord:WordModel)
}

protocol RelationshipControlDelegate:NSObjectProtocol{
    func isRelationshipLooped(view:ScrollView, dst:WordModel) -> Bool
    func createRelationship(view:ScrollView, dst:WordModel)
    func relationshipRemoved(view:ScrollView, targetRelationships:[RelationshipModel])
    func relationshipSelected(view:ScrollView, targetRelationship:RelationshipModel?)
}

enum ModeType{
    case normal
    case wordSelected
    case relationshipCreation
    case ralationshipSelected
}

class ScrollView: UIScrollView{
    private var wordModelAndViewDict = [WordModel:AbstractWordView]()
    private var relationshipModelAndViewDict = [RelationshipModel:RelationshipView]()
    private let contentView = ContentView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: UIScreen.main.bounds.width * 5,
                                                      height: UIScreen.main.bounds.height * 5))
    private var contentViewMaxSize = CGRect.zero
    private var mode:ModeType = .normal
    
    private weak var wordDelegate:WordControlDelegate?
    private weak var relationshipDelegate:RelationshipControlDelegate?
    
    override func didMoveToSuperview() {
        self.minimumZoomScale = UIScreen.main.bounds.height / self.contentView.frame.height
        self.maximumZoomScale = 2.0
        self.backgroundColor = .black
        self.delegate = self
        self.addSubview(self.contentView)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
        self.contentViewMaxSize = self.contentView.bounds
    }
    
    public func initScrollView(frame:CGRect, delegate:ViewController){
        self.frame = frame
        self.contentOffset = CGPoint(x: self.contentView.center.x - frame.width / 2,
                                     y: self.contentView.center.y - frame.height / 2)
        self.wordDelegate = delegate
        self.relationshipDelegate = delegate
    }
    
    public func getContentViewMaxSize() -> CGRect{
        return self.contentViewMaxSize
    }
    
    @objc func longPressHandler(recognizer: UILongPressGestureRecognizer){
        if let wordDelegate = self.wordDelegate, self.mode == .normal ,recognizer.state == .began{
            let newWordViewPosition = CGPoint(x: recognizer.location(in: self.contentView).x,
                                              y: recognizer.location(in: self.contentView).y)
            for key in self.relationshipModelAndViewDict.keys{
                guard let relationshipView = self.relationshipModelAndViewDict[key] else{
                    continue
                }
                if relationshipView.path!.contains(newWordViewPosition){
                    self.relationshipViewTapped(selectedRelationshipModel: key)
                    return
                }
            }
            wordDelegate.createWord(view: self, position: newWordViewPosition)
        }
    }
    
    private func relationshipViewTapped(selectedRelationshipModel:RelationshipModel){
        guard let relationshipDelegate = self.relationshipDelegate else{
            return
        }
        relationshipDelegate.relationshipSelected(view: self, targetRelationship: selectedRelationshipModel)
    }
    
    public func createWordView(newWordModel:WordModel, position:CGPoint){
        let newWordView = WordView(targetView: self, wordModel: newWordModel, position:position)
        self.wordModelAndViewDict[newWordModel] = newWordView
        self.contentView.addSubview(newWordView)
        self.contentView.bringSubviewToFront(newWordView)
    }
    
    public func removeWordView(selectedWordModel:WordModel){
        if let wordView = self.wordModelAndViewDict[selectedWordModel]{
            wordView.removeWordView()
            self.wordModelAndViewDict.removeValue(forKey: selectedWordModel)
        }
    }
    
    public func removeRelationshipViews(relationshipModels:[RelationshipModel]){
        for relationshipModel in relationshipModels{
            guard let relationshipView = self.relationshipModelAndViewDict[relationshipModel] else {
                continue
            }
            relationshipView.removeRelationshipView()
            self.relationshipModelAndViewDict.removeValue(forKey: relationshipModel)
        }
    }
    
    public func wordViewMoved(movedWordModel:WordModel, newPosition:CGPoint){
        if let wordDelegate = self.wordDelegate{
            wordDelegate.wordMoved(view: self, movedWord: movedWordModel, newPosition: newPosition)
        }
    }
    
    public func wordViewSelected(selectedWordModel:WordModel, to:Bool){
        if let wordDelegate = self.wordDelegate{
            wordDelegate.wordSelected(view: self, selectedWord: selectedWordModel)
            self.toggleWordViewState(targetWordModel: selectedWordModel, isSelected: to)
        }
    }
    
    public func toggleWordViewState(targetWordModel:WordModel, isSelected:Bool){
        if let wordView = self.wordModelAndViewDict[targetWordModel]{
            wordView.toggleWordViewColor(isSelected: isSelected)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let wordDelegate = self.wordDelegate{
            wordDelegate.wordSelected(view: self, selectedWord: nil)
        }
        
        if let relationshipDelegate = self.relationshipDelegate, self.mode == .ralationshipSelected{
            relationshipDelegate.relationshipSelected(view: self, targetRelationship: nil)
        }
    }
    
    public func isRelationshipLooped(dst:WordModel) -> Bool{
        guard let relationshipDelegate = self.relationshipDelegate else{
            return true
        }
        return relationshipDelegate.isRelationshipLooped(view: self, dst: dst)
    }
    
    public func createRelationship(with:WordModel){
        if let wordDelegate = self.wordDelegate, let relationshipDelegate = self.relationshipDelegate{
            relationshipDelegate.createRelationship(view: self, dst: with)
            wordDelegate.wordSelected(view: self, selectedWord: nil)
        }
    }
    
    public func changeModeType(mode:ModeType){
        self.mode = mode
    }
    
    
    public func getModeStatus() -> ModeType{
        return self.mode
    }
    
    public func createRelationshipView(src:WordModel, dst:WordModel, newRelationshipModel:RelationshipModel){
        let newRelationshipView = RelationshipView(srcWordView: self.wordModelAndViewDict[src], dstWordView: self.wordModelAndViewDict[dst])
        self.contentView.layer.insertSublayer(newRelationshipView, at: 1)
        self.relationshipModelAndViewDict[newRelationshipModel] = newRelationshipView
    }
    
    public func moveRelationshipView(relationshipModels:[RelationshipModel]){
        for relationshipModel in relationshipModels{
            guard let relationshipView = self.relationshipModelAndViewDict[relationshipModel] else {
                continue
            }
            relationshipView.createPath()
            relationshipView.createLayer()
        }
    }
    
    public func setWordInWordView(wordModel:WordModel, newWord:String){
        if let wordView = self.wordModelAndViewDict[wordModel]{
            wordView.setText(text: newWord)
        }
    }
    
    public func keepThemeWordViewCenter(wordModel:WordModel){
        guard let themeWordView = self.wordModelAndViewDict[wordModel] else {
            return
        }
        guard let wordDelegate = self.wordDelegate else {
            return
        }
        themeWordView.frame.origin = CGPoint(x: self.contentViewMaxSize.width/2 - themeWordView.getViewCenterPosition().x,
                                                y: self.contentViewMaxSize.height/2 - themeWordView.getViewCenterPosition().y)
        wordDelegate.wordMoved(view: self, movedWord: wordModel, newPosition: self.frame.origin)
    }
    
    public func createThemeWordView(wordModel:WordModel, position:CGPoint){
        let newWordView = ThemeWordView(targetView: self, wordModel: wordModel, position:position)
        self.wordModelAndViewDict[wordModel] = newWordView
        self.contentView.addSubview(newWordView)
        self.contentView.bringSubviewToFront(newWordView)
    }
    
}

extension ScrollView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView
    }
}
