//
//  SaveRun.swift
//  MapRun
//
//  Created by Igor L on 15/09/2024.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

struct SaveRunView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    @Environment(LocationDataManager.self) var locationDataManager
    @Environment(TimeManager.self) var timeManager
    
    @State var viewModel: ViewModel
    
    init(run: Run, locations: [CLLocation]) {
        self.viewModel = ViewModel(run: run, locations: locations)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Title", text: $viewModel.runTitle)
                Image(systemName: "pencil")
            }
            .font(.title)

            Text(timeManager.formattedUnits)
                .font(.title3)
            
            HStack {
                Text(String(format: "%.2f km", viewModel.run.distance))
                Text(String(format: "%d:%02d /km", viewModel.run.pace?[0] ?? 0, viewModel.run.pace?[1] ?? 0))
                Text(String(format: "%.2f m/s", viewModel.run.speed))
                Spacer()
                Button {
                    viewModel.isShowingPolyline.toggle()
                    print("isShowingPolyline: \(viewModel.isShowingPolyline)")
                } label: {
                    Image(systemName: viewModel.isShowingPolyline ? "flag.fill" : "flag")
                }
            }
            .font(.title3)
            
            Map {
                if viewModel.isShowingPolyline {
                    locationDataManager.drawRoute(locations: viewModel.locations)
                        .stroke(.red, lineWidth: 5)
                }
            }
            
            Button("Save") {
                viewModel.saveRun(run: viewModel.run, locations: viewModel.locations)
                dismiss()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title)
        }
        .onAppear {
            timeManager.totalTimeInS = viewModel.run.time
        }
        .padding()
    }
}

#Preview {
    let context = PersistenceManager.preview.container.viewContext
    let run = PersistenceManager.getMockRun(context: context)
    PersistenceManager.createLocationPoints(run: run, context: context)
    let locations = PersistenceManager.createMockLocations()

    return SaveRunView(run: run, locations: locations)
        .environment(LocationDataManager())
        .environment(TimeManager())
        .environment(\.managedObjectContext, context)
}
