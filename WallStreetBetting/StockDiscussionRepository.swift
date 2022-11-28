//
//  StockDiscussionRepository.swift
//  WallStreetBetting
//
//  Created by Jason Philpy on 11/19/22.
//

import Foundation

class StockDiscussionRepository {
    
    func getTop50StockDiscussions(date: String? = nil, completion: @escaping (_ discussions: Array<StockDiscussion>?, _ error: String?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "tradestie.com"
        components.path = "/api/v1/apps/reddit"
        if let date = date {
            components.queryItems = [
                URLQueryItem(name: "date", value: date)
            ]
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error.localizedDescription)
                } else if let data = data {
                    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? Array<Dictionary<String,Any>> {
                        var discussions = [StockDiscussion]()
                        for obj in jsonData {
                            let discussion = StockDiscussion(dict: obj)
                            discussions.append(discussion)
                        }
                        completion(discussions, nil)
                    } else {
                        completion(nil, "Unexpected Error")
                    }
                } else {
                    completion(nil, "Unexpected Error")
                }
            }
        }
        task.resume()
    }
}
