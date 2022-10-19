//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import SnapKit
import RealmSwift
import PhotosUI

class ShoppingListViewController: BaseViewController {
    var repository = UserTodoRepository()
    
    let mainview = ShoppingListView()
//    var localRealm = try! Realm() // Realm2 데이터베이스에 테이블 수정추가 등 반영해주기 위한 선언
//    var tasks: Results<UserTodo>! {
//        didSet {
//            mainview.tableView.reloadData()
//        }
//    }
    var configuration = PHPickerConfiguration()
    var selectedImage: UIImage?
    var objectID: ObjectId?

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    var tasks: Results<UserTodo>! {
        didSet {
            mainview.tableView.reloadData()
        }
    }
    
    //MARK: 로드뷰
    override func loadView() {
        self.view = mainview
    }
    
    //MARK: 뷰디드로드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...50 {
            let task = UserTodo(todoTitle: "마이그레이션즁즁", todoDate: Date())
            
            do {
                try  UserTodoRepository.shared.localRealm.write {
                    UserTodoRepository.shared.localRealm.add(task)
                }
            } catch {
                print(error)
            }
        }
        
        print(#function)
        repository.fetchDocumentZipFile()
        mainview.headerview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        mainview.headerview.backgroundColor = #colorLiteral(red: 0.9610450864, green: 0.8862027526, blue: 0.7589734197, alpha: 1)
        mainview.headerview.layoutIfNeeded()
        mainview.tableView.tableHeaderView = mainview.headerview
        mainview.tableView.delegate = self
        mainview.tableView.dataSource = self
        mainview.calendar.delegate = self
        mainview.calendar.dataSource = self
        
        mainview.tableView.register(ShopptingListTableViewCell_re.self, forCellReuseIdentifier: ShopptingListTableViewCell_re.reuseIdentifier)
        
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
        
        view.backgroundColor = .systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("=====>", #function)
        
        fetchRealm()
        mainview.tableView.reloadData()
        print("Realm is located at:", repository.localRealm.configuration.fileURL!)
    }
 
    func fetchRealm() {
        
        // Realm3. 데이터를 정렬해 tasks에 담기
        tasks = repository.fetch()
    }
    
    override func configure() {
        mainview.plusButton.addTarget(self, action: #selector(pulsRowTodoList), for: .touchUpInside)
        mainview.insertTextField.addTarget(self, action: #selector(doEndEditing), for: .editingDidEndOnExit)
        
        
        //        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        //        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        
        
        let setting = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(gosetting))
        let cameraButton = UIBarButtonItem(title: "카메라", style: .plain, target: self, action: #selector(buttonClicked(_:)))
        
        navigationItem.rightBarButtonItems = [setting, cameraButton]
        
        let sortButton = UIBarButtonItem(title: "정렬", image: nil, primaryAction: nil, menu: sortMenu)
        //        let filterButton = UIBarButtonItem(title: "필터", image: nil, primaryAction: nil, menu: <#T##UIMenu?#>)
        
        navigationItem.leftBarButtonItem = sortButton
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
        
    }
    
    var sortmenuItemList: [UIAction] {
        return [
            UIAction(title: "즐겨찾기", image: UIImage(systemName: "star.fill"), identifier: nil, state: .on) { [self] _ in
                tasks = repository.fetchSort("favorite", ascending: true)
            },
            UIAction(title: "할일 완료된 순", image: nil, identifier: nil, state: .on) { [self] _ in
                tasks = repository.fetchSort("checkbox", ascending: true)
            },
            UIAction(title: "제목순", image: nil, identifier: nil, state: .off) { [self] _ in
                fetchRealm()
            }
        ]
    }
    
    var sortMenu: UIMenu {
        //해당 셀이 즐겨찾기가 돼있는지 여부에 따라 on/off 정하기
        let sortMenu = UIMenu(title: "정렬기준", subtitle: nil, image: nil, identifier: nil, options: .destructive, children: sortmenuItemList)
        
        return sortMenu
    }
    
    //MARK: 네이바버튼 구현
    @objc func sortButtonClicked() {
        
    }
    
    @objc func filterButtonClicked() {
        
        
    }
    
    @objc func gosetting() {
        let vc = BackUpViewController()
        transition(vc, transitionStyle: .push)
    }
    
    @objc func pulsRowTodoList() {
        // 이렇게 전체 데이터를 가져오는 등의 과정이 필요함. 화면과 데이터는 따로
        let task = UserTodo(todoTitle: mainview.insertTextField.text!, todoDate: Date())
        self.objectID = task.objectID
        
        print(task)
        print(#function)
        
        do {
            try repository.localRealm.write {
                repository.localRealm.add(task)
                print("림 성공쓰")
            }
        } catch let error {
            print("텍스트 필드 림, \(error)")
        }
        
        fetchRealm() // 여기서 수정된 테이블 가져오기
        mainview.tableView.resignFirstResponder()
        mainview.insertTextField.text = nil
    }
    
    @objc func doEndEditing() {
        mainview.insertTextField.resignFirstResponder()
    }
}

//MARK: - 테이블
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
        print(#function)
        print("🔴", repository.localRealm.objects(UserTodo.self))
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(#function)
            print("🔴", repository.localRealm.objects(UserTodo.self))
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
                print("🔴", repository.localRealm.objects(UserTodo.self))
        print(tasks.count)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
                    print("🔴", repository.localRealm.objects(UserTodo.self))
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopptingListTableViewCell_re.reuseIdentifier, for: indexPath) as! ShopptingListTableViewCell_re
        let row = tasks[indexPath.row]
      
        
        //이미지 받아오기
        
        cell.backgroundColor = .systemGray6
        cell.todoLabel.text = row.todoTitle
        
        cell.favoriteButton.tag = indexPath.row
        cell.checkBox.tag = indexPath.row
        cell.selectedImageView.tag  = indexPath.row
        
        cell.favoriteButton.addTarget(self, action: #selector(clickedfavoriteButton(_:)), for: .touchUpInside)
        
        let image = row.favorite ? "star.fill" : "star"
        cell.favoriteButton.setImage( UIImage(systemName: image), for: .normal)
        let image1 = row.checkbox ? "checkmark.square.fill" : "checkmark.square"
        cell.checkBox.image = UIImage(systemName: image1)
        cell.separatorInset.left = 0
        
        cell.selectedImageView.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        //코드위치 중요
        
        cell.selectedImageView.setImage(loadImageFromFolder(fileName: "\(row.objectID).jpg", folderName: .todoImageFolder), for: .normal)

        print(#function, "======>", objectID, row.objectID)
        return cell
    }
    
    @objc
    func clickedfavoriteButton(_ sender: UIButton) {
        let taskIndex = tasks[sender.tag]
        
        repository.updateFavorite(item: taskIndex)
        
//
//        try! localRealm.write({
//            //            taskIndex.favorite.toggle()
//            taskIndex.favorite = !taskIndex.favorite
//
//            //            self.localRealm.create(UserTodo.self,
//            //                             value: ["objectID": self.tasks[indexPath.row].objectId, "favorite": ],
//            //                             update: .modified)
//        })
        mainview.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskindex = tasks[indexPath.row]
        
        repository.updateCheckbox(item: taskindex)
            mainview.tableView.reloadData()
        
    }
    
    // 편집기능을 넣어줄거야 이게 있어야 삭제도 편집도 가능함
    //canEditRowAt이 있어야 스와이프 삭제도 가능한 건가요? 넹
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = tasks?[indexPath.row]
        
        repository.removeImageFromFolder(fileName: "\(item!.objectID).jpg", folderName: .todoImageFolder)
        
        if editingStyle == .delete {
            repository.deleteRecord(item: item!)
        }
        //        fetchData()
                tableView.reloadData()
    }
    
    //MARK: 질문 이걸 넣어주지 않아도 괜찮으넉? 아예 넣을 수 없다고 뜨긴함 -> 알아보기
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
