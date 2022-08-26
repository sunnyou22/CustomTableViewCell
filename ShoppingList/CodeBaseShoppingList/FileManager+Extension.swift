//
//  FileManager+Extension.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/24.
//

import Foundation
import UIKit

extension UIViewController {
   
    //도큐먼트에서 이미지 가져와 로드하기
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

    // 도큐먼트에 잇는 이미지 삭제하기
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.fileExists(atPath: fileURL.path)
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
}
