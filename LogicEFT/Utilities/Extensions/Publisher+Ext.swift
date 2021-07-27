//
//  Publisher+Ext.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import Foundation
import Combine

public extension Publisher where Output == (data: Data, response: URLResponse) {
    // Convert the response tuple of URLSession's dataTask from (data: Data, response: URLResponse) to (data: Data, response: HTTPURLResponse). Lets us check the http status code down the line.
    
    /// Get proper HTTP response from URLSession's dataTask function.
    func assumeHTTP() -> AnyPublisher<(data: Data, response: HTTPURLResponse), HTTPError> {
        tryMap { (data: Data, response: URLResponse) in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.nonHTTPResponse
            }
            
            return (data, httpResponse)
        }
        .mapError { error in
            if error is HTTPError {
                return error as! HTTPError
            } else {
                return HTTPError.networkError(error)
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == (data: Data, response: HTTPURLResponse) {
    // Take the (data: Data, response: HTTPURLResponse) tuple object, and check the HTTP status code. If we get a 200, return the raw API Data.
    // If we get a 400-499 status code, throw an HTTPError.requestFailed error with the encountered status code.
    // If we get a 500-599 status code, throw an HTTPError.serverError error with the encountered status code.
    // If we get any other status code, throw an HTTPError.custom error with a string describing the status code we received.
    
    /// Take the (data: Data, response: HTTPURLResponse) tuple, and make sure the server sends back a 200 status code before we pass down the raw data.
    func responseData() -> AnyPublisher<Data, HTTPError> {
        tryMap { (data: Data, response: HTTPURLResponse) in
            switch response.statusCode {
            case 200:
                return data
            case 400...499:
                throw HTTPError.requestFailed(response.statusCode)
            case 500...599:
                throw HTTPError.serverError(response.statusCode)
            default:
                throw HTTPError.custom("Received an unhandled HTTP Response Status Code: \(response.statusCode)")
            }
        }
        .mapError { $0 as! HTTPError }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == Data, Failure == HTTPError {
    // Take the raw API Data object, and decode it to a specified model item. Item here is a generic, but you see on line 38 in EFTMarketAPI.swift we decode the data as an EFTItem object.
    
    /// Decode the raw Data to a specified model object that conforms to the Decodable protocol.
    func decoding<Item, Coder>(type: Item.Type, decoder: Coder) -> AnyPublisher<Item, HTTPError> where Item: Decodable, Coder: TopLevelDecoder, Self.Output == Coder.Input {
        decode(type: type, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return HTTPError.decodingError(error as! DecodingError)
                } else {
                    return error as! HTTPError
                }
            }
            .eraseToAnyPublisher()
    }
}
