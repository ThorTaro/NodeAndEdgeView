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
    private var EdgePath = UIBezierPath()
    private let EdgeWidth:CGFloat = 10.0
    
    required init(parentNodeView:AbstractNodeView?, childeNodeView:AbstractNodeView?) {
        self.parentNodeView = parentNodeView // Maybe Optional?
        self.childeNodeView = childeNodeView // Maybe Optional?
        super.init()
        self.createPath()
        self.createLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createPath(){
        self.EdgePath.removeAllPoints()
        guard let unwrappedParentNodeView = self.parentNodeView, let unwrappedChildNodeView = self.childeNodeView else{
            print("Unwrap Failed")
            return
        }
        
        if unwrappedParentNodeView.center.x == unwrappedChildNodeView.center.x{
            let originY:CGFloat = min(unwrappedParentNodeView.center.y, unwrappedChildNodeView.center.y)
            self.EdgePath = UIBezierPath(rect: CGRect(x: unwrappedParentNodeView.center.x - self.EdgeWidth/2,
                                                      y: originY,
                                                      width: self.EdgeWidth,
                                                      height: CGFloat(fabsf(Float(unwrappedParentNodeView.center.y - unwrappedChildNodeView.center.y)))))
            
        }else if unwrappedParentNodeView.center.y == unwrappedChildNodeView.center.y{
            let originX:CGFloat = min(unwrappedParentNodeView.center.x, unwrappedChildNodeView.center.x)
            self.EdgePath = UIBezierPath(rect: CGRect(x: originX,
                                                      y: unwrappedParentNodeView.center.y - self.EdgeWidth/2,
                                                      width: CGFloat(fabsf(Float(unwrappedParentNodeView.center.x - unwrappedChildNodeView.center.x))),
                                                      height: self.EdgeWidth))
        }else{
            let m:CGFloat = (unwrappedParentNodeView.center.y - unwrappedChildNodeView.center.y)/(unwrappedParentNodeView.center.x - unwrappedChildNodeView.center.x)
            let m_p:CGFloat = (-1)/m
            
            // 一応傾きが0になる現象を監視(ないはず)
            if m_p == 0{
                print("m_p is zero")
            }
            
            let delta:CGFloat = sqrt(pow(self.EdgeWidth/2, 2.0)/(pow(m_p, 2.0) + 1.0))
            self.EdgePath.move(to: CGPoint(x: unwrappedParentNodeView.center.x + delta,
                                           y: m_p * (unwrappedParentNodeView.center.x + delta) + unwrappedParentNodeView.center.y - m_p * unwrappedParentNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedChildNodeView.center.x + delta,
                                              y: m_p * (unwrappedChildNodeView.center.x + delta) + unwrappedChildNodeView.center.y - m_p * unwrappedChildNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedChildNodeView.center.x - delta,
                                              y: m_p * (unwrappedChildNodeView.center.x - delta) + unwrappedChildNodeView.center.y - m_p * unwrappedChildNodeView.center.x))
            self.EdgePath.addLine(to: CGPoint(x: unwrappedParentNodeView.center.x - delta,
                                              y: m_p * (unwrappedParentNodeView.center.x - delta) + unwrappedParentNodeView.center.y - m_p * unwrappedParentNodeView.center.x))
            self.EdgePath.close()
        }
    }
    
    public func createLayer(){
        self.fillColor = UIColor.lightGray.cgColor
        self.path = self.EdgePath.cgPath
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
    
    public func removeEdgeView(){
        self.EdgePath.removeAllPoints()
        self.EdgeLayer.removeFromSuperlayer()
        self.removeFromSuperlayer()
    }

}
