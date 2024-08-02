//
//  RoutingService.swift
//  photobox
//
//  Created by 강한결 on 7/23/24.
//

import Foundation
import UIKit

enum OrderBy: String, CaseIterable {
    case relevant
    case latest
    case popular
    
    var byKorean: String {
        switch self {
        case .relevant:
            return "관련순"
        case .latest:
            return "최신순"
        case .popular:
            return "인기순"
        }
    }
}

enum ColorBy: Int, CaseIterable, Hashable {
    case black
    case white
    case yellow
    case red
    case purple
    case green
    case blue
    
    var byEnglish: String {
        switch self {
        case .black:
            return "black"
        case .white:
            return "white"
        case .yellow:
            return "yellow"
        case .red:
            return "red"
        case .purple:
            return "purple"
        case .green:
            return "green"
        case .blue:
            return "blue"
        }
    }
    
    var byUIColor: UIColor {
        switch self {
        case .black:
            return UIColor(hexCode: "#000000")
        case .white:
            return UIColor(hexCode: "#FFFFFF")
        case .yellow:
            return UIColor(hexCode: "#FFEF62")
        case .red:
            return UIColor(hexCode: "#F04452")
        case .purple:
            return UIColor(hexCode: "#9636E1")
        case .green:
            return UIColor(hexCode: "#02B946")
        case .blue:
            return UIColor(hexCode: "#3C59FF")
        }
    }
    
    var byKorean: String {
        switch self {
        case .black:
            return "검정"
        case .white:
            return "하양"
        case .yellow:
            return "노랑"
        case .red:
            return "빨강"
        case .purple:
            return "보라"
        case .green:
            return "초록"
        case .blue:
            return "파랑"
        }
    }
}

enum RouteService {
    case topic(topicName: String)
    case search(query: String, page: Int = 1, per_page: Int = 20, order_by: OrderBy = .relevant, color: ColorBy = .black)
    case detail(id: String)
    case statistic(id: String)
    case random
    
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
        case .random:
            return "/photos/random"
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
                URLQueryItem(name: "color_by", value: color_by.byEnglish)
            ]
        case .random:
            return [
                URLQueryItem(name: "count", value: "10")
            ]
        case .statistic:
            return [
                URLQueryItem(name: "quantity", value: "7")
            ]
        default:
            return []
        }
    }
}

