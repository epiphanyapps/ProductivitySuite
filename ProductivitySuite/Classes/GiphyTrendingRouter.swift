//
//  GiphyRouter.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 4/10/17.
//
//

import Foundation
import Alamofire

/**
 endpoint:
 GET - http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC
 */
public enum GiphyTrendingRouter: URLRequestConvertible {
    
    case trending(limit: Int)
    
    static let baseURLString = "http://api.giphy.com/"
    static let key = "dc6zaTOxFJmzC"
    
    var method: HTTPMethod {
        switch self {
        case .trending:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .trending:
            return "v1/gifs/trending"
        }
    }
    
    // MARK: URLRequestConvertible
    
    public func asURLRequest() throws -> URLRequest {

        let result: (path: String, parameters: Parameters) = {
            
            switch self {
            case let .trending(limit) where limit != 0:
                return (path, ["api_key": GiphyTrendingRouter.key, "limit": limit])
            case .trending(_):
                return (path, ["api_key": GiphyTrendingRouter.key])
            }
            
        }()

        let url = try GiphyTrendingRouter.baseURLString.asURL()
        let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        
    }
    
}
