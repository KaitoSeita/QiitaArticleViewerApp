//
//  APIService.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/05.
//

import SwiftUI

protocol APIServiceProtocol {
    
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    
    func sendArticleRequest<Request: ArticleRequestType>(request: Request) async-> Result<Request.Response, Error>
    func sendArticleActionRequest<Request: ArticleActionRequestType>(request: Request) async -> Result<ArticleAction, Error>
    func sendUserRequest(request: UserRequest) async -> Result<User, Error>
}

struct APIService: APIServiceProtocol {
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let decoder: JSONDecoder = JSONDecoder()
    
}

extension APIService {
        
    func sendArticleRequest<Request: ArticleRequestType>(request: Request) async -> Result<Request.Response, Error> {
        do {
            let result = try? await session.data(for: request.buildURLRequest())

            guard result?.1 is HTTPURLResponse else {
                return .failure(APIError.noResponse)
            }

            guard let response = result?.1 as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return .failure(APIError.invalidStatusCode)
            }
            
            if let data = result?.0 {
                
                let decodedData = try decoder.decode(Request.Response.self, from: data)
                
                return .success(decodedData)
            } else {
                return .failure(APIError.noData)
            }
            
        } catch {
            if error is DecodingError {
                
                return .failure(APIError.decodingError)
            } else if let error = error as NSError? {
                
                if error.code == NSURLErrorTimedOut {
                    
                    return .failure(APIError.networkTimeOut)
                } else {
                    
                    return .failure(APIError.unowned)
                }
            }
        }
    }
    
    func sendArticleActionRequest<Request: ArticleActionRequestType>(request: Request) async -> Result<ArticleAction, Error> {
        do {
            let (_, response) = try await session.data(for: request.buildURLRequest())
            
            guard response is HTTPURLResponse else {
                return .failure(APIError.noResponse)
            }
            
            let result = response as? HTTPURLResponse
            
            if result!.statusCode == 204 {
                return .success(.done)
            } else if result!.statusCode == 404 {
                return .success(.notyet)
            } else if result!.statusCode == 401 {
                return .failure(APIError.authError)
            } else {
                return .failure(APIError.invalidStatusCode)
            }
            
        } catch {
            if let error = error as NSError? {
                
                if error.code == NSURLErrorTimedOut {
                    
                    return .failure(APIError.networkTimeOut)
                } else {
                    
                    return .failure(APIError.unowned)
                }
            }
        }
    }
    
    func sendUserRequest(request: UserRequest) async -> Result<User, Error> {
        do {
            let result = try? await session.data(for: request.buildURLRequest())
            
            guard result?.1 is HTTPURLResponse else {
                return .failure(APIError.noResponse)
            }
            
            guard let response = result?.1 as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return .failure(APIError.invalidStatusCode)
            }
            
            if let data = result?.0 {
                
                let decodedData = try decoder.decode(User.self, from: data)
                
                return .success(decodedData)
            } else {
                return .failure(APIError.noData)
            }
            
        } catch {
            if error is DecodingError {
                
                return .failure(APIError.decodingError)
            } else if let error = error as NSError? {
                
                if error.code == NSURLErrorTimedOut {
                    
                    return .failure(APIError.networkTimeOut)
                } else {
                    
                    return .failure(APIError.unowned)
                }
            }
        }
    }
}
