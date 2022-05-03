//
//  NetworkingService.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 2.05.2022.
//

import Foundation

class NetworkingService{
    static let shared = NetworkingService()
    
    func sendLog(payLoad: [String: Any]){
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payLoad, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        task.resume()
    }
}




