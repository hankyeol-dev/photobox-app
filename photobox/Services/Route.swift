//
//  RoutingService.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import Foundation

enum OrderBy: String, CaseIterable {
    case popular
    case latest
    case relevant
}

enum ColorBy: String, CaseIterable {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
}

enum RouteService {
    case topic(topicName: String)
    case search(query: String, page: Int = 1, per_page: Int = 20, order_by: OrderBy = .latest, color: ColorBy = .black)
    case detail(id: String)
    case statistic(id: String)
    
    var path: String {
        switch self {
        case .topic(let topicName):
            return "/topics/\(topicName)/photos"
        case .search:
            return "/search/photos"
        case .detail(let id):
            return "/photos/\(id)"
        case .statistic(let id):
            return "/photos/\(id)/statistics"
        }
    }
    
    var queryString: [URLQueryItem] {
        switch self {
        case .topic:
            return [
                URLQueryItem(name: "page", value: "1"),
                URLQueryItem(name: "per_page", value: "10"),
                URLQueryItem(name: "order_by", value: OrderBy.popular.rawValue),
            ]
        case .search(let query, let page, let per_page, let order_by, let color_by):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(per_page)),
                URLQueryItem(name: "order_by", value: order_by.rawValue),
                URLQueryItem(name: "color_by", value: color_by.rawValue)
            ]
        default:
            return []
        }
    }
}

