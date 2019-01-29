//
//  MenuItemCell.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/25.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

class MenuItemCell:UITableViewCell{
    private let icon:UIImageView = {
        let imageview = UIImageView()
            imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    private let itemLabel:UILabel = {
        let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.backgroundColor = .clear
        self.icon.frame.size = CGSize(width: self.bounds.height / 10 * 8, height: self.bounds.height / 10 * 8)
        self.icon.frame.origin.x = self.bounds.width / 16
        self.icon.center.y = self.center.y
        self.addSubview(self.icon)
        self.itemLabel.frame.size = CGSize(width: self.bounds.width - (self.bounds.height / 10 * 2),
                                           height: self.bounds.height / 10 * 8)
        self.itemLabel.frame.origin.x = self.icon.frame.maxX + self.bounds.height / 10
        self.itemLabel.center.y = self.center.y
        self.addSubview(self.itemLabel)
    }
    
    public func setImage(name:String){
        self.icon.image = UIImage(named: name)
    }
    
    public func setItem(name:String){
        self.itemLabel.text = name
    }
}
