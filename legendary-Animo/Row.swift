//
//  Row.swift
//  legendary-Animo
//
//  Created by Vishal Paliwal on 23/08/23.
//

import Foundation
import SwiftUI

struct RowView: View, Hashable {
    var icon: String
    var title: String
    var desc: String

    var body: some View {
        ZStack(alignment: .center) {

            HStack {
                Text(icon)
                    .font(.system(size: 36)).bold()
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                Spacer()
            }

            VStack (alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.title2)
                    Spacer()
                }

                Text(desc)
                    .font(.callout)
                    .fontWeight(.light)
            }
            .padding(.trailing, 16)
            .padding(.leading, 54)
            
            HStack {
               Spacer()
                Image(systemName: "chevron.right")
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(icon: "😘", title: "Project name 1", desc: "This project create ")
            .preferredColorScheme(.dark)
    }
}
