//
//  UpdateProfileView.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 23/09/23.
//

import SwiftUI
import PhotosUI

struct UpdateProfileView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    @State private var prefix: String = "Mr"
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var suffix: String = ""
    @State private var mobile: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    let prefixOptions = ["Dr", "Mr", "Mrs", "Miss", "Prof"]
    
    private func initData() {
//        Task {
//            model.populateUserProfile
//        }
        prefix = model.userProfile?.prefix ?? "Mr"
        firstname = model.userProfile?.firstname ?? "No Firstname"
        lastname = model.userProfile?.lastname ?? "No Lastname"
        suffix = model.userProfile?.suffix ?? "No Suffix"
        mobile = model.userProfile?.mobile ?? "No mobile"
    }
    
    private func fetchUserProfile() async {
        do {
            try await model.populateUserProfile()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateUserProfile() async {
        
        let userUpdateDTO = UserUpdateDTO(prefix: prefix, firstname: firstname, lastname: lastname, suffix: suffix, mobile: mobile)
        
        do {
            try await model.updateUserProfile(userUpdateDTO)
           
        } catch {
            print(error.localizedDescription)
        }
        
    }
    var body: some View {
        Form {
            Picker("Select Salutation", selection: $prefix) {
                ForEach(prefixOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
            HStack {
                Text("First Name:")
                TextField("Enter First Name", text: $firstname)
            }
            HStack {
                Text("Last Name:")
                TextField("Enter Last Name", text: $lastname)
            }
            HStack {
                Text("Qualifications:")
                TextField("Enter Degrees", text: $suffix)
            }
            HStack {
                Text("Mobile:")
                TextField("Enter Mobile Number", text: $mobile)
            }
            HStack {
                Text("Select Profile Photo")
                Spacer()
                PhotosPicker(selection: $selectedPhoto) {
                    Image(systemName: "photo")
                }
            }
            Button("Save"){
                Task {
                    await updateUserProfile()
                }
            }
        }
        Text(model.userProfile?.firstname ?? "No firstname")
        .task(id: selectedPhoto) {
            image = try? await selectedPhoto?.loadTransferable(type: Image.self)
        }
        .task {
            await fetchUserProfile()
            initData()
        }
        .navigationTitle("Update Profile")
//        .onAppear(perform: initData)
    }
}

#Preview {
    NavigationStack {
        UpdateProfileView()
            .environmentObject(AppModel())
            .environmentObject(AppState())
    }
}
