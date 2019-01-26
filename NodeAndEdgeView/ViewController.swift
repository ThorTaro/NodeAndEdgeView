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
    private var menu = SideMenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
        self.setupMenu()
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
        self.menu = SideMenuView(frame: CGRect(x: self.view.bounds.width,
                                               y: self.view.frame.origin.y,
                                               width: self.view.bounds.width / 4,
                                               height: self.view.bounds.height / 2))
        self.menu.sideMenuController = self
        self.view.addSubview(self.menu)
    }
}

extension ViewController:nodeControlDelegate{
    func nodeDeletedInView(view: CanvasView, node: NodeModel) {
        if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
            unwrappedSelectedNode.selected(bool: false)
            self.menu.hideMenu()
            view.isEdgeCreationMode(bool: false)
            view.isNodeSelectedMode(bool: false)
        }
        self.nodeMap.deleteNode(node: node)
        self.nodeMap.getNodesStatus()
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
            self.menu.showMenu()
            self.nodeMap.getNodesStatus() // Print Debug
            view.isNodeSelectedMode(bool: true)
        }else{
            if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
                unwrappedSelectedNode.selected(bool: false)
                self.menu.hideMenu()
                self.nodeMap.getNodesStatus()
                view.isNodeSelectedMode(bool: false)
                view.isEdgeCreationMode(bool: false)
                view.SelectNode(node: unwrappedSelectedNode)
            }
        }
    }
    
    func createNodeInView(view: CanvasView, position: CGPoint) {
        let newNode = self.nodeMap.addNode(position: position)
        view.createNodeView(node: newNode)
    }
}

extension ViewController:sideMenuDelegate{
    func tappedDeletaNode() {
        if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
            self.canvas.deleteNodeView(node:unwrappedSelectedNode)
        }
    }
    
    func tappedCreateEdge() {
        self.canvas.isEdgeCreationMode(bool: true)
    }
}
