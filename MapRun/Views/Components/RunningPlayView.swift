//
//  RunningPlayView.swift
//  MapRun
//
//  Created by Igor L on 06/11/2024.
//

import SwiftUI

struct RunningPlayView: View {
    @Environment(LocationDataManager.self) var locationDataManager
    @Environment(TimeManager.self) var timeManager
    @Environment(\.managedObjectContext) var context
    @Environment(\.scenePhase) var scenePhase
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if viewModel.isRunning {
                        locationDataManager.stopTrack()
                        
                        viewModel.isRunning.toggle()
                        print("isRunning: \(viewModel.isRunning) (should be false)")
                        viewModel.isShowingStopwatch.toggle()
                        print("isShowingStopwatch \(viewModel.isShowingStopwatch) (should be false)")
                        
                        // store run details
                        viewModel.currentRun = Run(context: context)
                        viewModel.currentRun?.title = ""
                        viewModel.currentRun?.time = timeManager.totalTimeInS
                        viewModel.currentRun?.distance = locationDataManager.currentDist
                        viewModel.currentRun?.speed = locationDataManager.currentSpeed
                        viewModel.currentRun?.pace = locationDataManager.currentPace
                        viewModel.currentRun?.dateAdded = Date.now
                        
                        viewModel.isShowingSaveSheet.toggle()
                    } else {
                        locationDataManager.requestPermission()
                        
                        locationDataManager.startTrack()
                        
                        viewModel.isRunning.toggle()
                        print("isRunning: \(viewModel.isRunning) (should be true)")
                        viewModel.isShowingStopwatch.toggle()
                        print("isShowingStopwatch \(viewModel.isShowingStopwatch) (should be true)")
                    }
                } label: {
                    Image(systemName: viewModel.isRunning ? "flag.checkered.circle.fill" : "play.circle.fill")
                        .font(.system(size: 50))
                }
                .sheet(isPresented: $viewModel.isShowingSaveSheet, onDismiss: resetData) {
                    if let currentRun = viewModel.currentRun {
                        SaveRunView(run: currentRun, locations: locationDataManager.locations)
                            .presentationDetents([.medium, .medium])
                            .presentationDragIndicator(.hidden)
                    }
                }
                
                if (viewModel.isRunning) {
                    RunningStatsView()
                }
            }
            
            
            if viewModel.isShowingStopwatch {
                Text(timeManager.formattedUnits)
                    .onReceive(viewModel.timer, perform: { _ in
                        timeManager.totalTimeInS += 1
                    })
            }
        }
    }
    
    func resetData() {
        locationDataManager.locations = []
        locationDataManager.currentPace = [0, 0]
        locationDataManager.currentSpeed = 0
        locationDataManager.currentDist = 0
        timeManager.totalTimeInS = 0
        
        print("data reset")
    }
}

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    
    RunningPlayView()
        .environment(LocationDataManager())
        .environment(TimeManager())
        .environment(\.managedObjectContext, context)
}

