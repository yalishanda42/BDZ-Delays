//
//  TrainView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

public struct TrainView: View {
    let vm: TrainViewModel
    
    public init(vm: TrainViewModel) {
        self.vm = vm
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            header
            operationStateDivider
                .frame(height: 4)
            
            schedule
                .padding(.vertical, 6)
            
            if let delay = vm.delayInMinutes {
                Text("+ \(delay)' зак.")
                    .foregroundColor(.red)
            } else if vm.operation == .operating {
                Text("навреме")
                    .foregroundColor(.green)
            }
            
            if vm.delayInMinutes != nil {
                actualSchedule
                    .padding(.top, 6)
            }
            
            statusAdditionalText
        }
        .padding(.bottom, 6)
    }
    
    @ViewBuilder
    private var header: some View {
        ZStack {
            headerColor
            
            VStack(spacing: 0) {
                Text(vm.id).bold()
                HStack {
                    Text("от \(vm.from)")
                    Spacer()
                    if let through = vm.through {
                        Text("през \(through)")
                            .minimumScaleFactor(0.25)
                        Spacer()
                    }
                    Text("за \(vm.to)")
                }
            }.padding(.vertical, 4)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
        }
    }
    
    private var headerColor: Color {
        switch vm.operation {
        case .leftStationOrTerminated:
            return .gray
        default:
            return .teal
        }
    }
    
    @ViewBuilder
    private var operationStateDivider: some View {
        switch vm.operation {
        case .notYetOperating:
            Color.clear
        case .operating:
            Color.green.blinking()
        case .inStation:
            Color.purple.blinking()
        case .leftStationOrTerminated:
            Color.clear
        }
    }
    
    @ViewBuilder
    private var schedule: some View {
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Text("ПРИСТИГА").bold().padding(.bottom, 5)
                if let time = vm.arrival {
                    Text(time.scheduled)
                        .strikethrough(vm.delayInMinutes != nil, color: .red)
                } else {
                    Text("---")
                }
            }
            Spacer()
            
            Divider()
            
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Text("ЗАМИНАВА").bold().padding(.bottom, 5)
                if let time = vm.departure {
                    Text(time.scheduled)
                        .strikethrough(vm.delayInMinutes != nil, color: .red)
                } else {
                    Text("---")
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var actualSchedule: some View {
        HStack(spacing: 0) {
            Spacer()
            if let arrivalActual = vm.arrival?.actual {
                switch vm.operation {
                case .operating, .notYetOperating:
                    Text("≈\(arrivalActual)")
                case .leftStationOrTerminated where vm.departure == nil:
                    Text(arrivalActual)
                default:
                    scheduleSpacing
                }
            } else {
                scheduleSpacing
            }
            Spacer()
            
            Color.clear.frame(width: 1.0)
            
            Spacer()
            if let departureActual = vm.departure?.actual {
                switch vm.operation {
                case .operating, .inStation, .notYetOperating:
                    Text("≈\(departureActual)")
                case .leftStationOrTerminated:
                    Text(departureActual)
                }
            } else {
                scheduleSpacing
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private var scheduleSpacing: some View {
        Text("--:--").foregroundColor(.clear) // just to align content
    }
    
    @ViewBuilder
    private var statusAdditionalText: some View {
        if vm.operation == .leftStationOrTerminated {
            leftOrTerminatedText
                .foregroundColor(.gray)
        } else if vm.operation == .inStation {
            Text("тръгва скоро")
                .foregroundColor(.purple)
        }
    }
    
    @ViewBuilder
    private var leftOrTerminatedText: some View {
        if vm.arrival != nil && vm.departure == nil {
            Text("пристигнал")
        } else if vm.departure != nil {
            Text("заминал")
        }
    }
}

// MARK: - Blinking

fileprivate struct BlinkViewModifier: ViewModifier {
    let duration: Double
    @State private var opacity: Double = 0.0
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .animation(
                .easeInOut(duration: duration).repeatForever(),
                value: opacity
            )
            .onAppear {
                withAnimation {
                    opacity = 1.0
                }
            }
    }
}

fileprivate extension View {
    func blinking(duration: Double = 1.0) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}

// MARK: - Previews

struct TrainView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ForEach(testVMs) { vm in
                Section {
                    TrainView(vm: vm)
                        .listRowInsets(.init())
                }
            }
        }.preferredColorScheme(.light)
        .previewDisplayName("Light mode list")
        
        List {
            ForEach(testVMs) { vm in
                Section {
                    TrainView(vm: vm)
                        .listRowInsets(.init())
                }
            }
        }.preferredColorScheme(.dark)
        .previewDisplayName("Dark mode list")
    }
    
    static var testVMs: [TrainViewModel] {
        [
            TrainViewModel(
                id: "БВ 26128",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: .init("14:19"),
                departure: nil,
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "БВ 26138",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: .init("14:09"),
                departure: .init("14:19"),
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "БВ 261388",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: .init("14:09", actual: "14:10"),
                departure: .init("14:19", actual: "14:20"),
                delayInMinutes: 1
            ),
            TrainViewModel(
                id: "БВ 261389",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: .init("14:09", actual: "14:10"),
                departure: nil,
                delayInMinutes: 1
            ),
            TrainViewModel(
                id: "БВ 2612",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .operating,
                arrival: .init("14:20", actual: "14:22"),
                departure: .init("14:30", actual: "14:32"),
                delayInMinutes: 2
            ),
            TrainViewModel(
                id: "МБВ 261212",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .operating,
                arrival: .init("14:20", actual: "14:22"),
                departure: nil,
                delayInMinutes: 2
            ),
            TrainViewModel(
                id: "БВ 2613",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .inStation,
                arrival: nil,
                departure: .init("14:20"),
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "КПВ 261277",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .inStation,
                arrival: .init("14:20", actual: "14:25"),
                departure: .init("14:30", actual: "14:35"),
                delayInMinutes: 5
            ),
            TrainViewModel(
                id: "КПВ 26127",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .operating,
                arrival: .init("14:40", actual: "14:45"),
                departure: .init("14:50", actual: "14:55"),
                delayInMinutes: 5
            ),
            TrainViewModel(
                id: "БВ 2112",
                from: "София",
                through: "Мездра",
                to: "Варна",
                operation: .operating,
                arrival: .init("14:20"),
                departure: .init("14:30"),
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "МБВ 2112",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .operating,
                arrival: .init("14:20"),
                departure: .init("14:30"),
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "БВ 32612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .operating,
                arrival: .init("14:21", actual: "14:26"),
                departure: .init("14:41", actual: "14:46"),
                delayInMinutes: 5
            ),
            TrainViewModel(
                id: "БВ 32613",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .notYetOperating,
                arrival: .init("14:21"),
                departure: .init("14:41"),
                delayInMinutes: nil
            ),
            TrainViewModel(
                id: "ПВ 20210",
                from: "Лакатникк",
                through: nil,
                to: "София",
                operation: .notYetOperating,
                arrival: .init("14:21", actual: "14:30"),
                departure: nil,
                delayInMinutes: 9
            ),
        ]
    }
}
