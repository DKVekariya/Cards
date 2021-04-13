//
//  ContentView.swift
//  Cards
//
//  Created by Divyesh Vekariya on 04/04/21.
//

import SwiftUI
import CoreData
import Combine

struct UserCellView: View {
    @State var user:UserInfo
    @Binding var expandedUser:UserInfo?
    
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .size(UIScreen.main.bounds.size)
            VStack(alignment: .leading) {
                HStack {
                    Text(user.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down").onTapGesture {
                        action()
                    }
                    .foregroundColor(.blue)
                    
                }
                Text(user.email ?? "")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(Color.gray)
                Text(user.city ?? "")
                    .font(.subheadline)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                if user == expandedUser {
                    Text(user.username ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                    Text(user.phone ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                }
                
            }
            .padding()
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: UserInfo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.name, ascending: true)])
    var users: FetchedResults<UserInfo>
    @State private var isShowAddUser = false
    @State private var isShowUserDetail = false
    @State var tokens: Set<AnyCancellable> = []
    @State private var isShowingAlert = false
    @State var expandedUser:UserInfo? = .none
    
    var body: some View {
        NavigationView {
            List(users) { (user:UserInfo) in
                getUserCell(user)
            }.navigationBarTitle("User", displayMode: .inline)
            .navigationBarItems(leading: EditButton(),
                                trailing: Button("Add") {
                                    self.isShowAddUser.toggle()
                                })
        }
        .onAppear {
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            Api().getUsers().sink { (com) in
                print(com)
            } receiveValue: { (users) in
                self.saveUserToCoreData(users)
                //                deleteAllRecords()
            }.store(in: &tokens)
            
        }
        .sheet(isPresented: $isShowAddUser) {
            AddView(isShow: $isShowAddUser).environment(\.managedObjectContext, self.context)
        }
    }
    
    func getUserDetail(_ user:UserInfo) -> some View {
        NavigationView {
            UserDetailView(users: users.map({ $0 }), startPosithion: users.firstIndex(of: user))
                .navigationBarItems(leading: Button("Cancel", action: { isShowUserDetail = false }))
                .navigationBarTitle("Details", displayMode: .inline)
        }
    }
    
    
    func getUserCell(_ user:UserInfo) -> some View {
        UserCellView(user: user, expandedUser: $expandedUser) {
            withAnimation {
                if expandedUser == user {
                    expandedUser = .none
                } else {
                    expandedUser = user
                }
                
            }
        }
        .fullScreenCover(isPresented: $isShowUserDetail) {
            getUserDetail(user)
        }
        .cornerRadius(20)
        .onTapGesture {
            isShowUserDetail.toggle()
        }
        .onLongPressGesture {
            isShowingAlert.toggle()
        }
        .alert(isPresented: $isShowingAlert, content: {
            Alert(title: Text("Are you sure ?"), message: Text("IFyou want to delete selected user then press \"Delete\", else press \"Cencle\""), primaryButton: .destructive(Text("Delete"), action: {
                delete(user: user)
            }), secondaryButton: .cancel())
        })
    }
    
    
    private func saveUserToCoreData(_ usersToSave:[Api.User]) {
        let coreUserName = users.map({$0.name})
        for user in usersToSave {
            if coreUserName.contains(user.name) {
                print("coredata allreay contain \(user.name)")
            } else {
                let newUser = UserInfo(context: self.context)
                newUser.name = user.name
                newUser.email = user.email
                newUser.city = user.city
                newUser.username = user.username
                newUser.phone = user.phone
                
                do {
                    try self.context.save()
                } catch {
                    print("user not saved \(error.localizedDescription)")
                }
            }
            
            
        }
    }
    
    func delete(user: UserInfo) {
        withAnimation { 
            context.delete(user)
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
    }
    
    private func deleteAllRecords() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
