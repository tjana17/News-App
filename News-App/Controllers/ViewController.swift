//
//  ViewController.swift
//  News-App
//
//  Created by Janarthanan Kannan on 25/05/24.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    //MARK: - Init
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryBtn: UIBarButtonItem!
    
    var businessResponse: DataModel?
    var headlinesResponse: DataModel?

    lazy private var lists: DropDown = {
        let ls = DropDown()
        return ls
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        parseAPI()
        let selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? String ?? "us"
        countryBtn.title = selectedCountry.uppercased()
    }

    private func registerCells() {
        let headerCell  = UINib(nibName: "CategoryCell", bundle: Bundle.main)
        let headlinesCell = UINib(nibName: "TopHeadlinesTableCell", bundle: Bundle.main)
        let businessCell = UINib(nibName: "BusinessTableCell", bundle: Bundle.main)
        
        tableView.register(headerCell, forCellReuseIdentifier: "CategoryCell")
        tableView.register(headlinesCell, forCellReuseIdentifier: "topHeadlinesCell")
        tableView.register(businessCell, forCellReuseIdentifier: "businessTableCell")
        
    }
    
    //MARK: - UIBarButton Actions
    @IBAction func countryButtonTapped(_ sender: UIBarButtonItem) {
        lists.launchList(itemsArray: Array(Constants.countries.values), imagesArray: Array(Constants.countries.keys)) { (index) in
            if index > -1 {
                self.countryBtn.title = Array(Constants.countries.keys)[index].uppercased()
                let defaults = UserDefaults.standard
                defaults.set(Array(Constants.countries.keys)[index], forKey: "selectedCountry")
                self.parseAPI()
            }
        }
    }
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        let vc = Constants.storyBoard.instantiateViewController(withIdentifier: Constants.searchVC) as! SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - JSON Parsing
    fileprivate func businessAPI(_ dispatchGroup: DispatchGroup) {
        let selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? String ?? "us"
        let param = RequestParams(country: selectedCountry, category: .business)
        let request = RequestModel(url: .topHeadlines, queryItems: param.queryItem)
        
        NetworkRequestMain.postAction(request, DataModel.self) {[weak self] result in
            switch result {
            case .success(let model):
                if (model.status == StatusCode.successful.rawValue) {
                    self?.businessResponse = model
                    DispatchQueue.main.async {
                        dispatchGroup.leave() 
                        self?.tableView.reloadData()
                    }
                }else{
                    print("Error == \(NetworkError.noDataError)")
                }
            case .failure(let error):
                print("ErrorFailure == \(error)")
            }
        }
    }
    
    fileprivate func headlinesAPI(_ dispatchGroup: DispatchGroup) {
        let selectedCountry = UserDefaults.standard.object(forKey: "selectedCountry") as? String ?? "us"
        let param = RequestParams(country: selectedCountry)
        let request = RequestModel(url: .topHeadlines, queryItems: param.queryItem)
        
        NetworkRequestMain.postAction(request, DataModel.self) {[weak self] result in
            switch result {
            case .success(let model):
                if (model.status == StatusCode.successful.rawValue) {
                    self?.headlinesResponse = model
                    DispatchQueue.main.async {
                        dispatchGroup.leave()
                        self?.tableView.reloadData() // <<----
                    }
                }else{
                    print("Error == \(NetworkError.noDataError)")
                }
            case .failure(let error):
                print("ErrorFailure == \(error)")
            }
        }
    }
    
    private func parseAPI() {
        SVProgressHUD.show()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        businessAPI(dispatchGroup)
        
        dispatchGroup.enter()
        headlinesAPI(dispatchGroup)
        
        dispatchGroup.notify(queue: .main) {
            // whatever you want to do when both are done
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - UINavigations
    func openWebView(_ url: String) {
        let vc = Constants.storyBoard.instantiateViewController(withIdentifier: Constants.webViewVC) as! WebViewController
        vc.link = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openCategoriesView(_ category: String) {
        let vc = Constants.storyBoard.instantiateViewController(withIdentifier: Constants.categoriesListVC) as! CategoriesListVC
        vc.selectedCategory = category.lowercased()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UITableView DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.getCategory = { category in
                self.openCategoriesView(category)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "topHeadlinesCell", for: indexPath) as? TopHeadlinesTableCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.articles = headlinesResponse?.articles ?? []
            cell.headlinesCollectionView.reloadData()
            cell.getDetailLink = { urlString in
                self.openWebView(urlString)
            }
            return cell
        
            
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "businessTableCell", for: indexPath) as? BusinessTableCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.articles = businessResponse?.articles ?? []
            cell.collectionView.reloadData()
            cell.getDetailLink = { urlString in
                self.openWebView(urlString)
            }
            return cell
//            let cell = UITableViewCell()
//            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 160
        case 1:
            return 400
        default:
            return UITableView.automaticDimension
        }
    }
}
