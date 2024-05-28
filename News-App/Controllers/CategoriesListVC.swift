//
//  CategoriesListVC.swift
//  News-App
//
//  Created by DB-MBP-023 on 27/05/24.
//

import UIKit
import SVProgressHUD

class CategoriesListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory = String()
    var response = [Article]()
    let selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? String ?? "us"
    override func viewDidLoad() {
        super.viewDidLoad()
        let catVC = UINib(nibName: "CategoriesListCell", bundle: Bundle.main)
        tableView.register(catVC, forCellReuseIdentifier: Constants.categoriesListCell)
        title = selectedCategory.capitalized
        parseAPI()
        
    }
    
    //MARK: - JSON Parsing
    private func parseAPI() {
        SVProgressHUD.show()
        let param = RequestParams(country: selectedCountry, category: Category(rawValue: selectedCategory))
        let request = RequestModel(url: .topHeadlines, queryItems: param.queryItem)
        
        NetworkRequestMain.postAction(request, DataModel.self) {[weak self] result in
            switch result {
            case .success(let model):
                if (model.status == StatusCode.successful.rawValue) {
                    self?.response = model.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }else{
                    print("Error == \(NetworkError.noDataError)")
                }
            case .failure(let error):
                print("ErrorFailure == \(error)")
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

}

//MARK: - UITableViewDataSource
extension CategoriesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoriesListCell, for: indexPath) as? CategoriesListCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let publishedDate = response[indexPath.item].publishedAt
        let splitDate = publishedDate?.components(separatedBy: "T")
        cell.dateLbl.text = splitDate?[0].formattedDate
        cell.newsImage.downloaded(from: response[indexPath.row].urlToImage ?? "")
        cell.titleLbl.text = response[indexPath.row].title
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // MARK: - Bounce animation
        cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1,
                       options: .curveEaseIn, animations: {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        })
    }
}

//MARK: - UITableViewDelegate
extension CategoriesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Constants.storyBoard.instantiateViewController(withIdentifier: Constants.webViewVC) as! WebViewController
        vc.link = response[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
