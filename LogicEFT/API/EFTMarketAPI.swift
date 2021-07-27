//
//  EFTMarketAPI.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import Foundation
import Combine

class EFTMarketAPI {
    /// The shared singleton instance
    static let shared = EFTMarketAPI()
    static let baseURL = URL(string: "https://eft.bot/redactedAPIURL")!
    
    enum URLs {
        case query(String)
        
        var url: URL {
            switch self {
            case .query(let query):
                var components = URLComponents(url: EFTMarketAPI.baseURL, resolvingAgainstBaseURL: false)
                components?.queryItems = [
                    URLQueryItem(name: "s", value: query)
                ]
                
                return (components?.url)!
            }
        }
    }
    
    public func queryMarket(for name: String) -> AnyPublisher<EFTItem, HTTPError> {
        let url = URLs.query(name).url
        print(url.absoluteString)
        return URLSession.shared.dataTaskPublisher(for: url)
            .assumeHTTP()
            .responseData()
            .decoding(type: EFTItem.self, decoder: JSONDecoder())
    }
}
