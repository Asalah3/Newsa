//
//  HomeViewModel.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import Foundation
protocol HomeViewModelProtocol{
    func fetchHomeDataFromApi()
    var VMHomeApiResult:[Article]!{get set}
    var bindApiDataToHomeViewController : (()->()) { get set }
    var bindRealmDataToHomeViewController : (()->()) { get set }
    var VMHomeRealmResult: LocalNews?{get set}
    func fetchHomeDataFromRealm()
    func saveNews(news :LocalNews)
    func deleteNews()
}
class HomeViewModel :HomeViewModelProtocol {
    
    var bindRealmDataToHomeViewController : (()->()) = {}
    
    var VMHomeRealmResult : LocalNews?{
        didSet{
            bindRealmDataToHomeViewController()
        }
    }
    
    var remote : NetworkServicesProtocol?
    init(remote: NetworkServicesProtocol) {
        self.remote = remote
    }
    
    var VMHomeApiResult: [Article]!{
        didSet{
            bindApiDataToHomeViewController()
        }
    }
    
    var bindApiDataToHomeViewController : (()->())={}
    
    func fetchHomeDataFromApi() {
        remote?.getTopHeadLines{ result in
            switch result {
            case .success(let response):
                self.VMHomeApiResult = response
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension HomeViewModel {
    func fetchHomeDataFromRealm(){
        VMHomeRealmResult = HomeDataBaseHelper.shared.getNews().first
    }
    
    func saveNews(news :LocalNews){
        HomeDataBaseHelper.shared.saveNews(news: news)
    }
    
    func deleteNews(){
        HomeDataBaseHelper.shared.deleteNews()
    }
}
