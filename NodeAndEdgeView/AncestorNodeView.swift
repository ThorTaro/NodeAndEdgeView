//
//  AncestorNodeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/28.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class AncestorNodeView: NodeView {
    required init(view: CanvasView, node: NodeModel) {
        super.init(view: view, node: node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUpView(){
        super.setUpView()
        self.backgroundColor = .magenta
    }
    
    override func changeNodeViewColor(isSelected: Bool) {
        if isSelected == true{
            self.backgroundColor = .yellow
        }else{
            self.backgroundColor = .magenta
        }
    }
    
    @objc override func panHandler(recongnizer: UIPanGestureRecognizer) {
        return
    }
}

// TODO
// 抽象クラスを作るの面倒だからやりたくなかったけど，やっぱり作ることにしたからそのうち作る
// commit messageに書いたけど，見た目とPan GestureとDeleteをして欲しくないのでそのあたりもなんとかする
