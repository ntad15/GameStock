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
            NewsList()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            SearchCompany()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search Stocks")
                }
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
