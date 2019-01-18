//
//  CanvasView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

@objc protocol nodeControlDelegate{
    func createNodeInView(view:CanvasView, position:CGPoint)
}

class CanvasView: UIScrollView{
    private let canvasContainer = Container(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: 3000,
                                                          height: 3000))
    
    public weak var nodeController:nodeControlDelegate?
    
    override func didMoveToSuperview() {
        self.minimumZoomScale = 0.5
        self.maximumZoomScale = 2.0
        self.backgroundColor = .black
        self.contentOffset = self.canvasContainer.center
        self.delegate = self
        self.addSubview(self.canvasContainer)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        self.addGestureRecognizer(longPress)
    }
    
    public func adjustCanvas(frame:CGRect){
        self.frame = frame
        self.contentOffset = CGPoint(x: self.canvasContainer.center.x - frame.width / 2,
                                     y: self.canvasContainer.center.y - frame.height / 2)
    }
    
    @objc func longPressHandler(recognizer: UILongPressGestureRecognizer){
        // ノードを作る処理(nodeDelegateを後ほど解読する)
        if recognizer.state == .began{
            print("node created")
        }
        
        if let unwrappedNodeController = self.nodeController, recognizer.state == .began{
            let newNodePosition = CGPoint(x: recognizer.location(in: self.canvasContainer).x,
                                          y: recognizer.location(in: self.canvasContainer).y)
            unwrappedNodeController.createNodeInView(view: self, position: newNodePosition)
        }
    }
    
    public func createNodeView(node:NodeModel){
        let newNodeView = NodeView(view: self, node: node)
        self.canvasContainer.addSubview(newNodeView)
        self.canvasContainer.bringSubviewToFront(newNodeView)
        
    }
    
    private func nodeDeleted(){
        // ノードを削除した時の処理
        // nodeDelegateで何かしている
    }
    
    public func nodeMoved(node:NodeModel){
        // ノードが動いた時の処理
        // nodeDelegateとエッジの描画のメソッドが書いてあったけどそれ以上はわからん
        print("nodeView moved")
    }
}

extension CanvasView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasContainer
    }
}
