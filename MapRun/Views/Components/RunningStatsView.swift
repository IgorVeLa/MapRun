//
//  RunningStatsView.swift
//  MapRun
//
//  Created by Igor L on 06/11/2024.
//

import SwiftUI

struct RunningStatsView: View {
    @Environment(LocationDataManager.self) var locationDataManager
    
    var body: some View {
        VStack {
            Text(String(format: "%.2f km", locationDataManager.currentDist))
            
            HStack {
                Text(String(format: "%.2f m/s", locationDataManager.currentSpeed))
            }
            
            HStack {
                Text(String(format: "%d:%02d /km", locationDataManager.currentPace[0], locationDataManager.currentPace[1]))
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    RunningStatsView()
        .environment(LocationDataManager())
}
