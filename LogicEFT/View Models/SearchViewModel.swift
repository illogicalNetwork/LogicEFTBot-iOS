//
//  SearchViewModel.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    /// The  EFTItems returned from the search request
    @Published var items: [EFTItem] = []
    
    @Published var item: EFTItem? = nil {
        didSet {
            self.itemName = item?.name ?? "Unknown"
            self.itemShortName = item?.shortName ?? "Unknown"
        }
    }
    
    /// The current search query
    @Published var searchQuery: String = ""
    
    /// The error returned from the request
    @Published var error: HTTPError? = nil
    
    /// Boolean that determines if an error is displayed
    @Published var isShowingError: Bool = false
    
    // MARK: - Published Item Properties
    
    /// Published item name
    @Published var itemName: String = ""
    @Published var itemShortName: String = ""
    
    /// The active subscriptions
    var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        $searchQuery
            // If the user types, and then pauses for 800 ms, then send a request to the API
            .debounce(for: .milliseconds(800), scheduler: DispatchQueue.main)
            // Prevent multiple requests for the same query
            .removeDuplicates()
            // Map the search bar text into a new string, return nil if the query is less than 1 char, to prevent sending a request when the view is first loaded.
            .map { (searchFieldText) -> String? in
                if searchFieldText.count < 1 {
                    self.items = []
                    return nil
                }
                
                return searchFieldText
            }
            // Remove nil values
            .compactMap { $0 }
            // Based on the value coming down the pipeline, send a request
            .sink(receiveValue: { [weak self] searchQuery in
                self?.searchMarket()
            })
            .store(in: &subscriptions)
    }
    
    func searchMarket() {
        EFTMarketAPI.shared.queryMarket(for: searchQuery)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                // If an error occurred, set the error property to the error, and toggle to show the error
                case .failure(let error):
                    self?.error = error
                    self?.isShowingError = true
                case .finished:
                    self?.error = nil
                    self?.isShowingError = false
                }
            }, receiveValue: { [weak self] item in
                self?.items = []
                self?.item = item
                self?.items.append(item)
            })
            .store(in: &subscriptions)
    }
}
