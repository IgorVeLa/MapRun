//
//  RunningView-ViewModel.swift
//  And it's components used
//  MapRun
//
//  Created by Igor L on 04/11/2024.
//

import Foundation
import _MapKit_SwiftUI

extension RunningView {
    @Observable
    class ViewModel {
        var position: MapCameraPosition = .userLocation(fallback: .automatic)
    }
}

extension RunningPlayView {
    @Observable
    class ViewModel {
        var isRunning = false
        var isShowingPolyLine = false
        var isShowingStopwatch = false
        var isShowingSaveSheet = false
        let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
        
        var totalDistance = 0.0
        var speed = 0.0
        var pace = [0, 0]
        
        var currentRun: Run? = nil
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
