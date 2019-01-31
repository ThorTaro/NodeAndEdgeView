//
//  sideMenuView.swift
//  NodeAndEdgeView
//
//  Created by Taro on 2019/01/25.
//  Copyright © 2019 Taro. All rights reserved.
//

import UIKit

protocol MenuViewDelegate:NSObjectProtocol{
    func tappedTextEdit()
    func tappedCreateEdge()
    func tappedDeleteNode()
}

class MenuView:UIView{
    private let itemSet:[String] = ["Text Edit","Create Edge","Delete"]
    
    private var defaultHeight:CGFloat = 0.0
    private var tableView:UITableView = {
        let table = UITableView()
            table.backgroundColor = .clear
            table.tableFooterView = UIView(frame: .zero)
            table.separatorStyle = .none
            table.isScrollEnabled = false
        return table
    }()
    
    public weak var sideMenuController:MenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultHeight = frame.height
        self.setupUI()
        self.setupItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        self.backgroundColor = .clear
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width / 8
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurEffectView.frame = self.bounds
        self.addSubview(blurEffectView)
    }
    
    private func setupItem(){
        self.tableView.frame.size = CGSize(width: self.bounds.width, height: self.bounds.height / 10 * 9)
        self.tableView.frame.origin = CGPoint(x: self.bounds.origin.x, y: self.bounds.width / 8)
        self.tableView.rowHeight = (self.bounds.height - self.bounds.width / 8 * 2) / CGFloat(self.itemSet.count)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MenuItemCell.self, forCellReuseIdentifier: "cellID")
        self.addSubview(tableView)
    }
    
    public func showMenu(isAncestor:Bool){
        self.frame.size.height = self.defaultHeight
        if isAncestor{
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else {
                return
            }
            cell.isHidden = true
            self.frame.size.height -= self.tableView.rowHeight
        }else{
            guard let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else {
                return
            }
            cell.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x -= self.frame.width
            self.setNeedsLayout()
        })
    }
    
    public func hideMenu(){
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x += self.frame.width
            if let indexPathForSelectedRow = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
            self.setNeedsLayout()
        })
    }
    
    public func unableDelteMode(){
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else {
            return
        }
        cell.isHidden = true
        self.setNeedsLayout()
    }
}

extension MenuView:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if let unwrappedMenuController = self.sideMenuController{
                unwrappedMenuController.tappedTextEdit()
            }
        }else if indexPath.row == 1{
            if let unwrappedSideMenuController = self.sideMenuController{
                unwrappedSideMenuController.tappedCreateEdge()
            }
        }else if indexPath.row == 2{
            if let unwrappedSideMenuController = self.sideMenuController{
                unwrappedSideMenuController.tappedDeleteNode()
            }
        }else{
            print("Out of range")
        }
    }
}

extension MenuView:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuItemCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! MenuItemCell
        if indexPath.row == 0{
            cell.setImage(name: "TextEditIcon")
        }else if indexPath.row == 1{
            cell.setImage(name: "EdgeCreationIcon")
        }else{
            cell.setImage(name: "DeleteIcon")
        }
        cell.setItem(name: self.itemSet[indexPath.row])
        return cell
    }
}
