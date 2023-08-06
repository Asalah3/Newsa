//
//  DBModel.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import Foundation
import RealmSwift
class LocalNews: Object {
    @Persisted var articles = List<LocalArticle>()
    convenience init(articles: [LocalArticle]) {
        self.init()
        self.articles.append(objectsIn: articles)
        
    }
}
class LocalArticle: Object{
    @Persisted var source: String
    @Persisted var title: String
    @Persisted var desc: String
    @Persisted var publishedAt: String
    @Persisted var urlToImage: String
    @Persisted var url: String
    @Persisted var author: String
    @Persisted var content: String
    convenience init (source : String, auther : String, title : String, desc: String,url: String, urlToImage: String, publishedAt: String, content: String){
        self.init()
        self.author = auther
        self.source = source
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
}
class FavouriteArticle: Object{
    @Persisted var source: String
    @Persisted var title: String
    @Persisted var desc: String
    @Persisted var publishedAt: String
    @Persisted var urlToImage: String
    @Persisted var url: String
    @Persisted var author: String
    @Persisted var content: String
    convenience init (source : String, auther : String, title : String, desc: String,url: String, urlToImage: String, publishedAt: String, content: String){
        self.init()
        self.author = auther
        self.source = source
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
}
