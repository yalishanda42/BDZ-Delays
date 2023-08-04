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
    let entry: TrainsTimelineProvider.Entry
    
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
            
            if entry.configuration.station != nil {
                result(entry.result)
            } else {
                Spacer()
                Text("Изберете гара като задържите с пръст тук")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.2)
                    .foregroundColor(.teal)
                    .padding()
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
    private func result(_ result:  Result<[TrainAtStation], Error>?) -> some View {
        switch result {
        case let .some(.success(trains)) where trains.isEmpty:
            Spacer()
            Text("Няма влакове 6 часа напред.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        case let .some(.success(trains)):
            list(of: trains)
            Spacer()
        case .some(.failure):
            Spacer()
            Text("Неуспешна връзка.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        case .none:
            list(of: placeholders)
                .redacted(reason: .placeholder)
            Spacer()
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
        createPlaceholders(count: rows)
    }
}

fileprivate func createPlaceholders(count: Int) -> [TrainAtStation] {
    Array(
        repeating: TrainAtStation(
            number: .init(type: .fast, number: 2112),
            from: .bulgarian(.sofia),
            to: .bulgarian(.varna),
            schedule: .full(arrival: Date(), departure: Date()),
            delay: nil,
            movement: .notYetOperating
        ),
        count: count
    )
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
    
    private struct TestError: Error {}
    
    private static let sofiaEntry: SelectStationIntent = {
        let result = SelectStationIntent()
        result.station = "София"
        return result
    }()
    
    static var previews: some View {
        ForEach(sizes, id: \.1) {
            WidgetView(entry: TrainsEntry(
                date: Date(),
                configuration: SelectStationIntent(),
                result: nil
            ))
            .previewContext(WidgetPreviewContext(family: $0.0))
            .previewDisplayName("\($0.1): init")
        }
        
        ForEach(sizes, id: \.1) {
            WidgetView(entry: TrainsEntry(
                date: Date(),
                configuration: sofiaEntry,
                result: nil
            ))
            .previewContext(WidgetPreviewContext(family: $0.0))
            .previewDisplayName("\($0.1): nil")
        }
        
        ForEach(sizes, id: \.1) {
            WidgetView(entry: TrainsEntry(
                date: Date(),
                configuration: sofiaEntry,
                result: .success([])
            ))
            .previewContext(WidgetPreviewContext(family: $0.0))
            .previewDisplayName("\($0.1): []")
        }
        
        ForEach(sizes, id: \.1) {
            WidgetView(entry: TrainsEntry(
                date: Date(),
                configuration: sofiaEntry,
                result: .success(createPlaceholders(count: 5))
            ))
            .previewContext(WidgetPreviewContext(family: $0.0))
            .previewDisplayName("\($0.1): [...]")
        }
        
        ForEach(sizes, id: \.1) {
            WidgetView(entry: TrainsEntry(
                date: Date(),
                configuration: sofiaEntry,
                result: .failure(TestError())
            ))
            .previewContext(WidgetPreviewContext(family: $0.0))
            .previewDisplayName("\($0.1): error")
        }
    }
}
