//
//  OnboardView.swift
//  Wants+Needs
//
//  Created by Landon West on 2/27/24.
//

import SwiftUI
import SwiftData

struct OnboardView: View {
    
    // Pull Data
    @Environment(\.modelContext) var context
    @Query var userSettingsArray: [UserSettings]

    var body: some View {
        
        VStack {
            Text("Welcome!")
                .font(.system(size: 50))
                .fontWeight(.heavy)
                .padding(.top, 25)
            
            HStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 50, height: 45)
                    .foregroundStyle(.red)
                    .padding(.trailing, 25)
                
                VStack {
                    HStack {
                        Text("Log your Wants...")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text("More Shoes? Fancy Car? Simply add it.")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                        Spacer()
                    }
                }
            }
            
            HStack {
                Image(systemName: "brain.fill")
                    .resizable()
                    .frame(width: 50, height: 40)
                    .foregroundStyle(Color(hex: "ee82ee") ?? .red)
                    .padding(.trailing, 25)
                
                VStack {
                    HStack {
                        Text("...and your Needs")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text("Clothes? Batteries? Add those too.")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                        Spacer()
                    }
                }
            }
            
            HStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .frame(width: 50, height: 40)
                    .foregroundStyle(.white)
                    .padding(.trailing, 25)
                
                VStack {
                    HStack {
                        Text("Attach any image")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    HStack {
                        Text("From Photos App or even Screenshots.")
                            .font(.system(size: 20))
                            .fontWeight(.light)
                        Spacer()
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                userSettingsArray.first?.onboardUser = false
                }
                }) {
                    Text("Close")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 20))
                        .padding(15)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .systemGray2), lineWidth: 2)
                    )
                }
                .background(Color(uiColor: .systemGray5)) // If you have this
                .cornerRadius(15)
                .padding(25)
            
        }
        .preferredColorScheme(.dark)
        .padding(.horizontal, 50)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(17.5)
        .overlay(
            RoundedRectangle(cornerRadius: 17.5, style: .circular).stroke(Color(uiColor: .systemGray3), lineWidth: 1)
        )
        .padding(.horizontal, 15)
    }
}

#Preview {
    //OnboardView()
    EmptyView()
}
