//
//  AddView.swift
//  Cards
//
//  Created by Divyesh Vekariya on 06/04/21.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isShow:Bool
    
    @State private var name = ""
    @State private var email = ""
    @State private var city = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var isAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter name", text: $name)
                        .disableAutocorrection(true)
                    TextField("Enter email", text: $email)
                        .disableAutocorrection(true)
                    TextField("Enter city", text: $city)
                        .disableAutocorrection(true)
                    TextField("Enter usernsme", text: $username)
                        .disableAutocorrection(true)
                    TextField("Enter phone number", text: $phone)
                        .disableAutocorrection(true)
                }
                .alert(isPresented: $isAlert) { () -> Alert in
                    Alert(title: Text("Alert"), message: Text("No text field should be empty"), dismissButton: .default(Text("Ok")))
                }
            }
            .navigationBarItems(leading: leftButton, trailing: rightButton)
        }
    }
    
    var leftButton: some View {
        Button("Back") {
            isShow.toggle()
        }
    }
    
    var rightButton: some View {
        Button("Add") {
            saveUser()
            isShow.toggle()
        }
    }
    
    func saveUser() {
        if self.name == "" ||
            self.email == "" ||
            self.city == "" ||
            self.username == "" ||
            self.phone == "" {
            self.isAlert = true
            return
        }
        let userInfo = UserInfo(context: self.context)
        userInfo.name = self.name
        userInfo.email = self.email
        userInfo.city = self.city
        userInfo.username = self.username
        userInfo.phone = self.phone
        
        do {
            try self.context.save()
        } catch {
            print("whoops \(error.localizedDescription)")
        }
    }
    
}



struct AddView_Previews: PreviewProvider {
    @State static var isShow = false
    
    static var previews: some View {
        AddView(isShow: $isShow)
    }
}
