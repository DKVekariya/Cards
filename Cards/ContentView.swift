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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user.name ?? "")
                .font(.headline)
                .fontWeight(.bold)
            Text(user.email ?? "")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color.gray)
            Text(user.city ?? "")
                .font(.subheadline)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: UserInfo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.name, ascending: true)]) var users: FetchedResults<UserInfo>
    @State private var isShowAddUser = false
    
    @State var tokens: Set<AnyCancellable> = []
    
    var body: some View {
        NavigationView {
            List(users) { (user:UserInfo) in
                UserCellView(user: user)
                    .onTapGesture {
                        
                    }
                    .onLongPressGesture {
                    delete(user: user)
                }
            }
            .listStyle(GroupedListStyle())
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
            Api().getUsers().sink { (com) in
                print(com)
            } receiveValue: { (users) in
                self.saveUserToCoreData(users)
            }.store(in: &tokens)

        }
    }
    
    private func saveUserToCoreData(_ users:[User]) {
        for user in users {
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
