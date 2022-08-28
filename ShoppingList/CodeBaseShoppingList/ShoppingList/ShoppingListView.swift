//
//  ShoppingListView.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import SnapKit
import FSCalendar

class ShoppingListView: BaseView {
    
    lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.backgroundColor = .white
        return view
    }()
    
    let headerview: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4087355733, green: 0.3312071562, blue: 0.2074120343, alpha: 1)
        
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = #colorLiteral(red: 0.9610450864, green: 0.8862027526, blue: 0.7589734197, alpha: 1)
        
        return view
    }()
    
    let topContainView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9610450864, green: 0.8862027526, blue: 0.7589734197, alpha: 1)
        return view
    }()
    
    let topContainSubView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4087355733, green: 0.3312071562, blue: 0.2074120343, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    var plusButton: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        
        config.title = "추가"
        config.cornerStyle = .capsule
        config.baseBackgroundColor = #colorLiteral(red: 0.4087355733, green: 0.3312071562, blue: 0.2074120343, alpha: 1)
        
        view.configuration = config
        
        return view
    }()
    
    let insertTextField: UITextField = {
        let view = UITextField()
        view.attributedPlaceholder = NSAttributedString(string: "  사고싶은 항목을 적고, 추가 버튼을 클릭해주세요  ", attributes: CustomFont.attributes as [NSAttributedString.Key : Any])
        view.backgroundColor = #colorLiteral(red: 0.4087355733, green: 0.3312071562, blue: 0.2074120343, alpha: 1)
        
        return view
    }()
    
    
    override func configureUI() {
        self.addSubview(calendar)
        self.addSubview(tableView)
       
        tableView.addSubview(headerview)
        headerview.addSubview(topContainView)
        [topContainSubView, plusButton].forEach { topContainView.addSubview($0) }
        topContainSubView.addSubview(insertTextField)
    }
    
    override func setConstraints() {
        
        calendar.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(self).offset(0)
            make.height.equalTo(400)
            
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self).offset(0)
            make.top.equalTo(calendar.snp.bottom).offset(0)
        }
        
        topContainView.snp.makeConstraints { make in
            make.centerY.equalTo(headerview)
            make.trailing.equalTo(headerview.snp.trailing).offset(0)
            make.leading.equalTo(headerview.snp.leading).offset(0)
            make.height.equalTo(80)
        }
        
        topContainSubView.snp.makeConstraints { make in
            make.top.equalTo(topContainView.snp.top).offset(8)
            make.bottom.equalTo(topContainView.snp.bottom).offset(-8)
            make.trailing.equalTo(plusButton.snp.leading).offset(-8)
            make.leading.equalTo(topContainView.snp.leading).offset(8)
        }
        
        insertTextField.snp.makeConstraints { make in
            make.top.equalTo(topContainSubView.snp.top).offset(8)
            make.bottom.equalTo(topContainSubView.snp.bottom).offset(-8)
            make.trailing.equalTo(topContainSubView.snp.trailing).offset(-8)
            make.leading.equalTo(topContainSubView.snp.leading).offset(8)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalTo(topContainView.snp.trailing).offset(-8)
            make.leading.equalTo(topContainSubView.snp.trailing).offset(8)
            make.centerY.equalTo(insertTextField)
            make.height.equalTo(44)
            make.width.equalTo(60)
        }
    }
}
