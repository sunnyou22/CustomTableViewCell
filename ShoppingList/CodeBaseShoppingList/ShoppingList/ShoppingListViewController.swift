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
    let headerview = UIView()
    let localRealm = try! Realm() // Realm2 데이터베이스에 테이블 수정추가 등 반영해주기 위한 선언
    var tasks: Results<UserTodo>!
    var cellIndex: Int?
    
    override func loadView() {
        self.view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = UserTodo(todoTitle: "쌀사기")
        try! localRealm.write {
            localRealm.add(task)
        }
        
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
       
        mainview.tableView.tableHeaderView = headerview
        
        mainview.tableView.register(ShopptingListTableViewCell_re.self, forCellReuseIdentifier: ShopptingListTableViewCell_re.reuseIdentifier)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)

        view.backgroundColor = .systemBlue
        
        headerview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        headerview.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainview.tableView.reloadData()
    }
    
    override func configure() {
        mainview.plusButton.addTarget(self, action: #selector(pulsRowTodoList), for: .touchUpInside)
        mainview.insertTextField.addTarget(self, action: #selector(doEndEaditing), for: .touchUpInside)
        
//        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
//        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", image: nil, primaryAction: nil, menu: sortMenu)
//        let filterButton = UIBarButtonItem(title: "필터", image: nil, primaryAction: nil, menu: <#T##UIMenu?#>)
        navigationItem.leftBarButtonItem = sortButton
    }
    
    var sortmenuItemList: [UIAction] {
        return [
            UIAction(title: "즐겨찾기", image: UIImage(systemName: "star.fill"), identifier: nil, state: .on) { [self] _ in
                tasks = localRealm.objects(UserTodo.self).sorted(byKeyPath: "favorite", ascending: true)
            },
            UIAction(title: "할일 완료된 순", image: nil, identifier: nil, state: .on) { [self] _ in
                tasks = localRealm.objects(UserTodo.self).sorted(byKeyPath: "checkbox")
            },
            UIAction(title: "제목순", image: nil, identifier: nil, state: .off) { [self] _ in
                tasks = localRealm.objects(UserTodo.self).sorted(byKeyPath: "todoTitle")
            }
        ]
    }
    
    var sortMenu: UIMenu {
        //해당 셀이 즐겨찾기가 돼있는지 여부에 따라 on/off 정하기
        let sortMenu = UIMenu(title: "정렬기준", subtitle: nil, image: nil, identifier: nil, options: .destructive, children: sortmenuItemList)
        
        return sortMenu
    }
    
    @objc func sortButtonClicked() {
       
    }
    
    @objc func filterButtonClicked() {
        
        
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

//    func updateLayout() {
//        self.mainview.setNeedsLayout()
//        self.mainview.layoutIfNeeded()
//    }
//
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 이렇게 전체 데이터를 가져오는 등의 과정이 필요함. 화면과 데이터는 따로
        tasks = localRealm.objects(UserTodo.self).sorted(byKeyPath: "todoTitle", ascending: true)
        print(tasks.count)
       return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopptingListTableViewCell_re.reuseIdentifier, for: indexPath) as! ShopptingListTableViewCell_re
        
        cellIndex = indexPath.row
        cell.backgroundColor = .systemGray6
        cell.todoLabel.text = tasks[indexPath.row].todoTitle
        cell.favoriteButton.addTarget(self, action: #selector(clickedfavoriteButton), for: .touchUpInside)
        let image = tasks[cellIndex!].favorite ? "star.fill" : "star"
        cell.favoriteButton.imageView?.image = UIImage(systemName: image)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopptingListTableViewCell_re.reuseIdentifier, for: indexPath) as! ShopptingListTableViewCell_re
        try! self.localRealm.write({
            self.tasks[indexPath.row].checkbox = !self.tasks[indexPath.row].checkbox
        })
        let image = tasks[indexPath.row].checkbox ? "checkmark.square.fill" : "checkmark.square"
        cell.imageview.image = UIImage(systemName: image)
    }

     // 편집기능을 넣어줄거야 이게 있어야 삭제도 편집도 가능함
    //canEditRowAt이 있어야 스와이프 삭제도 가능한 건가요? 넹
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete {
               let item = tasks?[indexPath.row]
               try! localRealm.write {
                   localRealm.delete(item!)
               }
               tableView.reloadData()
           }
       }
    
    @objc
    func clickedfavoriteButton() {
        
        try! self.localRealm.write({
            self.tasks[cellIndex!].favorite = !self.tasks[cellIndex!].favorite
        })
    }
    
    //MARK: 질문 이걸 넣어주지 않아도 괜찮으넉? 아예 넣을 수 없다고 뜨긴함 -> 알아보기
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
