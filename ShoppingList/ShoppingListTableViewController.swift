//
//  ShoppingListTableViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/07/19.
//

import UIKit

class ShoppingListTableViewController: UITableViewController {
    @IBOutlet weak var inputBtn: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    var list = ["그립톡 구매하기", "사이다구매", "아이패드 케이스 최저가 알아보기", "양말"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        inputBtn.configuration = .gray()
        inputBtn.backgroundColor = .systemGray5
        inputBtn.clipsToBounds = true
        inputBtn.layer.cornerRadius = 10
        inputBtn.setTitle("추가", for: .normal)
        inputBtn.setTitleColor(.black, for: .normal)
        
        // 버튼투명도 설정 알려주실때 타이틀은 안 투명하게 할 수 있는 방법을 알려주셨던 것 같은데... 뭐였더라
        // 버튼 타이틀 센터로 맞추는 코드 뭐였더라
        
        inputTextField.placeholder = "무엇을 구매하실 건가요?"
        inputTextField.borderStyle = .none
        inputTextField.layer.cornerRadius = 10
        inputTextField.backgroundColor = .systemGray6
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        //CGRect  사각형의 위치와 크기를 포함하는 구조체
        inputTextField.leftViewMode = .always
    }
    
    @IBAction func inputItemTextField(_ sender: UITextField) {
        view.endEditing(true)
    }
    
    @IBAction func insertItemToList(_ sender: UIButton) {
        list.append(inputTextField.text!)
        print(list)
        tableView.reloadData()
    }
    
    //MARK: - 이게 무 ㅓ더라
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = UIColor.gray
//        view.frame(forAlignmentRect: CGRect(x: 0, y: 3, width: 20, height: 1))
//        return view
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        list.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "   "
    //    } -> 편법
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopptingListTableViewCell", for: indexPath) as! ShopptingListTableViewCell // 타입캐스팅 얼른 배우고싶다
        
        cell.backgroundColor = .systemGray6
        
        cell.checkImage.image = indexPath.section == 0 ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        
        indexPath.section == 1 ? cell.favoritesBtn.setImage(UIImage(systemName: "star"), for: .normal) : cell.favoritesBtn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        cell.todoLabel.text = list[indexPath.section]
        
//        tableView.sectionFooterHeight = 40
//        tableView.sectionHeaderHeight = 4
//        tableView.separatorStyle = .singleLine
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.separatorInsetReference = .fromAutomaticInsets
//        tableView.separatorColor = .gray
        
        
        //        cell.separatorInset = .init(top: -30, left: -30, bottom: -30, right: -30)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    } // 편집기능을 넣어줄거야 이게 있어야 삭제도 편집도 가능함
    //canEditRowAt이 있어야 스와이프 삭제도 가능한 건가요? 넹
    
    //우측 스와이프 디폴트 기능
    //요즘 잘 안쓰는데 남아있음
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 배열 삭제 후 테이블 뷰 갱신(데이터 먼저 삭제해주는 거임)
            
            
            list.remove(at: indexPath.row)
            tableView.reloadData()
            
//            tableView.reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableView.RowAnimation#>) // -> 테스트해보기
        }
    }
}
