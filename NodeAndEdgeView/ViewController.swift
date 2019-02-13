//
//  ViewController.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let scrollview = ScrollView()
    private var wordViewModel = WordViewModel()
    private var ralationshipViewModel = RelationshipViewModel()
    private var menuView = MenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
        self.setupMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setTheme()
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollview.initScrollView(frame:self.view.bounds, delegate: self)
    }
    
    private func setupCanvas(){
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollview)
    }
    
    private func setupMenu(){
        self.menuView = MenuView(frame: CGRect(x: self.view.bounds.width,
                                               y: self.view.frame.origin.y,
                                               width: self.view.bounds.width / 4,
                                               height: self.view.bounds.height / 2))
        self.menuView.sideMenuController = self
        self.view.addSubview(self.menuView)
    }
    
    private func setTheme(){
        let newThemeWordModel = self.wordViewModel.appendNewWordModel(position: CGPoint.zero)
        self.wordViewModel.BecomeWordModelToThemeWord(targetWordModel: newThemeWordModel)
        self.scrollview.createThemeWordView(wordModel: newThemeWordModel, position: self.wordViewModel.getWordModelPosition(targetWordModel: newThemeWordModel))
        guard let themeWordModel = self.wordViewModel.getFirstCreatedWordModel() else {
            return
        }
        self.scrollview.keepThemeWordViewCenter(wordModel: themeWordModel)
        self.wordSelected(view: self.scrollview, selectedWord: themeWordModel)
        self.tappedTextEdit()
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
            
            guard let unwrappedSelectedNode = weakself.wordViewModel.getSelectedWordModel() else{
                return
            }
            unwrappedSelectedNode.setWord(newWord: text)
            weakself.scrollview.setWordInWordView(wordModel: unwrappedSelectedNode, newWord: text)
            weakself.wordSelected(view: weakself.scrollview, selectedWord: nil)
        })
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self](action) -> Void in
            guard let weakself = self else{
                return
            }
            weakself.wordSelected(view: weakself.scrollview, selectedWord: nil)
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
        if let unwrappedSelectedNode = self.wordViewModel.getSelectedWordModel(){
            self.scrollview.deleteWordView(selectedWordModel:unwrappedSelectedNode)
        }
    }
    
    func tappedCreateEdge() {
        self.scrollview.toggleRelationshipCreationMode(true)
    }
}

extension ViewController:WordControlDelegate{
    func createWord(view: ScrollView, position: CGPoint) {
        let newNode = self.wordViewModel.appendNewWordModel(position: position)
        view.createWordView(newWordModel: newNode, position: self.wordViewModel.getWordModelPosition(targetWordModel: newNode))
    }
    
    func wordSelected(view: ScrollView, selectedWord: WordModel?) {
        if let unwrappedSelectedNode = selectedWord{
            unwrappedSelectedNode.toggleIsSelected(bool: true)
            self.menuView.showMenu(isAncestor: self.wordViewModel.getIsThemeWordStatus(targetWordModel: unwrappedSelectedNode))
            self.wordViewModel.getAllWordModelStatus()
            view.toggleWordSelectedMode(true)
        }else{
            if let unwrappedSelectedNode = self.wordViewModel.getSelectedWordModel(){
                unwrappedSelectedNode.toggleIsSelected(bool: false)
                self.menuView.hideMenu()
                self.wordViewModel.getAllWordModelStatus()
                view.toggleWordSelectedMode(false)
                view.toggleRelationshipCreationMode(false)
                view.toggleWordViewState(targetWordModel: unwrappedSelectedNode, isSelected: false)
            }
        }
    }
    
    func wordMoved(view: ScrollView, movedWord: WordModel, newPosition: CGPoint) {
        self.wordViewModel.updateWordModelPosition(targetWordModel: movedWord, newPosition: newPosition)
        view.moveRelationshipView(relationshipModels: self.ralationshipViewModel.searchTargetRelationships(containedWordModel: movedWord))
    }

    
    func wordDeleted(view: ScrollView, targetWord: WordModel) {
        if let unwrappedSelectedNode = self.wordViewModel.getSelectedWordModel(){
            unwrappedSelectedNode.toggleIsSelected(bool: false)
            self.menuView.hideMenu()
            view.toggleRelationshipCreationMode(false)
            view.toggleWordSelectedMode(false)
            let relatedEdges = self.ralationshipViewModel.searchTargetRelationships(containedWordModel: unwrappedSelectedNode)
            view.deleteRelationshipViews(relationshipModels: relatedEdges)
            self.ralationshipViewModel.removeRelationships(relationships: relatedEdges)
        }
        self.wordViewModel.deleteWordModel(targetWordModel: targetWord)
        self.wordViewModel.getAllWordModelStatus()
        self.ralationshipViewModel.getAllRelationships()
    }
}

extension ViewController:RelationshipControlDelegate{
    func isRelationshipLooped(view: ScrollView, dst: WordModel) -> Bool {
        if let unwrappedParentNode = self.wordViewModel.getSelectedWordModel(), unwrappedParentNode.getID() == dst.getID(){
            return true
        }
        return false
    }
    
    func createRelationship(view: ScrollView, dst: WordModel) {
        if let unwrappedParentNode = self.wordViewModel.getSelectedWordModel(){
            let newEdge = RelationshipModel(scrWordModel: unwrappedParentNode, dstWordModel: dst)
            if self.ralationshipViewModel.addRelationship(newRelationship: newEdge){
                self.ralationshipViewModel.getAllRelationships()
                view.createRelationshipView(src: unwrappedParentNode, dst: dst, newRelationshipModel: newEdge)
            }
        }else{
            print("Edge creation failed")
        }
    }
    
    func relationshipDeleted(view: ScrollView, targetRelationship: RelationshipModel) {
        let deleteEdgeModel:[RelationshipModel] = [targetRelationship]
        self.ralationshipViewModel.removeRelationships(relationships: deleteEdgeModel)
        view.deleteRelationshipViews(relationshipModels: deleteEdgeModel)
        self.wordSelected(view: self.scrollview, selectedWord: nil)
    }
    
    func relationshipSelected(view: ScrollView, targetRelationship: RelationshipModel) {
        print("Edge tapped")
    }
    
    
}
