//
//  CanvasView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/18.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class CanvasView: UIScrollView{
    private let canvasContainer = Container(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: 3000,
                                                          height: 3000))
    
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
    }
    
    private func nodeDeleted(){
        // ノードを削除した時の処理
        // nodeDelegateで何かしている
    }
    
    private func nodeMoved(){
        // ノードが動いた時の処理
        // nodeDelegateとエッジの描画のメソッドが書いてあったけどそれ以上はわからん
    }
}

extension CanvasView: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.canvasContainer
    }
}
