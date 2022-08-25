//
//  Extension.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/25.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case presentNavigationFull
        case presentOverFullScreen
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle) {
        switch transitionStyle {
            
        case .present:
            self.present(viewController, animated: true)
            
        case .presentNavigationFull:
            let vc = viewController
            let nav = UINavigationController(rootViewController: viewController)
            vc.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            
        case .presentOverFullScreen:
            let vc = viewController
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

