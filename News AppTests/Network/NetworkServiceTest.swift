//
//  NetworkServiceTest.swift
//  News AppTests
//
//  Created by Asalah Sayed on 01/08/2023.
//

import XCTest
@testable import News_App
final class NetworkServiceTest: XCTestCase {
    
    var networkService: NetworkServicesProtocol?
    
    override func setUpWithError() throws {
        networkService = NetworkServices()
    }

    override func tearDownWithError() throws {
        networkService = nil
    }

    func testGetTopHeadLines(){
        let expectation = expectation(description: "Waiting for the API Data")
        networkService?.getTopHeadLines{ result in
            switch result {
            case .success(let response):
                XCTAssertNotEqual(response.count, 0)
                expectation.fulfill()
                break
            case .failure(let error):
                print(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10)
    }

}
