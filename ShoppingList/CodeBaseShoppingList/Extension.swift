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

extension UIViewController {
    func documentDirectoryPath() -> URL? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        
        return documentDirectory
    }
    
    
    func checkDocumentLocation() -> URL {
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다.")
            return URL(fileURLWithPath: "")
        }
        return path
    }
    
    func fetchDocumentZipFile() {
        
        do {
            guard let path = documentDirectoryPath() else { return } //도큐먼트 경로 가져옴
            
//            let docs = try FileManager.default.contentsOfDirectory(atPath: <#T##String#>) 내부에서 알 수 있는 경로의 제약이 좀더 있음, 그래서 Url로 받아오는 아래걸 많이 씀
            let docs =  try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("👉 docs: \(docs)")
            
            let zip = docs.filter { $0.pathExtension == "zip" } //확장자가 모얀
            print("👉 zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent } //경로 다 보여줄 필요 없으니까 마지막 확장자를 string으로 가져오는 것
            print("👉 result: \(result)") // 오 이렇게 하면 폴더로 만들어서 관리하기도 쉬울듯
            
            
        } catch {
            print("Error🔴")
        }
    }
}

extension UIViewController {
    func showAlert(title: String, button: String = "네") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
}


