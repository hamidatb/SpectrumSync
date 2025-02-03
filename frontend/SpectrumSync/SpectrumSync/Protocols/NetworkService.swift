//
//  NetworkService.swift
//  SpectrumSync
//
//  Created by Hamidat Bello on 2025-01-26.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}
