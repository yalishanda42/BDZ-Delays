//
//  TrainView.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 21.04.23.
//

import SwiftUI

struct TrainView: View {
    let vm: TrainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // train info header
            ZStack {
                switch vm.operation {
                case .notYetOperating:
                    Color.teal
                case .operating:
                    Color.green
                case .inStation:
                    Color.purple
                case .leftStationOrTerminated:
                    Color.gray
                }
                
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
            
            // arrival/departure timetable
            HStack(alignment: .top) {
                Spacer()
                DisplayTimeView(
                    time: vm.arrival,
                    operation: vm.operation,
                    title: "ПРИСТИГА",
                    pastEventText: "пристигнал"
                )
                Spacer()
                Divider()
                Spacer()
                DisplayTimeView(
                    time: vm.departure,
                    operation: vm.operation,
                    title: "ЗАМИНАВА",
                    pastEventText: "заминал"
                )
                Spacer()
            }.padding(.vertical, 6)
        }
    }
}

private struct DisplayTimeView: View {
    let time: TrainViewModel.DisplayTime?
    let operation: TrainViewModel.OperationState
    let title: String
    let pastEventText: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(title).bold().padding(.bottom, 5)
            
            if let time = self.time {
                Text(time.scheduled)
                
                if let delay = time.delay {
                    Text("+ \(delay.minutes)' зак.").foregroundColor(.red)
                    Text("≈ \(delay.estimate)")
                }
                
                switch operation {
                case .operating where time.delay == nil:
                    Text("навреме").foregroundColor(.green)
                case .leftStationOrTerminated:
                    Text(pastEventText).foregroundColor(.purple)
                default:
                    EmptyView()
                }
            } else {
                Text("---")
            }
        }
    }
}

// MARK: - Previews

struct TrainView_Previews: PreviewProvider {
    static var testVMs: [TrainViewModel] {
        [
            TrainViewModel(
                id: "БВ 26128",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: .init(
                    scheduled: "14:19",
                    delay: nil
                ),
                departure: nil
            ),
            TrainViewModel(
                id: "БВ 26138",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .leftStationOrTerminated,
                arrival: nil,
                departure: .init(
                    scheduled: "14:19",
                    delay: nil
                )
            ),
            TrainViewModel(
                id: "БВ 2612",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .operating,
                arrival: .init(
                    scheduled: "14:20",
                    delay: nil
                ),
                departure: nil
            ),
            TrainViewModel(
                id: "БВ 2613",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .inStation,
                arrival: nil,
                departure: .init(
                    scheduled: "14:20",
                    delay: nil
                )
            ),
            TrainViewModel(
                id: "КПВ 2612",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .operating,
                arrival: .init(
                    scheduled: "14:20",
                    delay: .init(minutes: 5, estimate: "14:25")
                ),
                departure: nil
            ),
            TrainViewModel(
                id: "ПВ 2112",
                from: "София",
                through: nil,
                to: "Варна",
                operation: .notYetOperating,
                arrival: nil,
                departure: .init(
                    scheduled: "14:21",
                    delay: .init(minutes: 5, estimate: "14:26")
                )
            ),
            TrainViewModel(
                id: "БВ 2112",
                from: "София",
                through: "Мездра",
                to: "Варна",
                operation: .operating,
                arrival: .init(
                    scheduled: "14:20",
                    delay: nil
                ),
                departure: .init(
                    scheduled: "14:30",
                    delay: nil
                )
            ),
            TrainViewModel(
                id: "МБВ 2112",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .operating,
                arrival: .init(
                    scheduled: "14:20",
                    delay: nil
                ),
                departure: .init(
                    scheduled: "14:30",
                    delay: nil
                )
            ),
            TrainViewModel(
                id: "КПВ 2112",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .operating,
                arrival:.init(
                    scheduled: "14:20",
                    delay: nil
                ),
                departure: .init(
                    scheduled: "14:21",
                    delay: .init(minutes: 5, estimate: "14:26")
                )
            ),
            TrainViewModel(
                id: "БВ 32612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .operating,
                arrival: .init(
                    scheduled: "14:21",
                    delay: .init(minutes: 5, estimate: "14:26")
                ),
                departure: .init(
                    scheduled: "14:41",
                    delay: .init(minutes: 5, estimate: "14:46")
                )
            ),
            TrainViewModel(
                id: "БВ 32612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                operation: .notYetOperating,
                arrival: .init(
                    scheduled: "14:21",
                    delay: nil
                ),
                departure: .init(
                    scheduled: "14:41",
                    delay: nil
                )
            ),
        ]
    }
    
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
}
