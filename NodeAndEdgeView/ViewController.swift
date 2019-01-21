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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCanvas()
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
}

extension ViewController:nodeControlDelegate{
    func isEdgeLoopedInView(view: CanvasView, childNode: NodeModel) -> Bool {
        if let unwrappedParentNode = self.nodeMap.searchSelectedNode(), unwrappedParentNode.getID() == childNode.getID(){
            return true
        }
        return false
    }
    
    func nodeSelectedInView(view: CanvasView, selectedNode: NodeModel?) {
        if let unwrappedSelectedNode = selectedNode{
            unwrappedSelectedNode.selected(bool: true)
            self.nodeMap.getNodesStatus()
            view.isNodeSelectedMode(bool: true)
        }else{
            if let unwrappedSelectedNode = self.nodeMap.searchSelectedNode(){
               unwrappedSelectedNode.selected(bool: false)
                self.nodeMap.getNodesStatus()
                view.isNodeSelectedMode(bool: false)
                view.SelectNode(node: unwrappedSelectedNode)
            }
        }
    }
    
    func createNodeInView(view: CanvasView, position: CGPoint) {
        let newNode = self.nodeMap.addNode(position: position)
        view.createNodeView(node: newNode)
    }
}

