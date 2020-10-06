//
//  AddView.swift
//  ReviewApp
//
//  Created by Y on 2020/10/06.
//

import SwiftUI

struct AddView: View {
    @State var showActionSheet = false
    
    var actionSheet: ActionSheet {
        ActionSheet(title: Text("Action Sheet's title"),
                    message: Text("This is a message"),
                    buttons: [
                        .default(Text("This is a default button"), action: {print("Default button tapped")}),
                        .destructive(Text("This is a destructive button"), action: {print("Destructive button tapped")}),
                        .cancel()
                    ])
    }
    
    var body: some View {
        VStack {
            Button("Show Action Sheet") {
                self.showActionSheet.toggle()
            }
        }
        .actionSheet(isPresented: $showActionSheet, content: { self.actionSheet })
    }
}
