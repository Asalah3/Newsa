//
//  ArticleDetailsViewController.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import UIKit
import SDWebImage
//import RealmSwift
class ArticleDetailsViewController: UIViewController {
//    let realm = try! Realm()
    @IBOutlet weak var scrollView: UIScrollView!
    var article: Article?
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articlePublishedDate: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article Details"
        scrollView.isScrollEnabled = true
        articleTitle.text = article?.title
        articleSource.text = "Source From: \(article?.source.name ?? "")"
        articleDescription.text = "\(article?.description ?? "") \(article?.content ?? "")"
        articleAuthor.text = "Auther: \(article?.author ?? "")"
        articlePublishedDate.text = "Published At: \(article?.publishedAt ?? "")"
        self.articleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.articleImage.sd_setImage(with: URL(string: article?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeHolder"))
    }
    
    
    @IBAction func continueReading(_ sender: Any) {
        let moreDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MoreDetailsViewController") as! MoreDetailsViewController
        moreDetailsViewController.link = article?.url
        self.navigationController?.pushViewController(moreDetailsViewController, animated: true)
    }

}
