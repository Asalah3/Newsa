//
//  FavouriteViewModel.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import Foundation
protocol FavouriteViewModelProtocol{
    var bindFavouriteResultToViewController : (()->()) { get set }
    var VMFavouriteResult : [FavouriteArticle]? { get set }
    func getAllFavouriteArticles() 
    func saveFavouriteArticle(article :FavouriteArticle)
    func deleteFavouriteArticle(article :FavouriteArticle)
    func checkIfInsertedFavouriteArticle(articleTitle :String) -> Bool
}
class FavouriteViewModel: FavouriteViewModelProtocol{
    
    var bindFavouriteResultToViewController : (()->()) = {}
    
    var VMFavouriteResult : [FavouriteArticle]?{
        didSet{
            bindFavouriteResultToViewController()
        }
    }
    
    func getAllFavouriteArticles() {
        VMFavouriteResult = DataBaseHelper.shared.getAllSavedArticles()
    }
    
    func saveFavouriteArticle(article :FavouriteArticle){
        DataBaseHelper.shared.saveArticle(article: article)
    }
    
    func deleteFavouriteArticle(article :FavouriteArticle){
        DataBaseHelper.shared.deleteArticle(article: article)
    }
    func checkIfInsertedFavouriteArticle(articleTitle :String) -> Bool{
        return DataBaseHelper.shared.checkIfInserted(title: articleTitle)
    }
}
