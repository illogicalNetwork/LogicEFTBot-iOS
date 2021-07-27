//
//  SearchView.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import SwiftUI

struct SearchView: View {
    
    /// The view model
    @ObservedObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SearchBar(query: $viewModel.searchQuery)
                if viewModel.items.isEmpty {
                    Spacer()
                    
                    Text("Enter Search Term Above")
                } else {
                    List(viewModel.items) { item in
                        EFTItemRow(item: item)
                    }
                }
                Spacer()
                    .navigationTitle("LogicalEFT")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.isShowingError, content: {
            Alert(title: Text("Error"), message: Text("Ther was an error with the request: \(viewModel.error?.description ?? "Unknown error. Please try again")"), dismissButton: .default(Text("OK")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
