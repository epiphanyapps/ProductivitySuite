//
//  UserRouter.swift
//  ProductivitySuite
//
//  Created by Walter Vargas-Pena on 7/2/17.
//

import Foundation
import Alamofire

public enum UserRouter: URLRequestConvertible {
    
    case createUser(parameters: Parameters)
    case readUser(id: String)
    case getUserList
    case updateUser(id: String, parameters: Parameters)
    case destroyUser(id: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .createUser:
            return .post
        case .readUser:
            return .get
        case .getUserList:
            return .get
        case .updateUser:
            return .put
        case .destroyUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createUser:
            return "/users"
        case .readUser(let id):
            return "/users/\(id)"
        case .getUserList:
            return "/users"
        case .updateUser(let id, _):
            return "/users/\(id)"
        case .destroyUser(let id):
            return "/users/\(id)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createUser(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
    
}
