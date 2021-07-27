//
//  EFTItemDetailView.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import SwiftUI
import Kingfisher

// MARK: - EFTItemDetailView
struct EFTItemDetailView: View {
    
    /// The passed in item to construct the view
    let item: EFTItem
    
    /// The detail list items
    @State private var detailListItems: [EFTItemDetailListRow] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                KFImage(item.imgBigURL)
                    .resizable()
                    .fade(duration: 0.5)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                buildDetailList()
                Spacer()
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .navigationTitle(item.shortName)
    }
    
    // Builds and returns a List (table) of detail data of the item
    private func buildDetailList() -> some View {
        let items = self.buildDetailItems()
        
        let list = List(items) { item in
            EFTItemDetailListRow(detailItem: item)
        }
        
        return list
    }
    
    // Compiles an array of EFTDetailItems to be used in the Table/List
    private func buildDetailItems() -> [EFTDetailItem] {
        var items: [EFTDetailItem] = []
        let price = EFTDetailItem(iconName: "clock", title: "\(item.priceString)", subtitle: "Latest Price")
        let lastUpdated = EFTDetailItem(iconName: "calendar", title: item.hoursSinceLastUpdate, subtitle: "Last Updated")
        let pricePerSlot = EFTDetailItem(iconName: "square.grid.3x3.topleft.fill", title: item.pricePerSlotString, subtitle: "Price Per Slot")
        let buyback = EFTDetailItem(iconName: "cart", title: item.traderBuybackString, subtitle: "Trader Buyback")
        let dayAverage = EFTDetailItem(iconName: "24.circle", title: item.twentyFourHourAveragePrice, subtitle: "24 Hour Average Price: \(item.diff24hString)", color: item.diff24hColor)
        let weekAverage = EFTDetailItem(iconName: "7.circle", title: item.sevenDayAveragePrice, subtitle: "7 Day Average Price: \(item.diff7dString)", color: item.diff7dColor)
        
        [price, lastUpdated, pricePerSlot, buyback, dayAverage, weekAverage].forEach { items.append($0) }
        
        return items
    }
}

struct EFTItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EFTItemDetailView(item: MockItem)
    }
}

// MARK: - EFTDetailItem

/// EFTDetailItem is used to build a row in the table/list of detail info of an EFTItem
struct EFTDetailItem: Identifiable {
    var id = UUID()
    let iconName: String
    let title: String
    let subtitle: String
    var color: Color = .blue
}

// MARK: - EFTItemDetailListRow

/// EFTItemDetailListRow is the View object that displays data from an EFTDetailItem
struct EFTItemDetailListRow: View {
    let detailItem: EFTDetailItem
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: detailItem.iconName)
                .resizable()
                .frame(width: 25, height: 25)
                .padding(10)
                .background(detailItem.color)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(detailItem.title)
                    .font(.headline)
                Text(detailItem.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal)
    }
}
