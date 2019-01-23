//
//  CanvasView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

protocol nodeControlDelegate:NSObjectProtocol{
    func createNodeInView(view:CanvasView, position:CGPoint)
    func nodeSelectedInView(view:CanvasView, selectedNode:NodeModel?)
    func isEdgeLoopedInView(view:CanvasView, childNode:NodeModel) -> Bool
    func createEdgeInView(view:CanvasView, childNode:NodeModel)
    func nodeMovedInView(view:CanvasView, movedNode:NodeModel)
}

class CanvasView: UIScrollView{
    private var NodeAndViewDict = [NodeModel:NodeView]()
    private var NodeAndEdgeDict = [EdgeModel:EdgeView]()
    private let canvasContainer = Container(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: UIScreen.main.bounds.width * 5,
                                                          height: UIScreen.main.bounds.height * 5))
    private var containerLimitSize = CGRect.zero
    private var nodeSelectedMode:Bool = false{
        didSet{
            print("nodeSelectedMode:\(self.nodeSelectedMode)")
        }
    }
    private var edgeCreationMode:Bool = false{
        didSet{
            print("edgeCreationMode:\(self.edgeCreationMode)")
        }
    }
    public weak var nodeController:nodeControlDelegate?
    
    override func didMoveToSuperview() {
        self.minimumZoomScale = UIScreen.main.bounds.height / self.canvasContainer.frame.height
        self.maximumZoomScale = 2.0
        self.backgroundColor = .black
        self.contentOffset = self.canvasContainer.center
        self.delegate = self
        self.addSubview(self.canvasContainer)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
        self.containerLimitSize = self.canvasContainer.bounds
    }
    
    public func adjustCanvas(frame:CGRect){
        self.frame = frame
        self.contentOffset = CGPoint(x: self.canvasContainer.center.x - frame.width / 2,
                                     y: self.canvasContainer.center.y - frame.height / 2)
    }
    
    public func getCanvasLimitSize() -> CGRect{
        return self.containerLimitSize
    }
    
    @objc func longPressHandler(recognizer: UILongPressGestureRecognizer){
        if let unwrappedNodeController = self.nodeController,!self.getSelectedModeStatus(),recognizer.state == .began{
            let newNodePosition = CGPoint(x: recognizer.location(in: self.canvasContainer).x,
                                          y: recognizer.location(in: self.canvasContainer).y)
            unwrappedNodeController.createNodeInView(view: self, position: newNodePosition)
        }
    }
    
    public func createNodeView(node:NodeModel){
        let newNodeView = NodeView(view: self, node: node)
        self.NodeAndViewDict[node] = newNodeView
        self.canvasContainer.addSubview(newNodeView)
        self.canvasContainer.bringSubviewToFront(newNodeView)
    }
    
    private func nodeDeleted(){
        // ノードを削除した時の処理
        // nodeDelegateで何かしている
    }
    
    public func nodeMoved(node:NodeModel){
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeMovedInView(view: self, movedNode: node)
        }
    }
    
    public func nodeSelected(selectedNode:NodeModel){
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeSelectedInView(view: self, selectedNode: selectedNode)
            self.SelectNode(node: selectedNode)
        }
    }
    
    public func isNodeSelectedMode(bool:Bool){
        self.nodeSelectedMode = bool
    }
    
    public func SelectNode(node:NodeModel){
        if let unwrappedNodeViewDict = self.NodeAndViewDict[node]{
            unwrappedNodeViewDict.changeNodeViewColor()
        }
    }
    
    public func getSelectedModeStatus() -> Bool{
        return self.nodeSelectedMode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let unwrappedNodeController = self.nodeController{
            unwrappedNodeController.nodeSelectedInView(view: self, selectedNode: nil)
        }
    }
    
    public func isLooped(childNode:NodeModel) -> Bool{
        if let unwrappedNodeController = self.nodeController{
            return unwrappedNodeController.isEdgeLoopedInView(view: self, childNode: childNode)
        }else{
            return true
        }
    }
    
    public func createEdge(childNode:NodeModel){
        if let unwrappedNodeController = self.nodeController, self.getEdgeCreationModeStatus(){
            unwrappedNodeController.createEdgeInView(view: self, childNode: childNode)
        }
    }
    
    public func isEdgeCreationMode(bool:Bool){
        self.edgeCreationMode = bool
    }
    
    private func getEdgeCreationModeStatus() -> Bool{
        return self.edgeCreationMode
    }
    
    public func createEdgeView(parentNode:NodeModel, childNode:NodeModel, newEdge:EdgeModel){
        let newEdgeView = EdgeView(parentNodeView: self.NodeAndViewDict[parentNode], childNodeView: self.NodeAndViewDict[childNode])
        self.canvasContainer.layer.insertSublayer(newEdgeView, at: 1)
        self.NodeAndEdgeDict[newEdge] = newEdgeView
    }
    
    public func moveEdgeView(edges:[EdgeModel]){
        for edge in edges{
            guard let unwrappedEdgeView = self.NodeAndEdgeDict[edge] else {continue}
            unwrappedEdgeView.redrawEdge()
        }
    }
}

extension CanvasView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasContainer
    }
}
