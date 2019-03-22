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
    private var relationshipViewModel = RelationshipViewModel()
    private var menuView = MenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
        self.setMenu()
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
    
    private func setMenu(){
        self.menuView = MenuView(frame: CGRect(x: self.view.bounds.width,
                                                     y: self.view.bounds.height / 4,
                                                     width: self.view.bounds.width / 10,
                                                     height: self.view.bounds.height / 2))
        self.menuView.setDelegate(delegate: self)
        self.view.addSubview(self.menuView)
    }
    
    private func setTheme(){
        let newThemeWordModel = self.wordViewModel.appendNewWordModel(position: CGPoint.zero)
        self.wordViewModel.wordModelToThemeWord(targetWordModel: newThemeWordModel)
        self.scrollview.createThemeWordView(wordModel: newThemeWordModel, position: self.wordViewModel.getWordModelPosition(targetWordModel: newThemeWordModel))
        guard let themeWordModel = self.wordViewModel.getFirstCreatedWordModel() else {
            return
        }
        self.scrollview.keepThemeWordViewCenter(wordModel: themeWordModel)
        self.wordSelected(view: self.scrollview, selectedWord: themeWordModel)
        self.EditWord()
    }
}


extension ViewController:WordControlDelegate{
    func createWord(view: ScrollView, position: CGPoint) {
        let newWord = self.wordViewModel.appendNewWordModel(position: position)
        view.createWordView(newWordModel: newWord, position: self.wordViewModel.getWordModelPosition(targetWordModel: newWord))
    }
    
    func wordSelected(view: ScrollView, selectedWord: WordModel?) {
        if let targetUnselectedWord = selectedWord{
            targetUnselectedWord.toggleIsSelected(bool: true)
            self.menuView.changeMenuType(type: self.wordViewModel.getIsThemeWordStatus(targetWordModel: targetUnselectedWord) ? .Theme:.Word)
            self.menuView.showMenu()
            
            view.changeModeType(mode: .wordSelected)
        }else{
            if let targetSelectedWord = self.wordViewModel.getSelectedWordModel(){
                targetSelectedWord.toggleIsSelected(bool: false)
                self.menuView.hideMenu()
                view.changeModeType(mode: .normal)
                view.toggleWordViewState(targetWordModel: targetSelectedWord, isSelected: false)
            }
        }
    }
    
    func wordMoved(view: ScrollView, movedWord: WordModel, newPosition: CGPoint) {
        self.wordViewModel.updateWordModelPosition(targetWordModel: movedWord, newPosition: newPosition)
        view.moveRelationshipView(relationshipModels: self.relationshipViewModel.getRelatedRelationships(targetWordModel: movedWord))
    }

    
    func wordRemoved(view: ScrollView, targetWord: WordModel) {        
        targetWord.toggleIsSelected(bool: false)
        let relatedRelationships = self.relationshipViewModel.getRelatedRelationships(targetWordModel: targetWord)
        self.relationshipRemoved(view: view, targetRelationships: relatedRelationships)
        view.removeWordView(selectedWordModel: targetWord)
        self.wordViewModel.removeWordModel(targetWordModel: targetWord)
        view.changeModeType(mode: .normal)
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
        if let srcWordModel = self.wordViewModel.getSelectedWordModel(){
            let newRelationshipModel = RelationshipModel(scrWordModel: srcWordModel, dstWordModel: dst)
            if self.relationshipViewModel.addRelationship(newRelationship: newRelationshipModel){
                view.createRelationshipView(src: srcWordModel, dst: dst, newRelationshipModel: newRelationshipModel)
            }
        }else{
            print("Edge creation failed")
        }
    }
    
    func relationshipRemoved(view: ScrollView, targetRelationships: [RelationshipModel]) {
        view.removeRelationshipViews(relationshipModels: targetRelationships)
        view.changeModeType(mode: .normal)
        self.relationshipViewModel.removeRelationships(relationships: targetRelationships)
    }
    
    func relationshipSelected(view: ScrollView, targetRelationship: RelationshipModel?) {
        if let targetRelationship = targetRelationship{
            targetRelationship.toggleIsSelected(bool: true)
            view.changeModeType(mode: .ralationshipSelected)
            self.menuView.changeMenuType(type: .Relationship)
            self.menuView.showMenu()
        }else{
            if let selectedRelationshipModel = self.relationshipViewModel.getSelectedRelationshipModel(){
                selectedRelationshipModel.toggleIsSelected(bool: false)
                self.menuView.hideMenu()
                view.changeModeType(mode: .normal)
            }
        }
    }
}

extension ViewController:NewMenuDelegate{
    func EditWord() {
        let AlertController = UIAlertController(title: "Edit Word", message: "", preferredStyle: .alert)
        let OKAlertAction = UIAlertAction(title: "OK", style: .default, handler:{[weak AlertController, weak self](action) -> Void in
            guard let text = AlertController?.textFields?.first?.text else{
                return
            }
            
            guard let weakself = self else{
                return
            }
            
            guard let selectedWordModel = weakself.wordViewModel.getSelectedWordModel() else{
                return
            }
            selectedWordModel.setWord(newWord: text)
            weakself.scrollview.setWordInWordView(wordModel: selectedWordModel, newWord: text)
            weakself.wordSelected(view: weakself.scrollview, selectedWord: nil)
        })
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self](action) -> Void in
            guard let weakself = self else{
                return
            }
            weakself.wordSelected(view: weakself.scrollview, selectedWord: nil)
        })
        AlertController.addTextField{textField in
            textField.placeholder = "Word"
            textField.keyboardAppearance  = .dark
        }
        AlertController.addAction(OKAlertAction)
        AlertController.addAction(CancelAction)
        self.present(AlertController, animated: true, completion: nil)
    }
    
    func CreateRelationship() {
        self.scrollview.changeModeType(mode: .relationshipCreation)
    }
    
    func Remove(removeType:MenuType) {
        switch removeType{
        case .Word:
            if let selectedWordModel = self.wordViewModel.getSelectedWordModel(){
                self.wordRemoved(view: self.scrollview, targetWord: selectedWordModel)
            }
        case .Relationship:
            if let selectedRelationshipModel = self.relationshipViewModel.getSelectedRelationshipModel(){
                let removeRelationshipList:[RelationshipModel] = [selectedRelationshipModel]
                self.relationshipRemoved(view: self.scrollview, targetRelationships: removeRelationshipList)
            }
        case .Theme:
            print("ERROR: Theme word cannot be removed")
            return
        }
        self.menuView.hideMenu()
    }
}
