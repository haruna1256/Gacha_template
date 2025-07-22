//
//  gachaApp.swift
//  gacha
//
//  Created by 川岸遥奈 on 2025/07/21.
//

import SwiftUI

@main
struct GachaApp: App {
    var body: some Scene {
        WindowGroup {
            GachaPreviewView()
        }
    }
}

struct GachaPreviewView: View {
    @State private var totalCoin = 1000
    @State private var showingConfirmation = false
    @State private var buttonOpacity: Double = 1.0
    @State private var rotation: Double = 0
    @State private var offset: CGFloat = 75
    @State private var isDimmed = false
    @State private var whiteout = false
    @State private var gachaActive = false
    @State private var discharge: CGFloat = -200
    @State private var whiteDivision: CGFloat = 4
    @State private var blueDivision: CGFloat = -4
    @State private var whiteOpened: CGFloat = 0
    @State private var blueOpened: CGFloat = 0
    @State private var open: CGFloat = 0
    @State private var undo: CGFloat = 1
    @State private var characterShown = false
    @State private var selectedCharacter = "スライム"
    
    let characters = ["スライム", "コリパ", "Sキング", "隊員", "たいちょ", "くまさん", "ぐまさん", "囚人", "看守"]
    
    var body: some View {
        ZStack {
            Color.black.opacity(isDimmed ? 0.3 : 0)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("所持コイン: \(totalCoin)")
                    .font(.headline)
                Text("新しいキャラを手に入れよう！")
                    .font(.title2)
                    .bold()
                
                ZStack {
                    Image("gachagacha")
                        .resizable()
                        .frame(width: 250, height: 450)
                    Image("BlueCapsule")
                        .offset(x: 0, y: offset)
                    Image("gachaFlame")
                        .offset(x: 0, y: 120)
                    Image("Handle")
                        .resizable()
                        .frame(width: 50, height: 60)
                        .rotationEffect(.degrees(rotation))
                        .offset(x: -2, y: 88)
                }
                
                Button("ガチャを引く") {
                    startGachaAnimation()
                }
                .frame(width: 150, height: 55)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(buttonOpacity)
                .disabled(totalCoin < 1000 || buttonOpacity == 0.0)
            }
            .offset(y: 70)
            
            if gachaActive {
                VStack {
                    Image("charaGet")
                        .offset(y: -110)
                    
                    HStack {
                        Image("WhiteHalfCapsule")
                            .resizable()
                            .frame(width: 50, height: 100)
                            .offset(x: whiteDivision, y: discharge)
                            .rotationEffect(.degrees(whiteOpened))
                        Image("BlueHalfCapsule")
                            .resizable()
                            .frame(width: 50, height: 100)
                            .offset(x: blueDivision, y: discharge)
                            .rotationEffect(.degrees(blueOpened))
                    }
                    .onAppear {
                        withAnimation {
                            discharge = 150
                            whiteDivision = 70
                            blueDivision = -70
                            whiteOpened = 45
                            blueOpened = -45
                        }
                    }
                }
                .offset(y: open)
                .onAppear {
                    withAnimation {
                        open = 20
                    }
                }
            }
            
            if characterShown {
                Image(selectedCharacter)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .offset(y: 120)
            }
            
            if whiteout {
                Color.white.opacity(undo)
                    .ignoresSafeArea()
                    .zIndex(100)
            }
        }
    }
    
    func startGachaAnimation() {
        guard totalCoin >= 1000 else { return }
        totalCoin -= 1000
        
        selectedCharacter = characters.randomElement() ?? "スライム"
        buttonOpacity = 0.0
        
        withAnimation(.linear(duration: 2.0)) {
            rotation += 720
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                offset = 170
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation {
                isDimmed = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                gachaActive = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation {
                whiteDivision = -65
                blueDivision = 65
                whiteOpened = 45
                blueOpened = -45
                open = -200
                whiteout = true
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            characterShown = true
            withAnimation(.easeInOut(duration: 2.0)) {
                undo = 0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            // 状態リセット
            offset = 75
            rotation = 0
            buttonOpacity = 1.0
            isDimmed = false
            gachaActive = false
            discharge = -200
            whiteDivision = 4
            blueDivision = -4
            whiteOpened = 0
            blueOpened = 0
            open = 0
            undo = 1
            characterShown = false
            whiteout = false
        }
    }
}

struct GachaPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        GachaPreviewView()
    }
}
