//
//  LogInNetworkService.swift
//  DemoApp
//
//  Created by Bul on 24/11/23.
//

import Foundation
import Alamofire

protocol LogInNetworkProtocol {
    func requestSignIn(WithEmail email: String, password: String, _ completion: @escaping(_ userInfo: UserInfo?, _ error: SignInError?) -> Void)
}

struct LogInNetworkService: LogInNetworkProtocol {
    
    func requestSignIn(WithEmail email: String, password: String, _ completion: @escaping (UserInfo?, SignInError?) -> Void) {
                
        let urlStr = ApiUtility.SIGN_IN_END_POINT
        
        guard let url = URL(string: urlStr) else {
            completion(nil, SignInError(reason: "Something went wrong"))
            return
        }
        
        let params = [
            "email": email,
            "password": password
        ]
        /* // Via Alamofire
        AF.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseDecodable(of: UserInfoResponse.self, completionHandler: { (response: DataResponse<UserInfoResponse, AFError>) in
                
                switch response.result {
                case .success(let userInfoResponse):
                    let (userInfo, error) = UserInfoResponse.getUserInfo(FromResponse: userInfoResponse)
                    
                    completion(userInfo, error)
                    break
                case .failure(let error):
                    handleLogInRequestError(error, completion)
                    break
                }
                
            }
        )
        return
        */
        guard let bodyStr = ApiUtility.getJsonString(fromDictionary: params) else {
            debugPrint("LogIn body string creation failed")
            completion(nil, SignInError(reason: "Something went wrong"))
            return
        }
        
        guard let bodyData = bodyStr.data(using: .utf8) else {
            debugPrint("LogIn body data creation failed")
            completion(nil, SignInError(reason: "Something went wrong"))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        ApiUtility.makeApiCall(WithRequest: request) { data, response, error in
            
            if let err = error {
                handleLogInRequestError(err, completion)
                return
            }
            
            LogInNetworkService.decodeSignInResponse(data, completion)
        }
    }
    
    func handleLogInRequestError(_ error: Error, _ completion: @escaping (UserInfo?, SignInError?) -> Void) {
        let (displayMsg, errorCode) = NetworkRequestError.getDisplayableErrorMessage(ForError: error)
        debugPrint("LogIn Network call error = \(error.localizedDescription) URLError.Code = \(String(describing: errorCode))")
        if var tempMsg = displayMsg {
            if let code = errorCode {
                tempMsg = tempMsg + " Error Code: \(code)"
            }
            completion(nil, SignInError(reason: tempMsg))
        } else {
            completion(nil, SignInError(reason: "Something went wrong"))
        }
    }
    
    static func decodeSignInResponse(_ data: Data?, _ completion: @escaping (UserInfo?, SignInError?) -> Void) {
        
        guard let tempData = data else {
            completion(nil, SignInError(reason: "Empty response"))
            return
        }
        
        do {
            // For debug purpose. Comment this.
//            let jsonObj = try JSONSerialization.jsonObject(with: tempData, options: .fragmentsAllowed)
//            debugPrint("jsonObj = \(jsonObj)")
            
            let userInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: tempData)
            
            let (userInfo, error) = UserInfoResponse.getUserInfo(FromResponse: userInfoResponse)
            
            completion(userInfo, error)
        } catch let error {
            debugPrint("JSON Decode error = \(error)")
            completion(nil, SignInError(reason: "Something went wrong"))
            return
        }
    }
    
}
