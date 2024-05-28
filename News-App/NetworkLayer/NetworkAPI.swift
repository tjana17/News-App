//
//  NetworkAPI.swift
//  News-App
//
//  Created by DB-MBP-023 on 27/05/24.
//16aed06c6ed5458d969b732a72ca3b46

import Foundation

protocol QueryParams {
    var country: String? { get }
    var category: Category? { get }
    var q: String? { get }
    var from: String? { get }
    var sortBy: String? { get }
    var apiKey: String { get }
}

extension QueryParams {
    var apiKey      : String    {return "YOUR API HERE"}
    var pageSize    : String    {return "5" }
    var queryItem : [URLQueryItem]  {
        [URLQueryItem(name: "country", value:country),
        URLQueryItem(name: "category", value:category?.rawValue),
         URLQueryItem(name: "q", value: q),
         URLQueryItem(name: "from", value: from),
         URLQueryItem(name: "sortBy", value: sortBy),
        URLQueryItem(name: "apiKey", value:apiKey)]
    }
}

enum Category: String, CaseIterable {
    case business = "business"
    case entertainment = "entertainment"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

enum Country: String {
    case argentina = "ar"
    case australia = "au"
    case austria = "at"
    case unitedStates = "us"
    case india = "in"
}

struct RequestParams: QueryParams {
    var country: String?
    var category: Category?
    var q: String?
    var from: String?
    var sortBy: String?
}

enum RequestType: String {
    case GET
    case POST
}

enum NetworkError: Error {
    case domainError
    case decodingError
    case noDataError
}

enum StatusCode: String {
    case successful = "ok"
}

struct RequestModel {
    let url: URLSchema
    let typeObj : RequestType = .GET
    var queryItems : [URLQueryItem]?
    let httpBody : [String:Any]? = nil
    let param : [String:Any]? = nil
    var httpHeaderField : [String : String]? = nil
}

enum URLSchema: String {
    case topHeadlines = "/v2/top-headlines"
    case everything = "/v2/everything"
}

extension URLSchema : CustomStringConvertible {
    var description: String {
        return "https://newsapi.org"+self.rawValue
    }
}

class NetworkRequestMain {
    
    static func postAction<T:Decodable>(_ requestModel:RequestModel,
                                        _ modelType: T.Type,
                                        completion: @escaping (Result<T,NetworkError>) -> Void) {
        let session = URLSession.shared
        var serviceUrl = URLComponents(string: requestModel.url.description)
        serviceUrl?.queryItems =  requestModel.queryItems
        guard let componentURL = serviceUrl?.url else { return }
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.typeObj.rawValue
        request.allHTTPHeaderFields =  requestModel.httpHeaderField
        
        if let parameterDictionary = requestModel.httpBody  {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
                return
            }
            request.httpBody = httpBody
        }
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(responseModel))
                } catch {
                    //type of failure
                    completion(.failure(.decodingError))
                    print(error)
                }
            } else {
                completion(.failure(.noDataError))
            }
        }.resume()
    }
    
}
