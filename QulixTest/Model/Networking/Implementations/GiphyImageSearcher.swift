//
//  GiphyImageSearcher.swift
//  QulixTest
//
//  Created by Alex on 8.12.23.
//

import Foundation

class GiphyImageSearcher {
    
    private let session: URLSession
    private let step: Int
    private var currentQuery: String?
    private var currentOffset: Int
    private var totalCount: Int!
    
    private struct GiphyResponse: Codable {
        
        struct Pagination: Codable {
            let countReturned: Int
            let offset: Int
            let totalCount: Int?
            
            enum CodingKeys:String, CodingKey {
                case countReturned = "count"
                case offset
                case totalCount = "total_count"
            }
        }
        
        struct Meta: Codable {
            let status: Int
            let msg: String
        }
        
        let data: [ImageData]
        let pagination: Pagination
        let meta: Meta
    }
    
    private(set) var isEnded: Bool?
    
    private func createRequestUrl() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: "UJr6oLD7DKc9zFVtkC9FuJRc8bV1YzQh"), // i KNOW that this should be  protected from exposing, for example using env variable, this only for 0 setup on a new machine.
            URLQueryItem(name: "q", value: currentQuery),
            URLQueryItem(name: "limit", value: String(step)),
            URLQueryItem(name: "offset", value: String(currentOffset))
        ]
        guard let url = urlComponents.url else { throw QulixTestError.badUrlComponents }
        return url
    }
    
    private func request(for url: URL) -> URLRequest {
        let request = URLRequest(url: url)
        //MARK: customize http requust here
        //f e request.addValue("someValue", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func search(for query: String) async throws -> [ImageData] {
        currentOffset = 0
        self.currentQuery = query
        let requestUrl = try createRequestUrl()
        let (data, _) = try await session.data(for: request(for: requestUrl))
        let responseDecoded = try JSONDecoder().decode(GiphyResponse.self, from: data)
        currentOffset = responseDecoded.pagination.offset + responseDecoded.pagination.countReturned
        guard let totalCount = responseDecoded.pagination.totalCount else { throw QulixTestError.noTotalCountOnInitialRequest}
        self.totalCount = totalCount
        isEnded = (currentOffset >= totalCount)
        return responseDecoded.data
    }
    
    func getNext() async throws  -> [ImageData] {
        guard let isEnded = isEnded else { throw QulixTestError.noIsEndedFlagOnPagination }
        guard isEnded == false else { return [] }
        let requestUrl = try createRequestUrl()
        let (data, _) = try await session.data(for: request(for: requestUrl))
        let responseDecoded = try JSONDecoder().decode(GiphyResponse.self, from: data)
        currentOffset = responseDecoded.pagination.offset + responseDecoded.pagination.countReturned
        self.isEnded = (currentOffset >= totalCount)
        return responseDecoded.data
    }    

    required init(step: Int) {
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
        self.currentOffset = 0
        self.step = step
    }
    
}
