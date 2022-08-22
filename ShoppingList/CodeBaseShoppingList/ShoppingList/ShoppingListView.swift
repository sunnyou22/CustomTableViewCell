//
//  ShoppingListView.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import SnapKit

class ShoppingListView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    let topContainView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    let topContainSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    let plusButton: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.title = "추가"
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .lightGray
        
        view.configuration = config
        
        return view
    }()
    
    let insertTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "사고싶은 항목을 적고 추가 버튼을 클릭해주세요"
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    
    override func configureUI() {
        [insertTextField, plusButton].forEach { topContainSubView.addSubview($0) }
        topContainView.addSubview(topContainSubView)
        tableView.addSubview(topContainView)
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self).offset(0)
            
        }
        
        topContainView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.top).offset(0)
            make.trailing.equalTo(tableView.snp.trailing).offset(0)
            make.leading.equalTo(tableView.snp.leading).offset(0)
            make.height.equalTo(80)
        }
        
        topContainSubView.snp.makeConstraints { make in
            make.top.equalTo(topContainView.snp.top).offset(8)
            make.bottom.equalTo(topContainView.snp.bottom).offset(-8)
            make.trailing.equalTo(topContainView.snp.trailing).offset(-16)
            make.leading.equalTo(topContainView.snp.leading).offset(16)
        }
        
        insertTextField.snp.makeConstraints { make in
            make.top.equalTo(topContainSubView.snp.top).offset(8)
            make.bottom.equalTo(topContainSubView.snp.bottom).offset(-8)
            make.trailing.equalTo(topContainSubView.snp.trailing).offset(-8)
            make.leading.equalTo(topContainSubView.snp.leading).offset(8)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(topContainSubView.snp.trailing).offset(-8)
            make.leading.equalTo(insertTextField.snp.trailing).offset(8)
            make.centerY.equalTo(insertTextField)
            make.height.equalTo(insertTextField.snp.height)
            make.width.equalTo(plusButton.snp.height).multipliedBy(3/5)
        }
    }
}
