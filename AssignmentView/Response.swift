//
//  Response.swift
//  AssignmentView
//
//  Created by Hakan Kumdakçı on 3.05.2022.
//

import Foundation

struct ResponseHttpBin: Codable{
    var args: [String: String]
    var data: String
    var files: [String: String]?
    var form: [String: String]?
    var json: JsonData
    var origin: String
    var url: String
}

struct JsonData: Codable{
    var loadTime: Double
}

