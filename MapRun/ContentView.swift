//
//  ContentView.swift
//  MapRun
//
//  Created by Igor L on 09/06/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @Environment(LocationDataManager.self) var locationDataManager
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var isShowingPolyLine = false
    @State var isRunning = false
    @State var isShowingStopwatch = false
    @State var isShowingSaveSheet = false
    
    @State var stopwatchSecond = 0
    @State var stopwatchMinute = 0
    @State var stopwatchHour = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var totalDistance = 0.0
    @State var speed = 0.0
    @State var pace = [0, 0]
    
    @State var currentRun: Run? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Map(position: $position) {
                    // shows the user location when zoomed out
                    UserAnnotation()
                    
                    locationDataManager.drawRoute(locations: locationDataManager.locations)
                        .stroke(.red, lineWidth: 5)
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                }
                
                
                
                HStack {
                    VStack {
                        Button {
                            if isRunning {
                                locationDataManager.stopTrack()
                                
                                isRunning.toggle()
                                print("isRunning: \(isRunning) (should be false)")
                                isShowingStopwatch.toggle()
                                print("isShowingStopwatch \(isShowingStopwatch) (should be false)")
                                
                                totalDistance = locationDataManager.measureTotalDistanceInKm(locations: locationDataManager.locations)
                                
                                speed = locationDataManager.measureSpeed(locations: locationDataManager.locations)
                                
                                pace = locationDataManager.measurePace(locations: locationDataManager.locations, totalTime: locationDataManager.totalTimeInS)
                                
                                // store run details
                                currentRun = Run(title: "",
                                          locations: locationDataManager.locations,
                                          time: locationDataManager.totalTimeInS,
                                          distance: locationDataManager.measureTotalDistanceInKm(locations: locationDataManager.locations),
                                          pace: locationDataManager.currentPace,
                                          speed: locationDataManager.currentSpeed,
                                          routeLine: locationDataManager.drawRoute(locations: locationDataManager.locations))
                                
                                // clear time
                                locationDataManager.totalTimeInS = 0
                                stopwatchSecond = 0
                                stopwatchMinute = 0
                                stopwatchHour = 0
                                print("time reset")
                                
                                isShowingSaveSheet.toggle()
                            } else {
                                locationDataManager.requestPermission()
                                
                                locationDataManager.startTrack()
                                
                                isRunning.toggle()
                                print("isRunning: \(isRunning) (should be true)")
                                isShowingStopwatch.toggle()
                                print("isShowingStopwatch \(isShowingStopwatch) (should be true)")
                            }
                        } label: {
                            Image(systemName: isRunning ? "flag.checkered.circle.fill" : "play.circle.fill")
                                .font(.title)
                        }
                        .sheet(isPresented: $isShowingSaveSheet) {
                            if let currentRun = currentRun {
                                SaveRun(run: currentRun)
                                    .presentationDetents([.medium, .large])
                                    .presentationDragIndicator(.hidden)
                            }
                        }
                        
                        if isShowingStopwatch {
                            Text("\(String(format: "%02d", stopwatchHour)):\(String(format: "%02d", stopwatchMinute)):\(String(format: "%02d", stopwatchSecond))")
                                .onReceive(timer, perform: { _ in
                                    locationDataManager.totalTimeInS += 1
                                    
                                    stopwatchSecond += 1
                                    if stopwatchSecond == 60 {
                                        stopwatchMinute += 1
                                        stopwatchSecond = 0
                                    }
                                    if stopwatchMinute == 60 {
                                        stopwatchHour += 1
                                        stopwatchMinute = 0
                                    }
                                })
                        }
                    }
                    
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
        }
    }
}

#Preview {
    ContentView()
        .environment(LocationDataManager())
}
