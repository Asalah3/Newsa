//
//  FavouriteViewController.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import UIKit
import Lottie

class FavouriteViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var NoData: AnimationView!
    @IBOutlet weak var favouriteArticlesTableView: UITableView!
    var articles: [FavouriteArticle] = []
    var isSearching: Bool = false
    var searchedArticles: [FavouriteArticle] = []
    var favouriteViewModel : FavouriteViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NoData.isHidden = true
        // ViewModel SetUp
        title = "Favourites"
        self.renderView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.renderView()
    }
    func renderView(){
        DispatchQueue.main.async {
            self.favouriteViewModel = FavouriteViewModel()
            self.favouriteViewModel?.getAllFavouriteArticles()
            self.articles = self.favouriteViewModel?.VMFavouriteResult ?? []
            if self.articles.count == 0{
                self.NoData.animation = Animation.named("empty")
                self.NoData.isHidden = false
                self.NoData.contentMode = .scaleAspectFit
                self.NoData.loopMode = .loop
                self.NoData.play()
                self.favouriteArticlesTableView.isHidden = true
            }else{
                self.NoData.isHidden = true
                self.favouriteArticlesTableView.isHidden = false
            }
            self.favouriteArticlesTableView.reloadData()
        }
    }

}
//   TableView SetUp
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return searchedArticles.count
        }else{
            return articles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell
        var list: [FavouriteArticle] = []
        if isSearching == true {
            list = searchedArticles
        }else{
            list = articles
        }
        cell?.delegate = self
        let item = list[indexPath.row]
        let article = Article(source: Source(name: item.source), title: item.title, description: item.desc, publishedAt: item.publishedAt, urlToImage: item.urlToImage, url: item.url, author: item.author, content: item.content)
        cell?.initializeViewModel(article: article)
        cell?.article = article
        cell?.setUpCell()
        return cell ?? ArticleTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
        var list: [FavouriteArticle] = []
        if isSearching == true {
            list = searchedArticles
        }else{
            list = articles
        }
        let item = list[indexPath.row]
        let article = Article(source: Source(name: item.source), title: item.title, description: item.desc, publishedAt: item.publishedAt, urlToImage: item.urlToImage, url: item.url, author: item.author, content: item.content)
        articleDetailsViewController.article = article
        self.navigationController?.pushViewController(articleDetailsViewController, animated: true)
        
    }
    
}

//   SearchBar SetUp
extension FavouriteViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedArticles = articles.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        favouriteArticlesTableView.reloadData()
        if self.searchedArticles.count == 0{
            self.favouriteArticlesTableView.isHidden = true
            self.NoData.animation = Animation.named("no-data-found")
            self.NoData.isHidden = false
            self.NoData.contentMode = .scaleAspectFit
            self.NoData.loopMode = .loop
            self.NoData.play()
        }else{
            self.favouriteArticlesTableView.isHidden = false
            self.NoData.isHidden = true
        }
        if searchText == ""{
            isSearching = false
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        self.favouriteArticlesTableView.reloadData()
    }
}

extension FavouriteViewController: CellDelegate{
    func showAlert(title: String, message: String, confirmAction: UIAlertAction) {
        Utilites.displayAlert(title: title, message: message, action: confirmAction, controller: self)
    }
    func showToast(message: String) {
        Utilites.displayToast(message: message, seconds: 2, controller: self)
    }
}


