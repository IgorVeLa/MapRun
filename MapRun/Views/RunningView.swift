//
//  RunningView.swift
//  MapRun
//
//  Created by Igor L on 24/10/2024.
//


import SwiftUI
import MapKit
import CoreLocation

struct RunningView: View {
    @Environment(LocationDataManager.self) var locationDataManager
    @Environment(\.managedObjectContext) var context
    @Environment(\.scenePhase) var scenePhase
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $viewModel.position) {
                    // shows the user location when zoomed out
                    UserAnnotation()
    
                    locationDataManager.drawRouteFromCLLocation(locations: locationDataManager.locations)
                        .stroke(.red, lineWidth: 5)
                }
                .mapStyle(.standard(elevation: .realistic))
                .mapControls {
                    MapUserLocationButton()
                }
                
                VStack {
                    // push to bottom of screen
                    Spacer()
                    RunningPlayView()
                        .padding(4)
                        .background(
                            GeometryReader { geometry in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .opacity(0.55)
                            }
                        )
                }
            }
            .overlay {
                if locationDataManager.locationServicesAvailability == false {
                    ContentUnavailableView("Location Services are disabled", systemImage: "location.slash", description: Text("Ensure they are enabled in settings. \n Settings > Privacy > Location Services > MapRun > Always"))
                        .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.7))
                            )
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    
    return RunningView()
        .environment(\.managedObjectContext, context)
        .environment(LocationDataManager())
        .environment(TimeManager())
}

