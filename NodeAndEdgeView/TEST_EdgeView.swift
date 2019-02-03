//
//  TEST_EdgeView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/04.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class TEST_EdgeView:CAShapeLayer{
    private weak var parentNodeView:AbstractNodeView?
    private weak var childeNodeView:AbstractNodeView?
    
    private let EdgeLayer = CAShapeLayer() // Maybe not need?
    private let EdgePath = UIBezierPath()
    
    required init(parentNodeView:AbstractNodeView, childeNodeView:AbstractNodeView) {
        self.parentNodeView = parentNodeView // Maybe Optional?
        self.childeNodeView = childeNodeView // Maybe Optional?
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createPath(){
        self.EdgePath.removeAllPoints()
        
        // TODO
        // parentNodeViewとchildeNodeViewをつなぐ線を描画するためのPathを作る
        // ただの線だとタップできないので前回のバージョン同様四角形を描画するための数式をコードに落とす
        // 考え出した数式だと傾きの関係でNodeView同士の関係が真横か真縦の時は数式で表現不可能なので場合分けする必要がある
        // 単純な場合分けとして，真横あるいは真縦のときは簡単に四角形を作るPathを作る
    }
    
    private func createLayer(){
        // TODO
        // 作ったPathをLayerのPathに代入する
        // 色とかそのあたりをここで設定する(initの段階でもいいけど)
        // 既存のEdgeViewと違うのは，このクラスはCAShapeLayerそのものなので．このクラス内でAddSubViewをするわけではない
    }
    
    // TODO(MEMO)
    // このクラスに記述する処理じゃないけど，ここにメモしておく
    // EdgeView(仮称)はCanvasContainer(UIView)に直接描画(insertSublayer)する予定
    // UIViewのメソッドhitTest()を使ってCAShapeLayerのタップを検知することができるんだけど，
    // 今までのCAShapeLayerはただの直線だったのでタップできなかった
    // このクラスは細長い四角形なので領域を持っている(タップ検知ができる)
    // hitTest()を使うにあたって，すでにCreateNodeViewとかCanvasContainerのスワイプとかNodeSeletedModeの解除とかでジェスチャーが登録されているので，
    // そのあたりの場合分けをしつつ判定を行う必要がある
    // さらにいえば，EdgeAndEdgeViewDictに入っている要素を全検索して判定をする必要がある

}
