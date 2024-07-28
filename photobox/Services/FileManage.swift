//
//  FileManage.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import UIKit
import Kingfisher

final class FileManageService: ServiceProtocol {
    static let shared = FileManageService()
    
    private let filemanager = FileManager.default
    
    enum FileManageError: String, Error {
        case directoryError = "저장 위치를 찾을 수 없어요"
        case imageError = "이미지를 확인할 수 없어요"
        case compressionError = "이미지를 압축할 수 없어요"
        case saveError = "이미지를 저장할 수 없어요"
        case findError = "이미지를 찾을 수 없어요"
        case deleteError = "이미지를 삭제할 수 없어요"
    }
    
    private init() {}
    
    func saveImage(for imageURL: String, by name: String) -> Result<String, FileManageError> {
        guard let directory = filemanager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            return .failure(.directoryError)
        }
        
        let filePath = directory.appendingPathComponent(name, conformingTo: .jpeg)
        
        if let url = URL(string: imageURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            let compressedData = image.jpegData(compressionQuality: 0.5)
                            do {
                                try compressedData?.write(to: filePath)
                            } catch {
                                return
                            }
                        }
                    }
                }
            }
            return .success("저장성공")
        } else {
            return .failure(.saveError)
        }
    }
    
    func getImage(for name: String) -> Result<String, FileManageError> {
        guard let directory = filemanager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            return .failure(.directoryError)
        }
        
        let filePath = directory.appendingPathComponent(name, conformingTo: .jpeg)
        
        if filemanager.fileExists(atPath: filePath.path) {
            return .success(filePath.path)
        } else {
            return .failure(.findError)
        }
    }
    
    func getImages() -> Result<[String]?, FileManageError> {
        guard let directory = filemanager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            return .failure(.directoryError)
        }
        
        do {
            let fileURLs = try filemanager.contentsOfDirectory(
                at: directory, includingPropertiesForKeys: nil
            )
            let imageURLs = fileURLs.filter { $0.pathExtension.lowercased() == "jpeg" }
            let images = imageURLs.compactMap { $0.path }

            return .success(images)
        
        } catch {
            return .failure(.findError)
        }
    }
    
    func removeImage(for name: String) -> Result<String, FileManageError> {
        guard let directory = filemanager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            return .failure(.directoryError)
        }
        
        let filePath = directory.appendingPathComponent(name, conformingTo: .jpeg)
        
        do {
            try FileManager.default.removeItem(at: filePath)
            return .success("사진 삭제 성공")
        } catch {
            return .failure(.deleteError)
        }
    }
}
