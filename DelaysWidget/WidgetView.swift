//
//  WidgetView.swift
//  DelaysWidgetExtension
//
//  Created by AI on 30.05.23.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    let entry: Provider.Entry
    
    @Environment(\.widgetFamily) private var size: WidgetFamily

    @ViewBuilder
    var body: some View {
        VStack(spacing: 1) {
            ZStack {
                Color.teal
                
                if let station = entry.configuration.station {
                    Text(station)
                } else {
                    Text("София").redacted(reason: .placeholder)
                }
            }.frame(maxHeight: 28)
            
            ForEach(Array(1...rows), id: \.self) { _ in
                VStack(spacing: 0) {
                    HStack {
                        Text("БВ 2612")
                        if size != .systemSmall {
                            Text("Видин пътн. - Горна оряховица")
                        }
                        Spacer()
                        Text("≈ 11:22 / 11:32")
                    }
                    Divider()
                }
                .lineLimit(1)
                .font(.footnote)
                .padding(.horizontal, 3)
            }
            
            Spacer()
        }.padding(.bottom, 10)
    }
    
    private var rows: Int {
        switch size {
        case .systemLarge, .systemExtraLarge:
            return 19
        default:
            return 7
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    private static let sizes: [(WidgetFamily, String)] = [
        (.systemSmall, "S"),
        (.systemMedium, "M"),
        (.systemLarge, "L"),
        (.systemExtraLarge, "XL"),
    ]
    
    static var previews: some View {
        ForEach(sizes, id: \.1) {
            WidgetView(entry: SimpleEntry(date: Date(), configuration: SelectStationIntent()))
                .previewContext(WidgetPreviewContext(family: $0.0))
                .previewDisplayName($0.1)
        }
    }
}
