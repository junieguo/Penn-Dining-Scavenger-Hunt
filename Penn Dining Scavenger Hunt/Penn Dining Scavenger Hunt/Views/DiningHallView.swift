//
//  DiningHallView.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI
import CoreLocation

struct DiningHallView: View {
    @Environment(DiningHallViewModel.self) private var viewModel
    let diningHall: DiningHall
    
    // Placeholder state variables
    @State private var isNearby = false
    @State private var showCollectionError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Dining hall information
            VStack {
                Text(diningHall.name)
                    .font(.title)
                    .bold()
                
                if diningHall.isCollected {
                    Text("Already Collected")
                        .foregroundColor(.green)
                        .font(.headline)
                } else {
                    Text(isNearby ? "Within 50 meters" : "Not nearby")
                        .foregroundColor(isNearby ? .green : .red)
                }
            }
            .padding()
            
            // Collection button (placeholder)
            Button(action: attemptCollection) {
                Text("Collect This Location")
                    .padding()
                    .background(diningHall.isCollected || !isNearby ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(diningHall.isCollected || !isNearby)
            
            Spacer()
        }
        .padding()
        .navigationTitle(diningHall.name)
        .alert("Collection Error", isPresented: $showCollectionError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Placeholder for location check
            checkIfNearby()
        }
    }
    
    // Placeholder function for location check
    private func checkIfNearby() {
        // In a real implementation, this would use CoreLocation for now, randomly set it to true for demonstration
        isNearby = Bool.random()
    }
    
    // Placeholder function for collection attempt
    private func attemptCollection() {
        if diningHall.isCollected {
            errorMessage = "You've already collected this dining hall!"
            showCollectionError = true
        } else if !isNearby {
            errorMessage = "You need to be within 50 meters to collect this dining hall!"
            showCollectionError = true
        } else {
            // In a real implementation, this would trigger shake/scribble detection
            viewModel.collectDiningHall(diningHall: diningHall)
        }
    }
}

#Preview {
    DiningHallView(diningHall: DiningHall(name: "1920 Commons", location: CLLocation(latitude: 39.9514, longitude: -75.1976)))
        .environment(DiningHallViewModel())
}
