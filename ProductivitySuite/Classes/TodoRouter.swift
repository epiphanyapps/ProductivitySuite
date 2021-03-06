//
//  NetworkTodo.swift
//  Pods
//
//  Created by Walter Vargas-Pena on 3/12/17.
//
//

import Foundation
import Alamofire

/**
 endpoints:
 GET - https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos
 GET - https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
 PUT - https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
 
 
 
 curl -X POST https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos --data '{ "text": "Learn Serverless" }'
 curl -X GET https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos
 curl -X GET https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos/{id}
 curl -X PUT https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos/{id} --data '{ "text": "Learn Serverless" }'
 cur -X DELETE - https://nf8ditto54.execute-api.us-east-1.amazonaws.com/dev/todos/{id}

*/
public enum TodoRouter: URLRequestConvertible {
    
    case createTodo(parameters: Parameters)
    case readTodo(id: String)
    case getTodoList
    case updateTodo(id: String, parameters: Parameters)
    case destroyTodo(id: String)
        
    var method: HTTPMethod {
        switch self {
        case .createTodo:
            return .post
        case .readTodo:
            return .get
        case .getTodoList:
            return .get
        case .updateTodo:
            return .put
        case .destroyTodo:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createTodo:
            return "/todos"
        case .readTodo(let id):
            return "/todos/\(id)"
        case .getTodoList:
            return "/todos"
        case .updateTodo(let id, _):
            return "/todos/\(id)"
        case .destroyTodo(let id):
            return "/todos/\(id)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createTodo(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateTodo(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }

}
