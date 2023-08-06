//
//  ViewController.swift
//  News App
//
//  Created by Asalah Sayed on 30/07/2023.
//

import UIKit
import RealmSwift
import SDWebImage
import NVActivityIndicatorView
import Lottie
class ViewController: UIViewController {
    var activityIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse,color: UIColor.gray)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var NoData: AnimationView!
    @IBOutlet weak var switchMode: UISwitch!
    let refreshControl = UIRefreshControl()
    var articles: [Article] = []
    var isSearching: Bool = false
    var searchedArticles: [Article] = []
    var remoteDataSource: NetworkServicesProtocol?
    var homeViewModel : HomeViewModelProtocol?
    @IBOutlet weak var articlesTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        Utilites.checkMode()
        if UserDefaults.standard.darkMode{
            switchMode.setOn(true, animated: true)
        }
        else{
            switchMode.setOn(false, animated: true)
        }
        remoteDataSource = NetworkServices()
        homeViewModel = HomeViewModel(remote: remoteDataSource ?? NetworkServices())
        homeViewModel?.fetchHomeDataFromApi()
        if Utilites.isConnectedToNetwork() {
            homeViewModel?.bindApiDataToHomeViewController = {() in self.renderView()}
            
        }else{
            Utilites.displayToast(message: "you are offline", seconds: 2, controller: self)
            homeViewModel?.fetchHomeDataFromRealm()
            self.activityIndicator.stopAnimating()
            if (homeViewModel?.VMHomeRealmResult) == nil {
                self.NoData.animation = Animation.named("error")
                self.NoData.isHidden = false
                self.NoData.contentMode = .scaleAspectFit
                self.NoData.loopMode = .loop
                self.NoData.play()
                self.articlesTableView.isHidden = true
            }else{
                self.NoData.isHidden = true
                self.articlesTableView.isHidden = false
                let localArticles: LocalNews = (homeViewModel?.VMHomeRealmResult)!
                localArticles.articles.forEach{ article in
                    let remoteArticle = Article(source: Source(name: article.source), title: article.title, description: article.desc, publishedAt: article.publishedAt, urlToImage: article.urlToImage, url: article.url, author: article.author, content: article.content)
                    articles.append(remoteArticle)
                }
            }
            self.activityIndicator.stopAnimating()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoData.isHidden = true
        title = "News"
        // RefreshControl SetUp
        refreshControl.tintColor = UIColor.gray
        refreshControl.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
        articlesTableView.addSubview(refreshControl)
        
        // ActivityIndicator SetUp
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func renderView(){
        DispatchQueue.main.async {
            self.articles = self.homeViewModel?.VMHomeApiResult ?? []
            if self.articles.count == 0{
                self.NoData.animation = Animation.named("error")
                self.NoData.isHidden = false
                self.NoData.contentMode = .scaleAspectFit
                self.NoData.loopMode = .loop
                self.NoData.play()
                self.articlesTableView.isHidden = true
            }else{
                self.NoData.isHidden = true
                self.articlesTableView.isHidden = false
                var localArticles: [LocalArticle] = []
                self.articles.forEach{ article in
                    let localArticle = LocalArticle(source: article.source.name ?? "", auther: article.author ?? "", title: article.title ?? "", desc: article.description ?? "", url: article.url ?? "", urlToImage: article.urlToImage ?? "", publishedAt: article.publishedAt ?? "", content: article.content ?? "")
                    localArticles.append(localArticle)
                }
                
                let localNews = LocalNews(articles: localArticles)
                self.homeViewModel?.deleteNews()
                self.homeViewModel?.saveNews(news: localNews)
            }
            
            self.articlesTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    @objc func refreshView(){
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.homeViewModel?.fetchHomeDataFromApi()
            self.homeViewModel?.bindApiDataToHomeViewController = {() in self.renderView()}
        }
    }
    @IBAction func onClickSwitch(_ sender: Any) {
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            if (sender as AnyObject).isOn {
                appDelegate?.overrideUserInterfaceStyle = .dark
                UserDefaults.standard.darkMode = true

                return
            }else {
                appDelegate?.overrideUserInterfaceStyle = .light
                UserDefaults.standard.darkMode = false
                return
            }
        }
    }
}
//   TableView SetUp
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching == true {
            return searchedArticles.count
        }else{
            return articles.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell
        var list: [Article] = []
        if isSearching == true {
            list = searchedArticles
        }else{
            list = articles
        }
        cell?.initializeViewModel(article: list[indexPath.row])
        cell?.article = list[indexPath.row]
        cell?.delegate = self
        cell?.setUpCell()
        return cell ?? ArticleTableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
        articleDetailsViewController.article = articles[indexPath.row]
        self.navigationController?.pushViewController(articleDetailsViewController, animated: true)
        
    }
    
}

//   SearchBar SetUp
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedArticles = articles.filter({$0.title?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased()})
        isSearching = true
        articlesTableView.reloadData()
        if self.searchedArticles.count == 0{
            self.articlesTableView.isHidden = true
            self.NoData.animation = Animation.named("no-data-found")
            self.NoData.isHidden = false
            self.NoData.contentMode = .scaleAspectFit
            self.NoData.loopMode = .loop
            self.NoData.play()
        }else{
            self.articlesTableView.isHidden = false
            self.NoData.isHidden = true
        }
        if searchText == ""{
            isSearching = false
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        self.renderView()
    }
}

extension ViewController: CellDelegate{
    func showAlert(title: String, message: String, confirmAction: UIAlertAction) {
        Utilites.displayAlert(title: title, message: message, action: confirmAction, controller: self)
    }
    func showToast(message: String) {
        Utilites.displayToast(message: message, seconds: 2, controller: self)
    }
}


