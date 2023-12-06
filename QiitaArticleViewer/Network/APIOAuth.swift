//
//  APIOAuth.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/20.
//

// @Publishedで管理しているとトークンがタスクキルで消去されてしまうので、UserDefaultsに保持しておく
// あと一度認証したらその画面に飛ばないように
// 記事の閲覧履歴も保存しておきたい

import SwiftUI
import AuthenticationServices

class APIOAuth: NSObject,
                ObservableObject,
                ASWebAuthenticationPresentationContextProviding {
    @Published var token = ""
    @Published var errorMessage = ""
    
    private var authenticationSession: ASWebAuthenticationSession?
    private var authURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "qiita.com"
        components.path = "/api/v2/oauth/authorize"
        components.queryItems = [
            "client_id": "c4656811200f3d93a310150051b4911bc06dc84f",
            "client_secret": "3da3920a8ef9159dd88ab2abf947858a46073769",
            "scope": "read_qiita write_qiita"
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    let decoder: JSONDecoder = JSONDecoder()
}
 
extension APIOAuth {
    
    func loginSession() {
        let authenticationSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "qiiviewer-app")
        {(url, error) in
            if error != nil {
                self.errorMessage = "認証に失敗しました"
            } else if let url = url {
                let query = URLComponents(string: (url.absoluteString))?
                    .queryItems?.filter({$0.name == "code"}).first
                
                if let authorizationCode = query?.value {
                    Task { @MainActor in
                        let result = await self.getAccessToken(code: authorizationCode)
                        switch result {
                        case .success(let token):
                            print(token)
                            if let data = token.data(using: .utf8) {
                                KeyChain().save(data, service: "com.shonbeno.QiitaArticleViewer", key: "accessToken")
                            } else {
                                print("Failed to convert token to data")
                            }
                            UserDefaults.standard.set(token, forKey: "accessToken")
                        case .failure(let error):
                            print(error)
                            self.setErrorMessage(error: error)
                        }
                    }
                }
            }
        }
        
        authenticationSession.presentationContextProvider = self
        authenticationSession.prefersEphemeralWebBrowserSession = false
        authenticationSession.start()
        self.authenticationSession = authenticationSession
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    private func getAccessToken(code: String) async -> Result<String, Error> {
        do {
            let result = try? await session.data(for: AccessTokenRequest(authenticationCode: code).buildURLRequest())

            guard result?.1 is HTTPURLResponse else {
                return .failure(APIError.noResponse)
            }

            guard let response = result?.1 as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return .failure(APIError.invalidStatusCode)
            }
            
            if let data = result?.0 {
                
                let decodedData = try decoder.decode(AccessToken.self, from: data)
                
                if let accessToken = decodedData.token {
                    return .success(accessToken)
                } else {
                    return .failure(APIError.noData)
                }
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
    
    private func setErrorMessage(error: Error) {
        if let error = error as? APIError {
            switch error {
            case .unowned:
                errorMessage = "不明なエラーです"
            case .networkTimeOut, .invalidStatusCode, .noData, .noResponse:
                errorMessage = "通信環境をご確認ください"
            case .decodingError:
                errorMessage = "再度お試しください"
            case .alreadyExisted:
                errorMessage = "すでに登録されています"
            case .authError:
                errorMessage = "認証に失敗しました"
            }
        }
    }
}

struct AccessTokenRequest {
    let authenticationCode: String
    
    var accessTokenURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "qiita.com"
        components.path = "/api/v2/access_tokens"
        components.queryItems = [
            "client_id": "c4656811200f3d93a310150051b4911bc06dc84f",
            "client_secret": "3da3920a8ef9159dd88ab2abf947858a46073769",
            "code": authenticationCode
        ].map { URLQueryItem(name: $0, value: $1) }
        return components.url!
    }
    
    func buildURLRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: "https://qiita.com")!)
        
        request.url = accessTokenURL
        request.httpMethod = "POST"
        request.timeoutInterval = 5
        
        return request
    }
}
