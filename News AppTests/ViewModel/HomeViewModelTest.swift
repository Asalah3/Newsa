//
//  HomeViewModelTest.swift
//  News AppTests
//
//  Created by Asalah Sayed on 01/08/2023.
//

import XCTest
@testable import News_App
final class HomeViewModelTest: XCTestCase {
    
    var networkService: NetworkServicesProtocol?
    var homeViewModel: HomeViewModelProtocol?
    
    override func setUpWithError() throws {
        networkService = NetworkServices()
        homeViewModel = HomeViewModel(remote: NetworkServices())
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        homeViewModel = nil
    }
    
    func testGetHomeDataFromApi() {
        let expectation = expectation(description: "Waiting for the API Data")
        homeViewModel?.fetchHomeDataFromApi()
        homeViewModel?.bindApiDataToHomeViewController = { [weak self] in
            XCTAssertNotNil(self?.homeViewModel?.VMHomeApiResult )
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10)
    }
    
    func testGetHomeDataFromRealm() {
        homeViewModel?.fetchHomeDataFromRealm()
        homeViewModel?.bindRealmDataToHomeViewController = { [weak self] in
            XCTAssertNotNil(self?.homeViewModel?.VMHomeRealmResult )
        }
    }
    
}
