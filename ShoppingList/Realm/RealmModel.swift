//
//  RealmModel.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/22.
//

import UIKit
import RealmSwift

//MARK: 테이블 구성하기
// 즐겨찾기 기능 구현해보기
class UserTodo: Object {
    @Persisted var todoTitle: String
    @Persisted var todoDate = Date()
    @Persisted var favorite: Bool
    @Persisted var checkbox: Bool

//MARK: pk 만들기
@Persisted(primaryKey: true) var objectID: ObjectId

//MARK: 이니셜라이즈
    convenience init(todoTitle: String, todoDate: Date) {
    self.init()
    self.todoTitle = todoTitle
    self.todoDate = todoDate
    self.favorite = false
    self.checkbox = false
}
}
