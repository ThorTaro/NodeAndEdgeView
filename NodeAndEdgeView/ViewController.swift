//
//  ViewController.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let canvas = CanvasView()
    private var nodeMap = NodeMapModel()
    private var edgeMap = EdgeMapModel()
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
        super.viewDidLayoutSubviews()
        self.canvas.adjustCanvas(frame:self.view.bounds)
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
        let newAncestorNode = self.nodeMap.addNode(position: CGPoint.zero)
        self.nodeMap.makeAncestor(ancestorNode: newAncestorNode)
        self.canvas.createAncestorNodeView(node: newAncestorNode)
        guard let ancestorNodeModel = self.nodeMap.getAncestor() else {
            return
        }
        self.canvas.moveAncestorCenter(node: ancestorNodeModel)
        self.nodeSelectedInView(view: self.canvas, selectedNode: ancestorNodeModel)
        self.tappedTextEdit()
    }
}

extension ViewController:nodeControlDelegate{
    func edgeDeletedInView(view: CanvasView, edge: EdgeModel) {
        let deleteEdgeModel:[EdgeModel] = [edge]
        self.edgeMap.deleteEdge(edges: deleteEdgeModel)
        view.deleteEdgeView(edges: deleteEdgeModel)
        self.nodeSelectedInView(view: self.canvas, selectedNode: nil)
    }
    
    func nodeDeletedInView(view: CanvasView, node: NodeModel) {
        if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
            unwrappedSelectedNode.selected(bool: false)
            self.menuView.hideMenu()
            view.isEdgeCreationMode(bool: false)
            view.isNodeSelectedMode(bool: false)
            let relatedEdges = self.edgeMap.searchEdges(containedNode: unwrappedSelectedNode)
            view.deleteEdgeView(edges: relatedEdges)
            self.edgeMap.deleteEdge(edges: relatedEdges)
        }
        self.nodeMap.deleteNode(node: node)
        self.nodeMap.getNodesStatus()
        self.edgeMap.getAllEdges()
    }
    
    func nodeMovedInView(view: CanvasView, movedNode: NodeModel) {
        view.moveEdgeView(edges: self.edgeMap.searchEdges(containedNode: movedNode))
    }
    
    func createEdgeInView(view: CanvasView, childNode: NodeModel) {
        if let unwrappedParentNode = self.nodeMap.searchSelectedNode(){
            let newEdge = EdgeModel(parentNode: unwrappedParentNode, childNode: childNode)
            if self.edgeMap.addEdge(newEdge: newEdge){
                self.edgeMap.getAllEdges()
                view.createEdgeView(parentNode: unwrappedParentNode, childNode: childNode, newEdge: newEdge)
            }
        }else{
            print("Edge creation failed")
        }
    }
    
    func isEdgeLoopedInView(view: CanvasView, childNode: NodeModel) -> Bool {
        if let unwrappedParentNode = self.nodeMap.searchSelectedNode(), unwrappedParentNode.getID() == childNode.getID(){
            return true
        }
        return false
    }
    
    func nodeSelectedInView(view: CanvasView, selectedNode: NodeModel?) {
        if let unwrappedSelectedNode = selectedNode{
            unwrappedSelectedNode.selected(bool: true)
            self.menuView.showMenu(isAncestor: self.nodeMap.isAncestor(node: unwrappedSelectedNode))
            self.nodeMap.getNodesStatus()
            view.activateEdgeView(edges: self.edgeMap.searchEdges(containedNode: unwrappedSelectedNode), bool: true)
            view.isNodeSelectedMode(bool: true)
        }else{
            if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
                view.activateEdgeView(edges: self.edgeMap.searchEdges(containedNode: unwrappedSelectedNode), bool: false)
                unwrappedSelectedNode.selected(bool: false)
                self.menuView.hideMenu()
                self.nodeMap.getNodesStatus()
                view.isNodeSelectedMode(bool: false)
                view.isEdgeCreationMode(bool: false)
                view.SelectNode(node: unwrappedSelectedNode, isSelected: false)
            }
        }
    }
    
    func createNodeInView(view: CanvasView, position: CGPoint) {
        let newNode = self.nodeMap.addNode(position: position)
        view.createNodeView(node: newNode)
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
            
            guard let unwrappedSelectedNode = weakself.nodeMap.searchSelectedNode() else{
                return
            }
            unwrappedSelectedNode.setText(text: text)
            weakself.canvas.setTextInNodeView(node: unwrappedSelectedNode, text: text)
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
        if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
            self.canvas.deleteNodeView(node:unwrappedSelectedNode)
        }
    }
    
    func tappedCreateEdge() {
        self.canvas.isEdgeCreationMode(bool: true)
    }
}
