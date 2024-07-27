//
//  PhotoTopic.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

// MARK: For Base
struct PhotoUrls: Codable {
    let regular: String?
    let small: String?
}

struct PhotoOwner: Codable {
    let username: String
    let profile_image: PhotoUrls
}

struct Photo: Codable {
    let id: String
    let created_at: String
    let width: Int
    let height: Int
    let urls: PhotoUrls
    let user: PhotoOwner
    let likes: Int
    let views: Int?
    let downloads: Int?
    
    var formattedDate: String {
        if let dateArray = created_at.components(separatedBy: "T").first {
            return (dateArray.split(separator: "-").enumerated().map { idx, value in
                if idx == 0 {
                    return value + "년 "
                } else if idx == 1 {
                    return value + "월 "
                } else {
                    return value + "일"
                }
            }).joined() + " 게시됨"
        } else {
            return ""
        }
    }
}


// MARK: For Search
struct PhotoSearchResult: Codable {
    let total: Int
    let total_pages: Int
    let results: [Photo]
}


// MARK: For Statistics
struct PhotoStatisticValueSet: Codable {
    let date: String
    let value: Int
}

struct PhotoStatisticHistorical: Codable {
    let values: [PhotoStatisticValueSet]
}

struct PhotoStatistic: Codable {
    let total: Int
    let historical: PhotoStatisticHistorical
}

struct PhotoStatisticsResult: Codable {
    let downloads: PhotoStatistic
    let views: PhotoStatistic
}


// MARK: For Ouptut
struct SearchedPhotoOutput: Hashable, Identifiable {
    let id = UUID()
    let photoId: String
    let url: String
    let likes: Int
    let isLiked: Bool
}

struct DetailOutput {
    let photo: Photo
    var isLiked: Bool
}
