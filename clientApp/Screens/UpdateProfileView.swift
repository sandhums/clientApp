//
//  UpdateProfileView.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 23/09/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct UpdateProfileView: View {
    @EnvironmentObject private var model: AppModel
    @EnvironmentObject private var appState: AppState
    
    @State private var prefix: String = "Mr"
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var suffix: String = ""
    @State private var mobile: String = ""
    @State private var profilepicture: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
    @State var data: Data?
    let prefixOptions = ["Dr", "Mr", "Mrs", "Miss", "Prof"]
    let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")
    
    private func initData() {
        prefix = model.userProfile?.prefix ?? "Mr"
        firstname = model.userProfile?.firstname ?? "No Firstname"
        lastname = model.userProfile?.lastname ?? "No Lastname"
        suffix = model.userProfile?.suffix ?? "No Suffix"
        mobile = model.userProfile?.mobile ?? "No mobile"
        profilepicture = model.userProfile?.profilepicture ?? ""
    }
    
    private func fetchUserProfile() async {
        do {
            try await model.populateUserProfile()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func updateUserProfile() async {
        if data != nil {
            storageReference.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else { return }
                
                storageReference.downloadURL { url, err in
                    if let err = err {
                        print("failed to get url\(err)")
                        return
                    }
                    if url != nil {
                        profilepicture = url?.absoluteString ?? ""
                        print("url is \(url?.absoluteString ?? "")")
                        let userUpdateDTO = UserUpdateDTO(prefix: prefix, firstname: firstname, lastname: lastname, suffix: suffix, mobile: mobile, profilepicture: profilepicture)
                        Task{
                            try await model.updateUserProfile(userUpdateDTO)
                            print("saved new photo")
                        }
                    }
                }
            }
                
        } else {
            let userUpdateDTO = UserUpdateDTO(prefix: prefix, firstname: firstname, lastname: lastname, suffix: suffix, mobile: mobile, profilepicture: profilepicture)
            Task{
                try await model.updateUserProfile(userUpdateDTO)
                print("saved old photo")
            }
        }
        
    }
    
    var body: some View {
        VStack {
        if let image {
            image
                .resizable()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
        } else {
            AsyncImage(url: URL(string: profilepicture)){ image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
        }
            HStack {
                Text("Select Profile Photo")
//                Spacer()
                PhotosPicker(selection: $selectedPhoto) {
                    Image(systemName: "photo")
                }
            }
            .padding()
    }
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
            HStack{
                Button("Save"){
                    Task {
                        await updateUserProfile()
                    }
                }.buttonStyle(.borderless)
                Spacer()
                Button("Edit Address"){
                    appState.routes.append(.address)
                }.buttonStyle(.borderless)
            }
        }
        
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data){
                    let imageResized = uiImage.aspectFittedToHeight(100) //compressImage(image: uiImage)
                    image = Image(uiImage: imageResized)
                    self.data = imageResized.jpegData(compressionQuality: 0.7)
                    return
                }
            }
        }
        .task {
            await fetchUserProfile()
            initData()
        }
        .navigationTitle("Update Profile")
        
    }
}

#Preview {
    NavigationStack {
        UpdateProfileView()
            .environmentObject(AppModel())
            .environmentObject(AppState())
    }
}
