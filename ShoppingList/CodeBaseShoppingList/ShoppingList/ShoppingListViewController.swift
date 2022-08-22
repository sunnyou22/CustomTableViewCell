//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift

class ShoppingListViewController: BaseViewController {
    
    let mainview = ShoppingListView()
    let localRealm = try! Realm() // Realm2 데이터베이스에 테이블 수정추가 등 반영해주기 위한 선언
    var tasks: Results<UserTodo>!
    
    override func loadView() {
        self.view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        mainview.tableView.register(ShopptingListTableViewCell_re.self, forCellReuseIdentifier: ShopptingListTableViewCell_re.reuseIdentifier)
        
        tasks = localRealm.objects(UserTodo.self).sorted(byKeyPath: "addTodo", ascending: false)
        print(tasks)
        print(tasks.count)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    
//        mainview.tableView.reloadData()
        
    }
    
    override func configure() {
        mainview.plusButton.addTarget(self, action: #selector(pulsRowTodoList), for: .touchUpInside)
        mainview.insertTextField.addTarget(self, action: #selector(doEndEaditing), for: .touchUpInside)
    }
    
    @objc func pulsRowTodoList() {
        let task = UserTodo(todoTitle: mainview.insertTextField.text!)
        print(task)
        print(#function)
        try! localRealm.write {
            localRealm.add(task)
            print("림 성공쓰")
            
            mainview.tableView.reloadData()
            print(task)
        }
    }
    
    @objc func doEndEaditing() {
        view.endEditing(true)
    }
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        let frame = CGRect(x: 0, y: 5, width: 414, height: 1)
//        view.backgroundColor = UIColor.gray
//
//        view.frame(forAlignmentRect: frame)
//        return view
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }

//    func updateLayout() {
//        self.mainview.setNeedsLayout()
//        self.mainview.layoutIfNeeded()
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
       return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopptingListTableViewCell_re.reuseIdentifier, for: indexPath) as! ShopptingListTableViewCell_re // 타입캐스팅 얼른 배우고싶다
        
        cell.backgroundColor = .systemGray6
   
        cell.todoLabel.text = tasks[indexPath.row].addTodo
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let item = tasks?[indexPath.row]
               try! localRealm.write {
                   localRealm.delete(item!)
               }
               tableView.reloadData()
           }
       }
}
