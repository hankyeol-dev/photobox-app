//
//  Network.swift
//  photobox
//
//  Created by 강한결 on 7/22/24.
//

import Foundation

final class NetworkService: ServiceProtocol {
    
    static var shared: NetworkService = NetworkService()
    
    private init() {}
    
    enum NetworkErrors: String, Error {
        case requestError = "요청하는 URL을 확인해주세요."
        case responseError = "요청하신 응답을 확인할 수 없습니다."
        case dataNotFound = "요청하신 데이터를 확인할 수 없습니다."
    }
    
    func fetch<D: Decodable>(by route: RouteService, of model: D.Type) async -> Result<D, NetworkErrors> {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = SCHEME
        urlComponent.host = HOST
        urlComponent.path = route.path
        urlComponent.queryItems = route.queryString
        
        guard let url = urlComponent.url else {
            return .failure(.requestError)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [HEADER_AUTHORIZATION_KEY: HEADER_AUTHORIZATION]
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            do {
                let decodedData = try JSONDecoder().decode(D.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.dataNotFound)
            }
            
        } catch {
            return .failure(.responseError)
        }
        
    }
}
