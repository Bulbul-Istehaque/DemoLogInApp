//
//  DemoAppTests.swift
//  DemoAppTests
//
//  Created by Bul on 24/11/23.
//

import XCTest
@testable import DemoApp

final class LogInViewModelTests: XCTestCase {

    func test_canInit() throws {
        let _ = makeModel()
    }
    
    func test_EmptyEmail() throws {
        let viewModel = makeModel()
        
        viewModel.logIn(WithEmail: "", password: "qwerty") { success, errorReason in
            
            XCTAssertEqual(success, false)
            XCTAssertEqual(errorReason, "Email is empty")
        }
    }
    
    func test_EmptyPassword() throws {
        let viewModel = makeModel()
        
        viewModel.logIn(WithEmail: "zxcvbnm", password: "") { success, errorReason in
            
            XCTAssertEqual(success, false)
            XCTAssertEqual(errorReason, "Password is empty")
        }
    }
    
    func test_InvalidEmailFormat() throws {
        let viewModel = makeModel()
        
        viewModel.logIn(WithEmail: "zxcvbnm", password: "zxcvbnm") { success, errorReason in
            
            XCTAssertEqual(success, false)
            XCTAssertEqual(errorReason, "email or password is wrong")
        }
    }
    
    func test_LogInWithWrongCredentials() throws {
        let viewModel = makeModel()
        
        viewModel.logIn(WithEmail: "userA@gmail.com", password: "poiut") { success, errorReason in
            
            XCTAssertEqual(success, false)
            XCTAssertEqual(errorReason, "email or password is wrong")
        }
    }
    
    func test_LogInWithRightCredentials() throws {
        let viewModel = makeModel()
        
        viewModel.logIn(WithEmail: "TestUser1@xyz.com", password: "123456") { success, errorReason in
            
            XCTAssertEqual(success, true)
            XCTAssertEqual(errorReason, nil)
        }
    }
    
    
    
    private func makeModel() -> LogInViewModel {
        return LogInViewModel(delegate: self, signInService: MockLogInNetworkService())
    }
    
}

extension LogInViewModelTests: LogInViewModelDelegateProtocol {
    
}


struct MockLogInNetworkService: LogInNetworkProtocol {
    
    func requestSignIn(WithEmail email: String, password: String, _ completion: @escaping (DemoApp.UserInfo?, DemoApp.SignInError?) -> Void) {
        
        if email != "TestUser1@xyz.com" && password != "123456" {
            completion(nil, SignInError(reason: "email or password is wrong"))
            return
        }
        
        let mockResult = [
            "success": "true",
            "user_type": "carrier",
            "id": "186298",
            "name": "Test Driver",
            "image_path": "https://s3-us-west-2.amazonaws.com/qt.com.dashboard.profile.driver/88cc7e062bb4477b97135b466d6a5cde.jpg",
            "thumbnail_image_path": "https://s3-us-west-2.amazonaws.com/qt.com.dashboard.profile.driver/88cc7e062bb4477b97135b466d6a5cde.jpg",
            "company_id": "53471",
            "company_name": "Unimartk",
            "account_plan": "STARTER",
            "area_id": "53450",
            "fixed_delivery_fee": 0,
            "dispatcher_support_number": "+1003300",
            "email_address": "TestUser1@xyz.com.com",
            "currency_code": 840,
            "currency_symbol": "$",
            "routing": false,
            "in_miles": true,
            "show_cash_tips": true,
            "show_delivery_fee": true,
            "show_total_amount": true,
            "show_driver_earning": true,
            "show_order_pricing": false,
            "auto_accept": false,
            "pod_enabled": false,
            "signature_enabled": false,
            "id_scan_required": false,
            "showDriverPayment": true,
            "enforcedPickupItemsCheck": false,
            "show_route_optimization": false,
            "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJRdWVzdFRhZyIsInJvbGUiOiJjYXJyaWVyIiwicGFydG5lcklkIjoibnVsbCIsImNvbXBhbnlJZCI6IjUzNDcxIiwiZGlzcGF0Y2hlcklkIjoiNTM0NjEiLCJ1c2VySWQiOiJudWxsIiwiY2FycmllcklkIjoiMTg2Mjk4IiwiaWF0IjoxNzAxMzEzNTYxLCJleHAiOjE3MDEzMTcxNjF9.ja_Bt81tsW7eNP9hDAJUcr_PNPnQEy3cP4ZYRQPsenE",
            "refreshToken": "gSBVbI8PHYWTAEsbmxsGPDgrnwqOyXeO5JHVWmeV9Rr1hd8QyjnWD7aJmvSEErcBDg6QnN"
        ] as [String : Any]
        
        
        
        do {
            
            let tempData = try JSONSerialization.data(withJSONObject: mockResult, options: .fragmentsAllowed)
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
