//
//  ReusableProtocol.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import Foundation
import UIKit

protocol ReusableIdentifier {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
