//
//  ContentView.swift
//  Cards
//
//  Created by Divyesh Vekariya on 04/04/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: UserInfo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.name, ascending: true)]) var users: FetchedResults<UserInfo>
    @State private var isShowAddUser = false
    
    @State var usersCard:[User] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(usersCard) { user in
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(user.email)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray)
                        Text(user.city)
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(Color.gray)
                    }
                }
                .onDelete(perform: deleteUser)
            }
            //.listStyle(GroupedListStyle())
            .navigationBarTitle("User")
            .navigationBarItems(leading: EditButton(),
                                trailing: Button("Add") {
                                    self.isShowAddUser.toggle()
                                })
            .sheet(isPresented: $isShowAddUser) {
                AddView(isShow: $isShowAddUser).environment(\.managedObjectContext,
                                      self.context)
            }
        }
        
        .onAppear {
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            Api().getUsers { (retrivedUsers ) in
                usersCard.append(contentsOf: retrivedUsers)
                saveUserToCoreData()
                
                
            }
        }
        
    }
    private func saveUserToCoreData() {
        for user in usersCard {
            let newUser = UserInfo(context: self.context)
            newUser.name = user.name
            newUser.email = user.email
            newUser.city = user.city
            do {
                try self.context.save()
            } catch {
                print("user not saved \(error.localizedDescription)")
            }
            
        }
    }
    private func deleteUser(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let user = users[index]
                context.delete(user)
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
