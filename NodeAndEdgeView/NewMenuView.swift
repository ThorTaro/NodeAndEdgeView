//
//  NewMenuView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/13.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

protocol NewMenuDelegate:NSObjectProtocol {
    
    func WordEdit()
    func CreateRelationship()
    func Remove()
}

enum MenuType{
    case Word
    case Theme
    case Relationship
}

class NewMenuView:UIView{
    private let menuItems:[String] = ["Edit", "Ralationshio", "Remove"]
    private var defaultMenuViewHeight:CGFloat = 0.0
    private weak var menuDelegate:NewMenuDelegate?
    private var menuType:MenuType = .Word
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.defaultMenuViewHeight = frame.height
        self.setView()
    }
    
    public func setDelegate(delegate:NewMenuDelegate){
        self.menuDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width/8
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        self.addSubview(blur)
    }
    
    public func changeMenuType(type:MenuType){
        self.menuType = type
    }
    
    private func configureMenuView(){
        switch self.menuType{
        case .Word:
            // TODO
            // 3種類全部のメニューボタンを表示
            self.frame.size.height = self.defaultMenuViewHeight
        case .Theme:
            // TODO
            // Removeボタン以外の2種類のメニューボタンを表示
            self.frame.size.height = self.defaultMenuViewHeight/3 * 2 // ここ，上下に余白入れるともう少しサイズいるかも
        case .Relationship:
            // TODO
            // Removeボタンのみ表示
            self.frame.size.height = self.defaultMenuViewHeight/3 // ここ，上下に余白入れるともう少しサイズいるかも
        }
    }
    
    public func showMenu(){
        self.configureMenuView()
        
        UIView.animate(withDuration: 0.3){
            self.frame.origin.x += self.frame.width
        }
    }
    
    
    public func hideMenu(){
        UIView.animate(withDuration: 0.3){
            self.frame.origin.x -= self.frame.width
        }
    }
}
