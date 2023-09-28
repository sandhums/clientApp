//
//  UpdateAddressView.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 27/09/23.
//

import SwiftUI

struct UpdateAddressView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    
    @State private var addressline1: String = ""
    @State private var addressline2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var pincode: String = ""
    @State private var country: String = ""
    
    private func fetchUserAddress() async {
        do {
            try await model.getUserAddress()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func initData() {
        addressline1 = model.userAddress?.addressline1 ?? ""
        addressline2 = model.userAddress?.addressline2 ?? ""
        city = model.userAddress?.city ?? ""
        state = model.userAddress?.state ?? ""
        pincode = model.userAddress?.pincode ?? ""
        country = model.userAddress?.country ?? ""
    }
    
    private func saveAddress() async {
        let userAddressDTO = UserAddressDTO(addressline1: addressline1, addressline2: addressline2, city: city, state: state, pincode: pincode, country: country)
        Task{
            try await model.saveUserAddress(userAddressDTO)
            print("saved address")
        }
    }
    private func updateAddress() async {
        let userAddressDTO = UserAddressDTO(addressline1: addressline1, addressline2: addressline2, city: city, state: state, pincode: pincode, country: country)
        Task{
            try await model.updateUserAddress(userAddressDTO)
            print("updated address")
        }
    }
    var body: some View {
        Form {
            HStack {
                Text("Address Line1:")
                TextField("Enter Flat, Building", text: $addressline1)
            }
            HStack {
                Text("Address Line2:")
                TextField("Enter Street, Sector", text: $addressline2)
            }
            HStack {
                Text("City:")
                TextField("Enter City", text: $city)
            }
            HStack {
                Text("State:")
                TextField("Enter State", text: $state)
            }
            HStack {
                Text("Pincode:")
                TextField("Enter Pincode", text: $pincode)
            }
            HStack {
                Text("Country:")
                TextField("Enter Country", text: $country)
            }
            HStack{
                Button("Save"){
                    Task {
                        await saveAddress()
                    }
                }.buttonStyle(.borderless)
                Spacer()
                Button("Update"){
                    Task {
                        await updateAddress()
                    }
                }.buttonStyle(.borderless)

            }
        }
        .task {
            await fetchUserAddress()
            initData()
        }
        .navigationTitle("Update Address")
    }
}

#Preview {
    NavigationStack {
    UpdateAddressView()
        .environmentObject(AppModel())
        .environmentObject(AppState())
}
}
