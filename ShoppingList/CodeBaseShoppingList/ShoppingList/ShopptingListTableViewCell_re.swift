//
//  ShopptingListTableViewCell.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift
import SwiftUI

class ShopptingListTableViewCell_re: BaseTableViewCell {
    
    let containView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9610450864, green: 0.8862027526, blue: 0.7589734197, alpha: 1)
        return view
    }()
    
    let checkBox: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark.square")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    let todoLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    let favoriteButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        return view
    }()
    
    var selectedImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [checkBox, todoLabel, favoriteButton, selectedImageView].forEach { containView.addSubview($0) }
        contentView.addSubview(containView)
        self.addSubview(contentView)
    }
    
    override func setConstraints() {
        containView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        checkBox.snp.makeConstraints { make in
            make.top.equalTo(containView.snp.top).offset(16)
            make.leading.equalTo(containView.snp.leading).offset(16)
            make.bottom.equalTo(containView.snp.bottom).offset(-16)
            make.width.equalTo(checkBox.snp.height).multipliedBy(1)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.top.equalTo(containView.snp.top).offset(16)
            make.bottom.equalTo(containView.snp.bottom).offset(-16)
            make.leading.equalTo(checkBox.snp.trailing).offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(todoLabel)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.centerY.equalTo(todoLabel)
            make.leading.equalTo(favoriteButton.snp.trailing).offset(8)
            make.trailing.equalTo(containView.snp.trailing).offset(8)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    
}
