//
//  FavouriteViewModelTest.swift
//  News AppTests
//
//  Created by Asalah Sayed on 01/08/2023.
//

import XCTest
@testable import News_App

final class FavouriteViewModelTest: XCTestCase {

    var favouriteViewModel: FavouriteViewModelProtocol?
    override func setUpWithError() throws {
        favouriteViewModel = FavouriteViewModel()
    }

    override func tearDownWithError() throws {
        favouriteViewModel = nil
    }
    func testGetAllFavouriteArticles() {
        favouriteViewModel?.getAllFavouriteArticles()
        favouriteViewModel?.bindFavouriteResultToViewController = { [weak self] in
            XCTAssertNotNil(self?.favouriteViewModel?.VMFavouriteResult )
        }
    }


}
