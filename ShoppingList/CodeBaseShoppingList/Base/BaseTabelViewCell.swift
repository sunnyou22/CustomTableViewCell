//
//  BaseTabelViewCell.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//왜 여기에 하면 안돼? - UI등이 나중에 잡히는 데 미리 함수를 호출하고 있는 거임...?
        //        configure()
//        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() { }
    func setConstraints() { }
}
