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
    @Environment(\.managedObjectContext) var context
    @Environment(\.scenePhase) var scenePhase
    
    @State var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State var isRunning = false
    @State var isShowingPolyLine = false
    @State var isShowingStopwatch = false
    @State var isShowingSaveSheet = false
    @State var isShowingHistorySheet = false
    
    @State var stopwatchSecond = 0
    @State var stopwatchMinute = 0
    @State var stopwatchHour = 0
    @State var dateExiting: Date?
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
                                currentRun = Run(context: context)
                                currentRun?.title = ""
                                currentRun?.time = locationDataManager.totalTimeInS
                                currentRun?.distance = locationDataManager.currentDist
                                currentRun?.speed = locationDataManager.currentSpeed
                                currentRun?.pace = locationDataManager.currentPace
                                currentRun?.dateAdded = Date.now
                                
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
                        .sheet(isPresented: $isShowingSaveSheet, onDismiss: resetData) {
                            if let currentRun = currentRun {
                                SaveRun(run: currentRun, locations: locationDataManager.locations)
                                    .presentationDetents([.medium, .large])
                                    .presentationDragIndicator(.hidden)
                            }
                        }

                        
                        if isShowingStopwatch {
                            Text("\(String(format: "%02d", stopwatchHour)):\(String(format: "%02d", stopwatchMinute)):\(String(format: "%02d", stopwatchSecond))")
                                .onReceive(timer, perform: { _ in
                                    locationDataManager.totalTimeInS += 1
                                    
                                    stopwatchHour = Int(locationDataManager.totalTimeInS / 3600)
                                    stopwatchMinute = Int(locationDataManager.totalTimeInS / 60) % 60
                                    stopwatchSecond = Int(locationDataManager.totalTimeInS) % 60
                                })
                                // update stopwatch if user is in background by calculating difference
                                .onChange(of: scenePhase) { oldPhase, newPhase in
                                    if newPhase == .background {
                                        print("background")
                                        dateExiting = Date()
                                    } else if newPhase == .active {
                                        var currentCalendar = Calendar.current
                                        
                                        if let dateExiting {
                                            var difference = currentCalendar.dateComponents([.second], from: dateExiting, to: Date())
                                            
                                            locationDataManager.totalTimeInS += Double(difference.second!)
                                        }
                                    }
                                }
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
                    
                    Button {
                        isShowingHistorySheet.toggle()
                    } label: {
                        Image(systemName: "list.bullet.clipboard.fill")
                    }
                    .sheet(isPresented: $isShowingHistorySheet) {
                        HistoryView()
                    }
                }
            }
        }
    }
    
    func resetData() {
        locationDataManager.locations = []
        locationDataManager.totalTimeInS = 0
        locationDataManager.currentPace = [0, 0]
        locationDataManager.currentSpeed = 0
        locationDataManager.currentDist = 0
        stopwatchSecond = 0
        stopwatchMinute = 0
        stopwatchHour = 0
        print("data reset")
    }
}

#Preview {
    ContentView()
        .environment(LocationDataManager())
}
