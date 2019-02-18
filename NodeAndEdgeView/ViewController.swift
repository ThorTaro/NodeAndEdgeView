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
    
    // 以下二つのプロパティを改築用に仮に追加(2/13)
    private var newMenuView = NewMenuView()
    private var menuType:MenuType = .Word

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
                                               y: self.view.frame.origin.y,
                                               width: self.view.bounds.width / 4,
                                               height: self.view.bounds.height / 2))
        self.menuView.sideMenuController = self
        self.view.addSubview(self.menuView)
        
        // 以下の内容を改築のために仮に設定(左側から出るように設計しているけど，後で右側に変更する)
        self.newMenuView = NewMenuView(frame: CGRect(x: self.view.bounds.origin.x - self.view.bounds.width/4,
                                                     y: self.view.bounds.origin.y,
                                                     width: self.view.bounds.width / 4,
                                                     height: self.view.bounds.height / 2))
        self.newMenuView.setDelegate(delegate: self)
        self.view.addSubview(self.newMenuView)
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
        self.tappedTextEdit()
    }
}


extension ViewController:MenuViewDelegate{
    func tappedTextEdit() {
        let AlertController = UIAlertController(title: "Word", message: "", preferredStyle: .alert)
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
            textField.placeholder = "Text"
            textField.keyboardAppearance  = .dark
        }
        AlertController.addAction(OKAlertAction)
        AlertController.addAction(CancelAction)
        self.present(AlertController, animated: true, completion: nil)
    }
    
    func tappedDeleteNode() {
        if let unwrappedSelectedNode = self.wordViewModel.getSelectedWordModel(){
            self.scrollview.removeWordView(selectedWordModel:unwrappedSelectedNode)
        }
    }
    
    func tappedCreateEdge() {
        self.scrollview.changeModeType(mode: .relationshipCreation)
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
            self.menuView.showMenu(isAncestor: self.wordViewModel.getIsThemeWordStatus(targetWordModel: targetUnselectedWord)) // 移行後削除
            self.wordViewModel.getAllWordModelStatus() // ただのデバッグ用
            
            // 改築のために仮配置兼テスト表示用に以下を記述
            self.newMenuView.changeMenuType(type: self.wordViewModel.getIsThemeWordStatus(targetWordModel: targetUnselectedWord) ? .Theme:.Word)
            self.newMenuView.showMenu()
            
            
            view.changeModeType(mode: .wordSelected)
        }else{
            if let targetSelectedWord = self.wordViewModel.getSelectedWordModel(){
                targetSelectedWord.toggleIsSelected(bool: false)
                self.menuView.hideMenu()// 移行後削除
                self.wordViewModel.getAllWordModelStatus()// ただのデバッグ用
                
                // 以下改築のためのテスト表示用に記述
                self.newMenuView.hideMenu()
                
                view.changeModeType(mode: .normal)
                view.toggleWordViewState(targetWordModel: targetSelectedWord, isSelected: false)
            }
        }
    }
    
    func wordMoved(view: ScrollView, movedWord: WordModel, newPosition: CGPoint) {
        self.wordViewModel.updateWordModelPosition(targetWordModel: movedWord, newPosition: newPosition)
        view.moveRelationshipView(relationshipModels: self.ralationshipViewModel.searchTargetRelationships(containedWordModel: movedWord))
    }

    
    func wordRemoved(view: ScrollView, targetWord: WordModel) {        
        targetWord.toggleIsSelected(bool: false)
        self.menuView.hideMenu() // 移行後削除
        let relatedRelationships = self.ralationshipViewModel.searchTargetRelationships(containedWordModel: targetWord)
        view.deleteRelationshipViews(relationshipModels: relatedRelationships)
        self.ralationshipViewModel.removeRelationships(relationships: relatedRelationships)
        self.wordViewModel.removeWordModel(targetWordModel: targetWord)
        view.changeModeType(mode: .normal)
        self.newMenuView.hideMenu()
        
        self.wordViewModel.getAllWordModelStatus()// ただのデバッグ用
        self.ralationshipViewModel.getAllRelationships()// ただのデバッグ用
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
    
    func relationshipRemoved(view: ScrollView, targetRelationship: RelationshipModel) {
        let deleteEdgeModel:[RelationshipModel] = [targetRelationship]
        self.ralationshipViewModel.removeRelationships(relationships: deleteEdgeModel)
        view.deleteRelationshipViews(relationshipModels: deleteEdgeModel)
        self.wordSelected(view: self.scrollview, selectedWord: nil)
    }
    
    func relationshipSelected(view: ScrollView, targetRelationship: RelationshipModel?) {
        if let _ = targetRelationship{
            view.changeModeType(mode: .ralationshipSelected)
            self.newMenuView.changeMenuType(type: .Relationship)
            self.newMenuView.showMenu()
        }else{
            self.newMenuView.hideMenu()
            view.changeModeType(mode: .normal)
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
    
    func Remove() {
        // TODO
        // 消すのはWordModelに限らないので，場合分けが必要
        // というか．Relationshipに削除とか選択って概念がないから．そこから作らないといけない
        if let selectedWordModel = self.wordViewModel.getSelectedWordModel(){
            self.scrollview.removeWordView(selectedWordModel:selectedWordModel)
        }
    }
}
