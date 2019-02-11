//
//  CanvasView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

protocol nodeControlDelegate:NSObjectProtocol{
    func createNodeInView(view:ScrollView, position:CGPoint)
    func nodeSelectedInView(view:ScrollView, selectedNode:WordModel?)
    func isEdgeLoopedInView(view:ScrollView, childNode:WordModel) -> Bool
    func createEdgeInView(view:ScrollView, childNode:WordModel)
    func nodeMovedInView(view:ScrollView, movedNode:WordModel)
    func nodeDeletedInView(view:ScrollView ,node:WordModel)
    func edgeDeletedInView(view:ScrollView, edge:RelationshipModel)
    func edgeSelectedInView(view:ScrollView, edge:RelationshipModel)
}

// TODO
// protocolをView別に分けて可読性をあげようと思う
protocol WordControlDelegate:NSObjectProtocol{
    
}

protocol RelationshipControlDelegate:NSObjectProtocol{
    
}

// TODO
// ModeをEnumで管理しようと思う
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
    
    private var nodeSelectedMode:Bool = false // 準備が整い次第消す
    private var edgeCreationMode:Bool = false // 準備が整い次第消す
    
    public weak var nodeController:nodeControlDelegate?
    
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
    
    public func initScrollView(frame:CGRect){
        self.frame = frame
        self.contentOffset = CGPoint(x: self.contentView.center.x - frame.width / 2,
                                     y: self.contentView.center.y - frame.height / 2)
    }
    
    public func getContentViewMaxSize() -> CGRect{
        return self.contentViewMaxSize
    }
    
    @objc func longPressHandler(recognizer: UILongPressGestureRecognizer){
        if let unwrappedNodeController = self.nodeController,!self.getWordViewSelectedMode(),recognizer.state == .began{
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
            unwrappedNodeController.createNodeInView(view: self, position: newWordViewPosition)
        }
    }
    
    private func relationshipViewTapped(selectedRelationshipModel:RelationshipModel){
        guard let unwrappedNodeController = self.nodeController else{
            return
        }
        unwrappedNodeController.edgeSelectedInView(view: self, edge: selectedRelationshipModel)
    }
    
    public func createWordView(newWordModel:WordModel){
        let newWordView = WordView(targetView: self, wordModel: newWordModel)
        self.wordModelAndViewDict[newWordModel] = newWordView
        self.contentView.addSubview(newWordView)
        self.contentView.bringSubviewToFront(newWordView)
    }
    
    public func deleteWordView(selectedWordModel:WordModel){
        if let unwrappedWordView = self.wordModelAndViewDict[selectedWordModel]{
            unwrappedWordView.removeWordView()
            self.wordModelAndViewDict.removeValue(forKey: selectedWordModel)
        }
        
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeDeletedInView(view:self, node: selectedWordModel)
        }
    }
    
    public func deleteRelationshipViews(relationshipModels:[RelationshipModel]){
        for relationshipModel in relationshipModels{
            guard let unwrappedRelationshipView = self.relationshipModelAndViewDict[relationshipModel] else {continue}
            unwrappedRelationshipView.removeRelationshipView()
            self.relationshipModelAndViewDict.removeValue(forKey: relationshipModel)
        }
        
    }
    
    public func wordViewMoved(movedWordModel:WordModel){
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeMovedInView(view: self, movedNode: movedWordModel)
        }
    }
    
    public func wordViewSelected(selectedWordModel:WordModel, to:Bool){
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeSelectedInView(view: self, selectedNode: selectedWordModel)
            self.toggleWordViewState(targetWordModel: selectedWordModel, isSelected: to)
        }
    }
    
    public func toggleWordSelectedMode(bool:Bool){ // 特に必要ない引数ラベルなので後でアンダースコアで消す
        self.nodeSelectedMode = bool
    }
    
    public func toggleWordViewState(targetWordModel:WordModel, isSelected:Bool){
        if let unwrappedNodeViewDict = self.wordModelAndViewDict[targetWordModel]{
            unwrappedNodeViewDict.toggleWordViewColor(isSelected: isSelected)
        }
    }
    
    public func getWordViewSelectedMode() -> Bool{ // ここ気持ち悪い enumで何とかしよう
        return self.nodeSelectedMode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeSelectedInView(view: self, selectedNode: nil)
        }
    }
    
    public func isRelationshipLooped(relationshipWith:WordModel) -> Bool{
        guard let unwrappedNodeController = self.nodeController else{
            return true
        }
        return unwrappedNodeController.isEdgeLoopedInView(view: self, childNode: relationshipWith)
    }
    
    public func createRelationship(with:WordModel){
        if let unwrappedNodeController = self.nodeController, self.getRelationshipCreationModeStatus(){
            unwrappedNodeController.createEdgeInView(view: self, childNode: with)
            unwrappedNodeController.nodeSelectedInView(view: self, selectedNode: nil)
        }
    }
    
    public func toggleRelationshipCreationMode(bool:Bool){ // 後でラベルをアンダースコアで消す
        self.edgeCreationMode = bool
    }
    
    private func getRelationshipCreationModeStatus() -> Bool{ // 気持ち悪いのでenumで何とかする
        return self.edgeCreationMode
    }
    
    public func createRelationshipView(src:WordModel, with:WordModel, newRelationshipModel:RelationshipModel){
        let newRelationshipView = RelationshipView(srcWordView: self.wordModelAndViewDict[src], dstWordView: self.wordModelAndViewDict[with])
        self.contentView.layer.insertSublayer(newRelationshipView, at: 1)
        self.relationshipModelAndViewDict[newRelationshipModel] = newRelationshipView
    }
    
    public func moveRelationshipView(relationshipModels:[RelationshipModel]){
        for relationshipModel in relationshipModels{
            guard let unwrappedRelationshipView = self.relationshipModelAndViewDict[relationshipModel] else {continue}
            unwrappedRelationshipView.createPath()
            unwrappedRelationshipView.createLayer()
        }
    }
    
    public func setWordInWordView(wordModel:WordModel, newWord:String){
        if let unwrappedWordView = self.wordModelAndViewDict[wordModel]{
            unwrappedWordView.setText(text: newWord)
        }
    }
    
    public func keepAncestorWordViewCenter(wordModel:WordModel){
        guard let ancestorWordView = self.wordModelAndViewDict[wordModel] else {
            return
        }
        guard let unwrappedNodeController = self.nodeController else {
            return
        }
        ancestorWordView.frame.origin = CGPoint(x: self.contentViewMaxSize.width/2 - ancestorWordView.getViewCenterPosition().x,
                                                y: self.contentViewMaxSize.height/2 - ancestorWordView.getViewCenterPosition().y)
        unwrappedNodeController.nodeMovedInView(view: self, movedNode: wordModel)
    }
    
    public func createAncestorWordView(wordModel:WordModel){
        let newWordView = ThemeWordView(targetView: self, wordModel: wordModel)
        self.wordModelAndViewDict[wordModel] = newWordView
        self.contentView.addSubview(newWordView)
        self.contentView.bringSubviewToFront(newWordView)
    }
    
    public func isAncestor(node:WordModel) -> Bool{ // この関数使われてない疑惑
        guard let unwrappedNodeView = self.wordModelAndViewDict[node] else {
            return false
        }
        return type(of: unwrappedNodeView) === ThemeWordView.self
    }
    
    public func relationshipViewTappedDelete(edge:RelationshipModel){
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.edgeDeletedInView(view: self, edge: edge)
        }
    }
}

extension ScrollView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.contentView
    }
}
