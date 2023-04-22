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
                Color.teal
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
                    title: "ПРИСТИГА"
                )
                Spacer()
                Divider()
                Spacer()
                DisplayTimeView(
                    time: vm.departure,
                    title: "ЗАМИНАВА"
                )
                Spacer()
            }.padding(.vertical, 6)
        }
    }
}

private struct DisplayTimeView: View {
    let time: TrainViewModel.DisplayTime?
    let title: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(title).bold().padding(.bottom, 5)
            AnyView(timeView)
        }
    }
    
    private var timeView: any View {
        switch self.time {
        case .none:
            return Text("---")
        case let .some(.scheduled(time)):
            return Text(time)
        case let .some(.punctual(time)):
            return Group {
                Text(time)
                Text("навреме").foregroundColor(.green)
            }
        case let .some(.delayed(scheduled: scheduled, delay: delay, estimate: estimate)):
            return Group {
                Text(scheduled)
                Text("+ \(delay)' зак.").foregroundColor(.red)
                Text("≈ \(estimate)")
            }
        }
    }
}

// MARK: - Previews

struct TrainView_Previews: PreviewProvider {
    static var testVMs: [TrainViewModel] {
        [
            TrainViewModel(
                id: "БВ 2612",
                from: "София",
                through: nil,
                to: "Варна",
                arrival: .punctual("14:20"),
                departure: nil
            ),
            TrainViewModel(
                id: "БВ 2613",
                from: "София",
                through: nil,
                to: "Варна",
                arrival: nil,
                departure: .scheduled("14:21")
            ),
            TrainViewModel(
                id: "КПВ 2612",
                from: "София",
                through: nil,
                to: "Варна",
                arrival: .delayed(scheduled: "14:20", delay: "5", estimate: "14:25"),
                departure: nil
            ),
            TrainViewModel(
                id: "ПВ 2112",
                from: "София",
                through: nil,
                to: "Варна",
                arrival: nil,
                departure: .delayed(scheduled: "14:21", delay: "25", estimate: "14:46")
            ),
            TrainViewModel(
                id: "БВ 2112",
                from: "София",
                through: "Мездра",
                to: "Варна",
                arrival: .punctual("14:20"),
                departure: .punctual("14:30")
            ),
            TrainViewModel(
                id: "МБВ 2112",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                arrival: .punctual("14:20"),
                departure: .punctual("14:30")
            ),
            TrainViewModel(
                id: "КПВ 2112",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                arrival: .punctual("14:20"),
                departure: .delayed(scheduled: "14:30", delay: "5", estimate: "14:35")
            ),
            TrainViewModel(
                id: "БВ 12612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                arrival: .delayed(scheduled: "14:20", delay: "5", estimate: "14:25"),
                departure: .punctual("14:30")
            ),
            TrainViewModel(
                id: "БВ 22612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                arrival: .delayed(scheduled: "14:20", delay: "5", estimate: "14:25"),
                departure: .delayed(scheduled: "14:21", delay: "25", estimate: "14:46")
            ),
            TrainViewModel(
                id: "БВ 32612",
                from: "София",
                through: "Горна Оряховица",
                to: "Варна",
                arrival: .delayed(scheduled: "14:20", delay: "25", estimate: "14:45"),
                departure: .delayed(scheduled: "14:21", delay: "25", estimate: "14:46")
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
