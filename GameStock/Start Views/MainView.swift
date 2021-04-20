//
//  MainView.swift
//  GameStock
//
//  Created by CS3714 on 4/20/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
//            ToDoView()
//                .tabItem {
//                    Image(systemName: "list.bullet")
//                    Text("To Do")
//                }
//            ContactsList()
//                .tabItem {
//                    Image(systemName: "rectangle.stack.person.crop")
//                    Text("Contacts")
//                }
//            AccountsList()
//                .tabItem {
//                    Image(systemName: "key.icloud")
//                    Text("Accounts")
//                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
           
        }   // End of TabView
            .font(.headline)
            .imageScale(.medium)
            .font(Font.title.weight(.regular))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserData())
    }
}
