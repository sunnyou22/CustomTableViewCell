//
//  BaseViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    func configure() { }
    func setConstraints() { }
}
