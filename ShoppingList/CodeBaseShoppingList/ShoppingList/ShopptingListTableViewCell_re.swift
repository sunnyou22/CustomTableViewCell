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
    
    let localRealm = try! Realm()
    var tasks: Results<UserTodo>!
    
    let containView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageview: UIImageView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [imageview, todoLabel, favoriteButton].forEach { containView.addSubview($0) }
        self.addSubview(containView)
    }
    
    override func setConstraints() {
        containView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(4)
            make.bottom.equalTo(self.snp.bottom).offset(4)
            make.trailing.equalTo(self.snp.trailing).offset(20)
            make.leading.equalTo(self).offset(20)
        }
        
        imageview.snp.makeConstraints { make in
            make.top.equalTo(containView.snp.top).offset(16)
            make.leading.equalTo(containView.snp.leading).offset(16)
            make.bottom.equalTo(containView.snp.bottom).offset(-16)
            make.width.equalTo(imageview.snp.height).multipliedBy(1)
        }
        
        todoLabel.snp.makeConstraints { make in
            make.top.equalTo(containView.snp.top).offset(16)
            make.bottom.equalTo(containView.snp.bottom).offset(-16)
            make.leading.equalTo(imageview.snp.trailing).offset(16)
            make.trailing.equalTo(favoriteButton.snp.leading).offset(-16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(containView.snp.top).offset(8)
            make.bottom.equalTo(containView.snp.bottom).offset(8)
        }
    }
    
    
}
