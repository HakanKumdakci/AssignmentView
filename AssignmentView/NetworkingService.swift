//
//  NetworkingService.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 2.05.2022.
//

import Foundation

class NetworkingService{
    static let shared = NetworkingService()
    
    func sendLog(payLoad: [String: Any], completion: @escaping (ResponseHttpBin) -> Void){
        let urlString = "https://httpbin.org/post"
        
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payLoad, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print("Function: \(#function), line: \(#line)")
                return
            }
            guard let data = data else {
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let object = try decoder.decode(ResponseHttpBin.self, from: data)
                completion(object)
            }catch{
                print("")
            }
        }
        task.resume()
    }
}




