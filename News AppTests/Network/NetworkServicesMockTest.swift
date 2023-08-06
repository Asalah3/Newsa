//
//  NetworkServicesMockTest.swift
//  News AppTests
//
//  Created by Asalah Sayed on 01/08/2023.
//

import XCTest
@testable import News_App

final class NetworkServicesMockTest: XCTestCase {
    
    var networkService: NetworkServicesProtocol?
    override func setUpWithError() throws {
       networkService = NetworkServicesMock()
    }

    override func tearDownWithError() throws {
        networkService = nil
    }

    func testGetTopHeadLines(){
        networkService?.getTopHeadLines{result in
            switch result {
            case .success(let response):
                XCTAssertNotEqual(response.count, 0)
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }

}
