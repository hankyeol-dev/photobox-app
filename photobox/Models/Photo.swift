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
