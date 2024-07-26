//
//  LikedPhoto.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import Foundation
import RealmSwift


final class LikedPhoto: Object {
    @Persisted(primaryKey: true) var id: String
    
    convenience init(id: String) {
        self.init()
        self.id = id
    }
}

final class LikedPhotoRepository: ServiceProtocol {
    private let db = try! Realm()
    static let shared = LikedPhotoRepository()
    
    enum RepositoryError: String, Error {
        case addError = "저장에 실패했습니다."
        case findByIdError = "사진을 찾을 수 없습니다."
        case deleteError = "사진을 삭제할 수 없습니다."
    }
    
    private init() {}
    
    func addLikedPhoto(for record: LikedPhoto) -> Result<String, RepositoryError>  {
        do {
            try db.write { db.add(record) }
            return .success("사진 좋아요 성공!")
        } catch {
            return .failure(.addError)
        }
    }
    
    func getLikedPhotos() -> [LikedPhoto] {
        return Array(db.objects(LikedPhoto.self))
    }
    
    func getLikedPhotoById(for id: String) -> LikedPhoto? {
        return (getLikedPhotos().filter { $0.id == id }).first
    }
    
    func deleteLikedPhotoById(by id: String) -> Result<String, RepositoryError> {
        if let record = getLikedPhotoById(for: id) {
            do {
                try db.write {
                    db.delete(record)
                }
                return .success("사진 좋아요 해제 성공!")
            } catch {
                return .failure(.deleteError)
            }
        } else {
            return .failure(.findByIdError)
        }
    }
}
