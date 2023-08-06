//
//  ArticleTableViewCell.swift
//  News App
//
//  Created by Asalah Sayed on 30/07/2023.
//

import UIKit
import SDWebImage
protocol CellDelegate: AnyObject{
    func showAlert(title : String , message: String, confirmAction: UIAlertAction)
    func showToast(message: String)
    func renderView()
}
class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var ContainerView: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleDescription: UILabel!
    @IBOutlet weak var articlePublishedDate: UILabel!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    weak var delegate : CellDelegate?
    var viewModel: FavouriteViewModel?
    var article: Article?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initializeViewModel(article: Article){
        viewModel = FavouriteViewModel()
        self.article = article
        if viewModel?.checkIfInsertedFavouriteArticle(articleTitle: article.title ?? "") == true {
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpCell(){
        
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.articleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.articleImage.sd_setImage(with: URL(string: article?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeHolder"))

        self.articleTitle.text = article?.title
        
        self.articleDescription.text = article?.description
        
        self.articlePublishedDate.text = article?.publishedAt
        
        self.articleSource.text = article?.source.name
    }
    
    @IBAction func AddToFavourite(_ sender: Any) {
        let favouriteArticle = FavouriteArticle(
            source: article?.source.name ?? "",
            auther: article?.author ?? "",
            title: article?.title ?? "",
            desc: article?.description ?? "",
            url: article?.url ?? "",
            urlToImage: article?.urlToImage ?? "",
            publishedAt: article?.publishedAt ?? "",
            content: article?.content ?? "")
        
        if viewModel?.checkIfInsertedFavouriteArticle(articleTitle: article?.title ?? "") == true {
            let confirmAction = UIAlertAction(title: "Delete", style: .default){ action  in
                self.favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.viewModel?.deleteFavouriteArticle(article: favouriteArticle)
                self.delegate?.renderView()
            }
            self.delegate?.showAlert(title: "Delete from favourite!", message: "This item in favourite, Do you want to delete?", confirmAction: confirmAction)
        }else{
            self.delegate?.showToast(message: "Article Saved succeessfully")
            self.delegate?.renderView()
            favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            viewModel?.saveFavouriteArticle(article: favouriteArticle)
        }
    }
}
