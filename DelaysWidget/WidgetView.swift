//
//  WidgetView.swift
//  DelaysWidgetExtension
//
//  Created by AI on 30.05.23.
//

import SwiftUI
import WidgetKit

import SharedModels

// MARK: - View

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
            }
            .frame(maxHeight: 28)
            .bold()
            .foregroundColor(.black)
            
            switch entry.result {
            case let .some(.success(trains)) where trains.isEmpty:
                Text("Няма влакове 6 часа напред.")
            case let .some(.success(trains)):
                list(of: trains)
                Spacer()
            case .some(.failure):
                Text("Неуспешна връзка.")
            case .none:
                list(of: placeholders)
                    .redacted(reason: .placeholder)
                Spacer()
            }
        }
        .padding(.bottom, 10)
    }
    
    private var rows: Int {
        switch size {
        case .systemLarge, .systemExtraLarge:
            return 19
        default:
            return 7
        }
    }
    
    @ViewBuilder
    private func list(of trains: [TrainAtStation]) -> some View {
        ForEach(Array(zip(0..<rows, trains)), id: \.0) { (_, train) in
            VStack(spacing: 0) {
                HStack {
                    Text("\(train.number.type.abbrev) \(String(train.number.number))").bold()
                    if size != .systemSmall {
                        Text("\(train.from.name) - \(train.to.name)")
                    }
                    Spacer()
                    schedule(of: train).appliedStatusColor(train)
                }
                Divider()
            }
            .lineLimit(1)
            .font(.system(size: 10))
            .padding(.horizontal, 3)
        }
    }
    
    @ViewBuilder
    private func schedule(of train: TrainAtStation) -> some View {
        Group {
            if train.delay != nil && [TrainAtStation.MovementState](arrayLiteral: .inOperation, .doorsOpen, .notYetOperating).contains(train.movement)  {
                Text("≈")
            }
            
            switch train.schedule {
            case let .arrivalOnly(arrival):
                Text("\(formatted(date: arrival, addedDelay: train.delay)) / -----")
            case let .departureOnly(departure):
                Text("----- / \(formatted(date: departure, addedDelay: train.delay))")
            case let .full(arrival: arrival, departure: departure):
                Text("\(formatted(date: arrival, addedDelay: train.delay)) / \(formatted(date: departure, addedDelay: train.delay))")
            }
        }
    }
    
    private func formatted(date: Date, addedDelay: Duration? = nil) -> String {
        let actual = addedDelay.map {
            date.addingDuration($0)
        } ?? date
        
        return actual.hoursAndMinutes
    }
    
    private var placeholders: [TrainAtStation] {
        Array(
            repeating: TrainAtStation(
                number: .init(type: .fast, number: 2112),
                from: .bulgarian(.sofia),
                to: .bulgarian(.varna),
                schedule: .full(arrival: Date(), departure: Date()),
                delay: nil,
                movement: .notYetOperating
            ),
            count: rows
        )
    }
}

fileprivate extension View {
    @ViewBuilder
    func appliedStatusColor(_ data: TrainAtStation) -> some View {
        switch data.movement {
        case .doorsOpen:
            foregroundColor(.purple)
        case .inOperation:
            if data.delay == nil {
                foregroundColor(.green)
            } else {
                foregroundColor(.red)
            }
        case .leavingStation, .stopped:
            foregroundColor(.gray)
        case .notYetOperating:
            self
        }
    }
}

// MARK: - Conversions

fileprivate extension Duration {
    var minutes: Int {
        Int(components.seconds / 60)
    }
}

fileprivate extension Date {
    func addingDuration(_ duration: Duration) -> Date {
        self + TimeInterval(duration.components.seconds)
    }
}

fileprivate let dateFormatter: DateFormatter = {
    let result = DateFormatter()
    result.dateFormat = "HH:mm"
    result.timeZone = TimeZone(identifier: "Europe/Sofia")
    return result
}()

fileprivate extension Date {
    var hoursAndMinutes: String {
        dateFormatter.string(from: self)
    }
}

// MARK: - Previews

struct WidgetView_Previews: PreviewProvider {
    private static let sizes: [(WidgetFamily, String)] = [
        (.systemSmall, "S"),
        (.systemMedium, "M"),
        (.systemLarge, "L"),
        (.systemExtraLarge, "XL"),
    ]
    
    static var previews: some View {
        ForEach(sizes, id: \.1) {
            WidgetView(entry: SimpleEntry(
                date: Date(),
                configuration: SelectStationIntent(),
                result: nil
            ))
                .previewContext(WidgetPreviewContext(family: $0.0))
                .previewDisplayName($0.1)
        }
    }
}
