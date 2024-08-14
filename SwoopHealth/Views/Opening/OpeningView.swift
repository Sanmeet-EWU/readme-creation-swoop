//
//  OpeningView.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 7/10/24.
//

import SwiftUI

struct OpeningView: View {
    
    @State var openSignIn: Bool = false
    @State var openInfo: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundBlue.ignoresSafeArea()
            
            
            VStack(alignment: .leading, spacing: 18) {
                logo
                    .padding(.horizontal)
                Spacer()
                images
                    .padding(.horizontal, 8)
                Spacer()
                Group {
                    details
                    signInButton
                    signUpButton
                }
                .padding(.horizontal)
            }
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    NavigationView {
        OpeningView()
    }
}

extension OpeningView {
    private var images: some View {
        VStack(spacing: 10) {
            
            HStack(spacing: 10) {
                
                ZStack(alignment: .top) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .opacity(0.05)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white)
                            .opacity(0.2)
                    }
                    VStack {
                        HStack {
                            Text("Heart Rate")
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        HStack {
                            ForEach(0..<9) { _ in
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 5)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, CGFloat.random(in: 0...50))
                            }
                        }
                        .foregroundStyle(.white)
                        .opacity(0.85)
                    }
                    .padding(12)
                }
                
                Image("guy_mockup")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(height: 120)
            
            HStack(spacing: 10) {
                Image("girl_mockup")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                ZStack(alignment: .top) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.white)
                            .opacity(0.05)
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.white)
                            .opacity(0.2)
                    }
                    
                    VStack {
                        HStack {
                            Text("Glucose")
                                .font(.system(size: 13))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        
                        ZStack {
                            Circle()
                                .trim(from: 0, to: 1.0)
                                .stroke(
                                    Color.white.opacity(0.8),
                                    style: StrokeStyle(
                                        lineWidth: 4,
                                        lineCap: .round
                                    )
                                )
                            
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .stroke(
                                    Color(red: 45/255, green: 98/255, blue: 87/255),
                                    style: StrokeStyle(
                                        lineWidth: 4,
                                        lineCap: .round
                                    )
                                )
                            
                            Circle()
                                .trim(from: 0, to: 0.5)
                                .stroke(
                                    Color(red: 182/255, green: 97/255, blue: 170/255),
                                    style: StrokeStyle(
                                        lineWidth: 4,
                                        lineCap: .round
                                    )
                                )
                            
                            Circle()
                                .trim(from: 0, to: 0.25)
                                .stroke(
                                    Color(red: 209/255, green: 241/255, blue: 83/255),
                                    style: StrokeStyle(
                                        lineWidth: 4,
                                        lineCap: .round
                                    )
                                )
                            
                            VStack(spacing: 0) {
                                Text("74")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 21, weight: .light))
                                Text("mmol/L")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 9, weight: .light))
                            }
                            .rotationEffect(.degrees(90))
                        }
                        .rotationEffect(.degrees(-90))
                    }
                    .padding(12)
                }
            }
            .frame(height: 120)
        }
    }
    
    private var logo: some View {
        HStack(spacing: 10) {
            Image("swoop_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 32)
            
            Text("Swoop")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
        }
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Simplifying Medical\nManagement")
                .font(.system(size: 25, weight: .semibold))
            Text("Swoop is an all-in-one platform for\nmanaging patient health and wellness.")
                .font(.system(size: 16, weight: .light))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .lineSpacing(4)
        .padding(.bottom)
    }
    
    private var signInButton: some View {
        Button {
            openSignIn.toggle()
        } label: {
            Text("Sign In")
        }
        .buttonStyle(CapsuleButtonStyle(
            textColor: .white,
            backgroundColor: Color.theme.darkBlue)
        )
        .sheet(isPresented: $openSignIn) {
            SignInSheet()
        }
    }
    
    private var signUpButton: some View {
        HStack {
            Spacer(minLength: 0)
            
            Button {
                openInfo.toggle()
            } label: {
                HStack(spacing: 5) {
                    Text("Don't have an account?")
                        .fontWeight(.light)
                    Text("**Tap Here**")
                }
                .foregroundStyle(.white)
                .font(.system(size: 14))
            }
            .sheet(isPresented: $openInfo) {
                InfoSheet()
            }
            
            Spacer(minLength: 0)
        }
    }
}
