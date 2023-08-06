//
//  DataBaseHelper.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import Foundation
import RealmSwift
class DataBaseHelper {
    static let shared = DataBaseHelper()
    private var realm = try! Realm()
    
    func getDatabaseURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    func saveArticle(article: FavouriteArticle){
        try! realm.write{
            realm.add(article)
        }
    }
    func deleteArticle(article: FavouriteArticle){
        let objectToDelete = realm.objects(FavouriteArticle.self).where{
            $0.title == article.title
        }.first!
        try! realm.write{
            realm.delete(objectToDelete)
        }
    }
    
    func getAllSavedArticles() -> [FavouriteArticle]{
        return Array(realm.objects(FavouriteArticle.self))
    }
    func checkIfInserted(title: String) -> Bool{
        let list = Array(realm.objects(FavouriteArticle.self)).filter({$0.title.lowercased().prefix(title.count) == title.lowercased()})
        return list.count == 0 ? false : true
    }
}
