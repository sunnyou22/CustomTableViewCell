//
//  BaseViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import Foundation
import UIKit
import RealmSwift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        debugFuction()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func debugFuction() {
    
}
}
