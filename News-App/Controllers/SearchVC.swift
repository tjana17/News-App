//
//  SearchVC.swift
//  News-App
//
//  Created by DB-MBP-023 on 28/05/24.
//

import UIKit
import SVProgressHUD

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var response = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchBar.delegate = self
        let searchCell = UINib(nibName: "CategoriesListCell", bundle: Bundle.main)
        tableView.register(searchCell, forCellReuseIdentifier: Constants.categoriesListCell)
        searchBar.becomeFirstResponder()
        
    }
    
    func getYesterday() -> String {
        let yesterday = Date.yesterday
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: yesterday)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    //MARK: - JSON Parsing
    private func parseAPI(_ query: String) {
        SVProgressHUD.show()
        let param = RequestParams(q: query, from: getYesterday(), sortBy: "publishedAt")
        let request = RequestModel(url: .everything, queryItems: param.queryItem)
        
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

}

//MARK: - UITableViewDataSource
extension SearchVC: UITableViewDataSource {
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
extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Constants.storyBoard.instantiateViewController(withIdentifier: Constants.webViewVC) as! WebViewController
        vc.link = response[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UISearchBarDelegate
extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText != "" {
            parseAPI(searchText)
            searchBar.endEditing(true)
        }
    }
}
