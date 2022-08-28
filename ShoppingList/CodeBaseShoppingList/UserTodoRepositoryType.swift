//
//  UserTodoRepositoryType.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/28.
//

import Foundation
import RealmSwift
import UIKit

enum PathComponentName: String {
    case todoImageFolder
}

protocol UserTodoRepositoryType {
    //MARK: 테이블 구성
    func fetch() -> Results<UserTodo>
    func fetchSort(_ sort: String, ascending: Bool) -> Results<UserTodo>
    func fetchFilter(filter: String) -> Results<UserTodo>
    func fetchFilterDate(date: Date) -> Results<UserTodo>
    func updateFavorite(item: UserTodo)
    func updateCheckbox(item: UserTodo)
    func deleteRecord(item: UserTodo)
    //MARK: 백업
    func documentDirectoryPath() -> URL?
    func checkDocumentLocation() -> URL
    func loadImageFromDocument(fileName: String) -> UIImage?
    func loadImageFromFolder(fileName: String, folderName: PathComponentName) -> UIImage?
    func removeImageFromDocument(fileName: String)
    func removeImageFromFolder(fileName: String, folderName: PathComponentName)
    func saveImageToDocument(fileName: String, image: UIImage)
    func saveImageToFolder(foldername: PathComponentName, filename: String, image: UIImage)
    func fetchDocumentZipFile()
}

class UserTodoRepository: UserTodoRepositoryType {
    
    
    var localRealm = try! Realm() 
        
        @discardableResult
        func fetch() -> Results<UserTodo> {
            return localRealm.objects(UserTodo.self).sorted(byKeyPath: "todoTitle", ascending: true)
        }
        
        func fetchSort(_ sort: String, ascending: Bool) -> Results<UserTodo> {
            localRealm.objects(UserTodo.self).sorted(byKeyPath: sort, ascending: ascending)
        }
        
        func fetchFilterDate(date: Date) -> Results<UserTodo> {
            return localRealm.objects(UserTodo.self).filter("todoDate >= %@ AND todoDate < %@", date, Date(timeInterval: 86400, since: date))
        }
        
        func fetchFilter(filter: String) -> Results<UserTodo> {
            return localRealm.objects(UserTodo.self).filter(filter)
        }
        
        func updateFavorite(item: UserTodo) {
            do {
                try localRealm.write {
                    item.favorite = !item.favorite
                }
            } catch {
                print("=====> 즐겨찾기 버튼을 수정할 수 없습니다.")
            }
        }
        
        func updateCheckbox(item: UserTodo) {
            do {
                try localRealm.write({
                    item.checkbox = !item.checkbox
                })
            } catch {
                print("====> 체크박스를 수정할 수 없습니다.")
            }
        }
        
        func deleteRecord(item: UserTodo) {
            do {
                try localRealm.write({
                    localRealm.delete(item)
                })
            } catch {
                print("====> 해당 레코드를 삭제하지 못했습니다")
            }
        }
        
        //MARK: 백업함수
        
        func documentDirectoryPath() -> URL? {
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
            
            return documentDirectory
        }
        
        func checkDocumentLocation() -> URL {
            guard let path = documentDirectoryPath() else {
                print("===> 도큐먼트 위치에 오류가 있습니다.")
                return URL(fileURLWithPath: "")
            }
            return path
        }
        
        func loadImageFromDocument(fileName: String) -> UIImage? {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
            let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            } else {
                return UIImage(systemName: "xmark")
            }
            
            let image = UIImage(contentsOfFile: fileURL.path)
            return image
        }
        
        func loadImageFromFolder(fileName: String, folderName: PathComponentName) -> UIImage? {
            guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
            let folderURL = documentsFolder.appendingPathComponent(folderName.rawValue)
            let fileURL = folderURL.appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
                
            } else {
                return UIImage(systemName: "person.fill.questionmark")
            }
        }
        
        func removeImageFromDocument(fileName: String) {
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error {
                print(error)
            }
        }
        
        func removeImageFromFolder(fileName: String, folderName: PathComponentName) {
            guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let folderURL = documentsFolder.appendingPathComponent(folderName.rawValue)
            let fileURL = folderURL.appendingPathComponent(fileName)
            
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch let error {
                print(error)
            }
        }
        
        func saveImageToDocument(fileName: String, image: UIImage) {
            guard let documentdirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileURL = documentdirectory.appendingPathComponent(fileName) // 이미지에 유알엘을 만들어줌
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            
            do {
                try data.write(to: fileURL) // 그 유알엘을 이미지에 매칭해줌
            } catch let error {
                print("file save error", error)
            }
            
            //어떻게 매칭해줘? 그 유알엘 자체가 저장해주는 역할임~ 유알엘만드는 자체가 해당 도큐에 저장하는 것
        }
        
        func saveImageToFolder(foldername: PathComponentName, filename: String, image: UIImage) {
            
            guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let folderURL = documentsFolder.appendingPathComponent(foldername.rawValue)
            let folderExists = (try? folderURL.checkResourceIsReachable()) ?? false // 폴더에 도달 가능?
            
            do { //try문이기 땜눈에 do
                if !folderExists { // 도달가능해
                    // 그럼 그 url에 해당하는 폴더 만들어
                    try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: false)
                }
                let fileURL = folderURL.appendingPathComponent(filename) // 파일 경로 생성 및 저장
                guard let data = image.jpegData(compressionQuality: 0.8) else { return }
                
                do {
                    try data.write(to: fileURL)
                } catch {
                    print(error, "====> 해당 이미지를 URL로 수정할 수 없습니다.")
                }
            } catch { print("=====> 이미지 폴더를 만들 수 없습니다") }
        }
        
        func fetchDocumentZipFile()  {
            
            do {
                guard let path = documentDirectoryPath() else { return } //도큐먼트 경로 가져옴
                
                //            let docs = try FileManager.default.contentsOfDirectory(atPath: <#T##String#>) 내부에서 알 수 있는 경로의 제약이 좀더 있음, 그래서 Url로 받아오는 아래걸 많이 씀
                let docs =  try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
                print("👉 docs: \(docs)") //도큐먼트 안에 있는 파일들
                
                let zip = docs.filter { $0.pathExtension == "zip" } //압축 파일의 확장자가 zip인 것만 가져옴
                print("👉 zip: \(zip)")
                
                let result = zip.map { $0.lastPathComponent } //경로 다 보여줄 필요 없으니까 마지막 확장자를 string으로 가져오는 것
                print("👉 result: \(result)") // 오 이렇게 하면 폴더로 만들어서 관리하기도 쉬울듯
                
                //            return result //zip파일의 구성요소가 담긴
            } catch {
                
                print("Error🔴")
            }
        }}
