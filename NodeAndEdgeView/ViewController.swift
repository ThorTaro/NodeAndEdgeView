//
//  ViewController.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let canvas = ScrollView()
    private var nodeMap = WordViewModel()
    private var edgeMap = RelationshipViewModel()
    private var menuView = MenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
        self.setupMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAncestor()
    }
    
    override func viewDidLayoutSubviews() {
        self.canvas.initScrollView(frame:self.view.bounds)
    }
    
    private func setupCanvas(){
        self.view.backgroundColor = .white
        self.canvas.nodeController = self
        self.view.addSubview(self.canvas)
    }
    
    private func setupMenu(){
        self.menuView = MenuView(frame: CGRect(x: self.view.bounds.width,
                                               y: self.view.frame.origin.y,
                                               width: self.view.bounds.width / 4,
                                               height: self.view.bounds.height / 2))
        self.menuView.sideMenuController = self
        self.view.addSubview(self.menuView)
    }
    
    private func setAncestor(){
        let newAncestorNode = self.nodeMap.appendNewWordModel(position: CGPoint.zero)
        self.nodeMap.BecomeWordModelToThemeWord(targetWordModel: newAncestorNode)
        self.canvas.createAncestorWordView(wordModel: newAncestorNode)
        guard let ancestorNodeModel = self.nodeMap.getFirstCreatedWordModel() else {
            return
        }
        self.canvas.keepAncestorWordViewCenter(wordModel: ancestorNodeModel)
        self.nodeSelectedInView(view: self.canvas, selectedNode: ancestorNodeModel)
        self.tappedTextEdit()
    }
}

extension ViewController:nodeControlDelegate{
    func edgeSelectedInView(view: ScrollView, edge: RelationshipModel) {
        print("Edge tapped")
    }
    
    func edgeDeletedInView(view: ScrollView, edge: RelationshipModel) {
        let deleteEdgeModel:[RelationshipModel] = [edge]
        self.edgeMap.removeRelationships(relationships: deleteEdgeModel)
        view.deleteRelationshipViews(relationshipModels: deleteEdgeModel)
        self.nodeSelectedInView(view: self.canvas, selectedNode: nil)
    }
    
    func nodeDeletedInView(view: ScrollView, node: WordModel) {
        if let unwrappedSelectedNode = self.nodeMap.getSelectedWordModel(){
            unwrappedSelectedNode.toggleIsSelected(bool: false)
            self.menuView.hideMenu()
            view.toggleRelationshipCreationMode(bool: false)
            view.toggleWordSelectedMode(bool: false)
            let relatedEdges = self.edgeMap.searchTargetRelationships(containedWordModel: unwrappedSelectedNode)
            view.deleteRelationshipViews(relationshipModels: relatedEdges)
            self.edgeMap.removeRelationships(relationships: relatedEdges)
        }
        self.nodeMap.deleteWordModel(targetWordModel: node)
        self.nodeMap.getAllWordModelStatus()
        self.edgeMap.getAllRelationships()
    }
    
    func nodeMovedInView(view: ScrollView, movedNode: WordModel) {
        view.moveRelationshipView(relationshipModels: self.edgeMap.searchTargetRelationships(containedWordModel: movedNode))
    }
    
    func createEdgeInView(view: ScrollView, childNode: WordModel) {
        if let unwrappedParentNode = self.nodeMap.getSelectedWordModel(){
            let newEdge = RelationshipModel(scrWordModel: unwrappedParentNode, dstWordModel: childNode)
            if self.edgeMap.addRelationship(newRelationship: newEdge){
                self.edgeMap.getAllRelationships()
                view.createRelationshipView(src: unwrappedParentNode, with: childNode, newRelationshipModel: newEdge)
            }
        }else{
            print("Edge creation failed")
        }
    }
    
    func isEdgeLoopedInView(view: ScrollView, childNode: WordModel) -> Bool {
        if let unwrappedParentNode = self.nodeMap.getSelectedWordModel(), unwrappedParentNode.getID() == childNode.getID(){
            return true
        }
        return false
    }
    
    func nodeSelectedInView(view: ScrollView, selectedNode: WordModel?) {
        if let unwrappedSelectedNode = selectedNode{
            unwrappedSelectedNode.toggleIsSelected(bool: true)
            self.menuView.showMenu(isAncestor: self.nodeMap.getIsThemeWordStatus(targetWordModel: unwrappedSelectedNode))
            self.nodeMap.getAllWordModelStatus()
            view.toggleWordSelectedMode(bool: true)
        }else{
            if let unwrappedSelectedNode = self.nodeMap.getSelectedWordModel(){
                unwrappedSelectedNode.toggleIsSelected(bool: false)
                self.menuView.hideMenu()
                self.nodeMap.getAllWordModelStatus()
                view.toggleWordSelectedMode(bool: false)
                view.toggleRelationshipCreationMode(bool: false)
                view.toggleWordViewState(targetWordModel: unwrappedSelectedNode, isSelected: false)
            }
        }
    }
    
    func createNodeInView(view: ScrollView, position: CGPoint) {
        let newNode = self.nodeMap.appendNewWordModel(position: position)
        view.createWordView(newWordModel: newNode)
    }
}

extension ViewController:MenuViewDelegate{
    func tappedTextEdit() {
        let AlertController = UIAlertController(title: "Text", message: "", preferredStyle: .alert)
        let OKAlertAction = UIAlertAction(title: "OK", style: .default, handler:{[weak AlertController, weak self](action) -> Void in
            guard let text = AlertController?.textFields?.first?.text else{
                return
            }
            
            guard let weakself = self else{
                return
            }
            
            guard let unwrappedSelectedNode = weakself.nodeMap.getSelectedWordModel() else{
                return
            }
            unwrappedSelectedNode.setWord(newWord: text)
            weakself.canvas.setWordInWordView(wordModel: unwrappedSelectedNode, newWord: text)
            weakself.nodeSelectedInView(view: weakself.canvas, selectedNode: nil)
        })
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self](action) -> Void in
            guard let weakself = self else{
                return
            }
            weakself.nodeSelectedInView(view: weakself.canvas, selectedNode: nil)
        })
        AlertController.addTextField{textField in
            textField.placeholder = "Text"
            textField.keyboardAppearance  = .dark
        }
        AlertController.addAction(OKAlertAction)
        AlertController.addAction(CancelAction)
        self.present(AlertController, animated: true, completion: nil)
    }
    
    func tappedDeleteNode() {
        if let unwrappedSelectedNode = self.nodeMap.getSelectedWordModel(){
            self.canvas.deleteWordView(selectedWordModel:unwrappedSelectedNode)
        }
    }
    
    func tappedCreateEdge() {
        self.canvas.toggleRelationshipCreationMode(bool: true)
    }
}
