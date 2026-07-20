//
//  DocumentRequest.swift
//  EDI Delivery
//
//  Created by hayot on 6/18/26.
//

internal import Foundation

struct DocumentRequest: Codable {
    var limit: Int = 500
    var date_start: String?
    var date_end: String?
}
