//
//  DiningHallView.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI
import CoreLocation

struct DiningHallView: View {
    @Environment(DiningHallViewModel.self) private var viewModel
    let diningHall: DiningHall
    
    @State private var showCollectionError = false
    @State private var errorMessage = ""
    @State private var isCheckingLocation = false
    
    private var isNearby: Bool {
        viewModel.isUserNearby(diningHall: diningHall)
    }
    
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
                    if isCheckingLocation {
                        ProgressView()
                            .padding(.vertical, 4)
                    } else {
                        Text(isNearby ? "Within 50 meters" : "Not nearby")
                            .foregroundColor(isNearby ? .green : .red)
                    }
                }
            }
            .padding()
            
            // Collection button
            Button(action: attemptCollection) {
                if isCheckingLocation {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Collect This Location")
                }
            }
            .padding()
            .background(
                diningHall.isCollected || !isNearby ?
                Color.gray : Color.blue
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(diningHall.isCollected || !isNearby || isCheckingLocation)
            
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
            checkLocation()
        }
        .onChange(of: viewModel.currentLocation) { _ in
            checkLocation()
        }
        .onChange(of: viewModel.authorizationStatus) { status in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                viewModel.startLocationUpdates()
            }
        }
    }
    
    private func checkLocation() {
        guard !diningHall.isCollected else { return }
        
        isCheckingLocation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isCheckingLocation = false
        }
    }
    
    private func attemptCollection() {
        if diningHall.isCollected {
            errorMessage = "You've already collected this dining hall!"
            showCollectionError = true
        } else if !isNearby {
            errorMessage = "You need to be within 50 meters to collect this dining hall!"
            showCollectionError = true
        } else {
            viewModel.collectDiningHall(diningHall: diningHall)
        }
    }
}
