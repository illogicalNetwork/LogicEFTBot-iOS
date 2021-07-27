//
//  EFTItemRow.swift
//  LogicEFT
//
//  Created by James Sayer on 7/8/21.
//

import SwiftUI
import Kingfisher

struct EFTItemRow: View {
    
    /// The EFTItem that is passed in to construct the view
    let item: EFTItem
    
    var body: some View {
        NavigationLink(
            destination: EFTItemDetailView(item: item),
            label: {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(item.shortName)
                            .font(.headline)
                        Text("\(item.price)₽")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    KFImage(item.imgURL)
                        .resizable()
                        .fade(duration: 0.5)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 75)
                }
                .padding()
            })
    }
}

struct EFTItemRow_Previews: PreviewProvider {
    static var previews: some View {
        EFTItemRow(item: MockItem)
    }
}

// Mock Data to use in SwiftUI Previews
let MockItem = EFTItem(uid: "123", name: "LBT 6094A Slick Plate Carrier (Olive)", shortName: "Slick", price: 280000, basePrice: 374500, avg24hPrice: 239949, avg7daysPrice: 238018, traderName: "Ragman", traderPrice: 232190, traderPriceCur: "₽", updated: "2021-07-08T12:40:05.526Z", slots: 9, diff24h: 16.69, diff7days: 17.64, icon: "https://cdn.tarkov-market.com/images/items/lbt_6094a_slick_plate_carrier_(olive)_sm.png", link: "https://tarkov-market.com/item/lbt_6094a_slick_plate_carrier_(olive)", wikiLink: "https://escapefromtarkov.fandom.com/wiki/LBT_6094A_Slick_Plate_Carrier", img: "https://cdn.tarkov-market.com/images/items/lbt_6094a_slick_plate_carrier_(olive)_sm.png", imgBig: "https://cdn.tarkov-market.com/images/items/lbt_6094a_slick_plate_carrier_(olive)_lg.png", bsgId: "6038b4ca92ec1c3103795a0d", isFunctional: true, reference: "https://www.patreon.com/tarkov_market")
