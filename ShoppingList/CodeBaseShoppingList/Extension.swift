//
//  Extension.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/25.
//

import UIKit
import FSCalendar

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
    
    func showAlert(title: String, button: String = "네") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
}

extension ShoppingListViewController: FSCalendarDelegate, FSCalendarDataSource {

    // 달력칸에 있는 동그라미 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchFilterDate(date: date).count
    }
    
//    // 달력칸 안에 있는 제목
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        <#code#>
//    }
//
//    //이미지
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        <#code#>
//    }
//
//    //달력칸 크기변경 - 컬렉션뷰라 ㄱ ㅏ능
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        <#code#>
//    }
    
    //subtitle
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        // 특정한 날을 받아오는 코드 구현하기
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }
    
    //날짜를 기준으로 해서 특정 셀만 보여주도록 하기
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchFilterDate(date: date)
        mainview.tableView.reloadData()
    }
}
