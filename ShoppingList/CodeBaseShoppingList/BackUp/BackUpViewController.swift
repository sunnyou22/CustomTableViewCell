//
//  BackUpViewController.swift
//  ShoppingList
//
//  Created by 방선우 on 2022/08/25.
//

import UIKit
import Zip

class BackUpViewController: BaseViewController {
    
    static let zipFileName = "ShoppingList_1.zip"
    static let fileName = "ShoppingList_1"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let backup = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        let restore = UIBarButtonItem(title: "복구", style: .plain, target: self, action: #selector(restoreButtonClicked))
        
        navigationItem.rightBarButtonItems = [backup, restore]
    }

    @objc func backupButtonClicked() {
     
        var urlPath = [URL]()
        
        //도큐 위치
        let path = checkDocumentLocation()
        
        //도큐안의 파일 경로
        let realmFile = path.appendingPathComponent("default.realm")
    
    //위의 경로로 백업파일 유무
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlert(title: "벡업할 파일이 없습니다.")
            return
        }
        
        urlPath.append(URL(string: realmFile.path)!)
        
        do { // 백업파일 압축하기
            let zipFilePath = try Zip.quickZipFiles(urlPath, fileName: BackUpViewController.zipFileName) // 확장자 잊지 않기
            print("Archive Location: \(zipFilePath)")
        } catch {
            showAlert(title: "🧨압축을 실패했습니다")
        }
        
        //ActicvityViewController 띄우기
        showActivityViewController()
    }
    
    //액티비티 뷰컨 띄우기
    func showActivityViewController() {
        
        //도큐먼트 위치에 백업 파일 확인
        let path = checkDocumentLocation()
        let backupFileURL = path.appendingPathComponent(BackUpViewController.zipFileName)
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    @objc func restoreButtonClicked() {
        let documentPicjer = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicjer.delegate = self
        documentPicjer.allowsMultipleSelection = false
        self.present(documentPicjer, animated: true)
    }
}

extension BackUpViewController: UIDocumentPickerDelegate {
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("도큐먼트 픽커 닫음", #function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 우리가 백업파일을 url배열로 저장했으니까 파라미터가 배열임
        // 배열안에 url이 있는지 먼저 확인
        guard let selecteeFileURL = urls.first else {
            showAlert(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        // 도큐 경로가져오기
       let path = checkDocumentLocation()
        
            // 복구하고자하는 파일의 마지막 컴포넌트 가져옴
        let sandBoxFileURL = path.appendingPathComponent(selecteeFileURL.lastPathComponent)
        print(selecteeFileURL.lastPathComponent)
        
        //복구할 파일이 있는지 확인 - 1. 경로확인
        if FileManager.default.fileExists(atPath: sandBoxFileURL.path) {
            
            let fileURL = path.appendingPathComponent(BackUpViewController.fileName)
            
            do { // 만약에 도큐먼트에 백업파일을 저장했다면 ?
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    self.showAlert(title: "=====복구 완료 =====🟢")
                })
            } catch {
                showAlert(title: "====🔴 압축해제 실패=====")
            }
        } else {
             
            do { //파일앱에 저장했다면?
                
                try FileManager.default.copyItem(at: selecteeFileURL, to: sandBoxFileURL)
                
                let filURL = path.appendingPathComponent(BackUpViewController.zipFileName)
                
                try Zip.unzipFile(selecteeFileURL, destination: sandBoxFileURL, overwrite: true, password: nil, progress: { progress in
                    print("pregress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    self.showAlert(title: "=====복구 완료 =====🟢")
                })
            } catch {
                showAlert(title: "====🔴 압축해제 실패=====")
            }
        }
    }
}
