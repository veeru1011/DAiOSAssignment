//
//  APIManager.swift
//  DAiOSAssignment
//
//  Created by VEER BAHADUR TIWARI on 16/07/18.
//  Copyright © 2018 docAnywhere. All rights reserved.
//

import UIKit

struct APIURL {
    static let baseURL = "http://sd2-hiring.herokuapp.com/api/users"
}

class APIManager: NSObject {
    
    var limit:Int=10
    private static var sharedInstance: APIManager = {
        let apiManager = APIManager(baseURL: APIURL.baseURL)
        return apiManager
    }()
    
    let baseURL: String
    
    private init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    private override init() {
        self.baseURL = APIURL.baseURL
    }
    
    class func shared() -> APIManager {
        return sharedInstance
    }
    
    // Fetching data from server
    func getUserList(pageNo: Int, completionHandler:@escaping(Bool,ResultModel?) -> Void) -> Void  {
        let offset = pageNo * limit
        let urlString = self.baseURL + "?offset=\(offset)" + "&limit=\(limit)"
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let userlist = try decoder.decode(ResultModel.self, from: data)
                completionHandler(true,userlist)
                
            } catch let err {
                print(err)
                completionHandler(false,nil)
            }
        })
        task.resume()
    }
}
