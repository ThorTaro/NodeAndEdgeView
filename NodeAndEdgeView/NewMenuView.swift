//
//  NewMenuView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/02/13.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

protocol NewMenuDelegate:NSObjectProtocol {
    func EditWord()
    func CreateRelationship()
    func Remove()
}

enum MenuType{
    case Word
    case Theme
    case Relationship
}

class NewMenuView:UIView{
    private var editButton = MenuButton()
    private var relationshipButton = MenuButton()
    private var removeButton = MenuButton()
    
    private let menuItems:[String] = ["Edit", "Ralationship", "Remove"]
    private var defaultMenuViewHeight:CGFloat = 0.0
    private weak var menuDelegate:NewMenuDelegate?
    private var menuType:MenuType = .Word
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.defaultMenuViewHeight = frame.height
        self.setView()
        self.setButton()
    }
    
    public func setDelegate(delegate:NewMenuDelegate){
        self.menuDelegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setButton(){
        self.editButton.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.frame.width,
                                       height: self.defaultMenuViewHeight/3)
        self.editButton.setView(name: self.menuItems[0], icon: UIImage(named: "EditIcon")!)
        self.addSubview(self.editButton)
        self.editButton.addTarget(self, action: #selector(editButtonDidTapped), for: .touchUpInside)
        
        self.relationshipButton.frame = CGRect(x: 0,
                                               y: self.defaultMenuViewHeight/3,
                                               width: self.frame.width,
                                               height: self.defaultMenuViewHeight/3)
        self.relationshipButton.setView(name: self.menuItems[1], icon: UIImage(named: "RelationshipIcon")!)
        self.addSubview(self.relationshipButton)
        self.relationshipButton.addTarget(self, action: #selector(relationshipButtonDidTapped), for: .touchUpInside)
        
        self.removeButton.frame = CGRect(x: 0,
                                         y: self.defaultMenuViewHeight/3 * 2,
                                         width: self.frame.width,
                                         height: self.defaultMenuViewHeight/3)
        self.removeButton.setView(name: self.menuItems[2], icon: UIImage(named: "RemoveIcon")!)
        self.addSubview(self.removeButton)
        self.removeButton.addTarget(self, action: #selector(removeButtonDidTapped), for: .touchUpInside)
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
            self.editButton.isHidden = false
            self.relationshipButton.isHidden = false
            self.removeButton.isHidden = false
            self.removeButton.frame.origin.y = self.defaultMenuViewHeight/3 * 2
            self.frame.size.height = self.defaultMenuViewHeight
        case .Theme:
            self.editButton.isHidden = false
            self.relationshipButton.isHidden = false
            self.removeButton.isHidden = true
            self.removeButton.frame.origin.y = self.defaultMenuViewHeight/3 * 2
            self.frame.size.height = self.defaultMenuViewHeight/3 * 2
        case .Relationship:
            self.editButton.isHidden = true
            self.relationshipButton.isHidden = true
            self.removeButton.isHidden = false
            self.removeButton.frame.origin.y = 0
            self.frame.size.height = self.defaultMenuViewHeight/3
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
    
    @objc func editButtonDidTapped(sender:UIButton){
        guard let delegate = self.menuDelegate else {
            return
        }
        delegate.EditWord()
    }
    
    @objc func relationshipButtonDidTapped(sender:UIButton){
        guard let delegate = self.menuDelegate else {
            return
        }
        delegate.CreateRelationship()
    }
    
    @objc func removeButtonDidTapped(sender:UIButton){
        guard let delegate = self.menuDelegate else {
            return
        }
        delegate.Remove()
    }
}
