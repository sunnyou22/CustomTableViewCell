//
//  PHPViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/26.
//

import UIKit
import PhotosUI
import Photos

extension ShoppingListViewController {
    
    func checkAccessLevel() {
        let accessLevel : PHAccessLevel = .readWrite
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
        
        switch authorizationStatus {
        case .authorized:
            print("=====>권한허가")
        case .limited:
            print("====>제한된 권한")
        default:
            print("=====>권한체크 기본")
        }
    }
    
    func setAccessLevel() {
        
        let requireAccessLevel: PHAccessLevel = .readWrite
        
        PHPhotoLibrary.requestAuthorization(for: requireAccessLevel) { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                print("=====> 권한 허락됨")
            case .limited:
                print("=====> 제한된 사진만 허용")
            default:
                print("=====> 권한설저 기본")
            }
        }
    }
        
        @objc func buttonClicked(_ sender: UIBarButtonItem) {
            checkAccessLevel()
            setAccessLevel()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images, .videos])
            
            //갤러리
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true)
        }
}

extension ShoppingListViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 사진 고르면 반영해주기
        picker.dismiss(animated: true)
    
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (img, error) in
                DispatchQueue.main.async {
                   self.selectedImage?.image = img as? UIImage
                    print("====> 이미지선택 완료")
                    print(img) // 이미지는 잘 들어옴
                    self.mainview.tableView.reloadData()
                }
            }
        }
    }
    
}
