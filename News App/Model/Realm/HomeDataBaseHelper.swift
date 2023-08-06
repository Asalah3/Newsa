//
//  HomeDataBaseHelper.swift
//  News App
//
//  Created by Asalah Sayed on 01/08/2023.
//

import Foundation
import RealmSwift
class HomeDataBaseHelper {
    static let shared = HomeDataBaseHelper()
    private var realm = try! Realm()
    
    func getDatabaseURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }
    func getNews() -> [LocalNews] {
        return Array(realm.objects(LocalNews.self))
    }
    func isEmpty() -> Bool {
        if Array(realm.objects(LocalNews.self)).count == 0{
            return false
        }else{
            return true
        }
    }
    
    func saveNews(news: LocalNews){
        try! realm.write{
            realm.add(news)
        }
    }
    func deleteNews(){
        if isEmpty() == true{
            let objectToDelete = realm.objects(LocalNews.self).first!
            try! realm.write{
                realm.delete(objectToDelete)
            }
        }
    }
}
