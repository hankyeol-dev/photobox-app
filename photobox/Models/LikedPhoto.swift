//
//  LikedPhoto.swift
//  photobox
//
//  Created by 강한결 on 7/26/24.
//

import Foundation
import RealmSwift

/**
 user name
 user profile - small (link)
 upload date - T 포함한 데이터
 width
 height
 views
 downloads
 */

final class LikedPhoto: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var ownerName: String
    @Persisted var ownerImage: String?
    @Persisted var ownerCreatedAt: String
    @Persisted var width: Int
    @Persisted var height: Int
    @Persisted var views: Int?
    @Persisted var downloads: Int?
    @Persisted var created_at = Date()
    
    convenience init(
        id: String,
        ownerName: String, 
        ownerImage: String? = nil,
        ownerCreatedAt: String,
        width: Int,
        height: Int,
        views: Int? = nil,
        downloads: Int? = nil
    ) {
        self.init()
        self.id = id
        self.ownerName = ownerName
        self.ownerImage = ownerImage
        self.width = width
        self.height = height
        self.views = views
        self.downloads = downloads
    }
}

enum LikePhotoSortOption: CaseIterable {
    case latest
    case oldest
    
    var byKorean: String {
        switch self {
        case .latest:
            return "최신순"
        case .oldest:
            return "과거순"
        }
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
    
    func getLikedPhotos(by sortOption: LikePhotoSortOption) -> [LikedPhoto] {
        return Array(db.objects(LikedPhoto.self).sorted(byKeyPath: "created_at", ascending: sortOption == .latest ? false : true))
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
