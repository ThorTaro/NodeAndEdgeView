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
    func nodeSelectedInView(view: CanvasView, selectedNode: NodeModel) {
        selectedNode.selected(bool: true)
        view.isNodeSelectedMode(bool: true)
    }
    
    func createNodeInView(view: CanvasView, position: CGPoint) {
        let newNode = self.nodeMap.addNode(position: position)
        view.createNodeView(node: newNode)
    }
}

