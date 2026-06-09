//
//  ContentView.swift
//  ContaTempo
//
//  Created by eduhds on 01/06/26.
//

import SwiftUI
import UIKit

let primaryColor = Color(UIColor(red: 0.954, green: 0.529, blue: 0.385, alpha: 1.0))

let gradientColors: [Color] = [
    .gradientTop,
    .gradientBottom
]

struct ContentView: View {
    @State private var isRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var count = 0
    @State private var timer: Timer?
    
    private var timeString: String {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    // Top App Bar
                    VStack {
                        Text("Conta Tempo")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(primaryColor)
                    
                    // Main Content
                    VStack(spacing: 0) {
                        // Timer Display
                        VStack(spacing: 24) {
                            Text(timeString)
                                .font(.system(size: 54, weight: .thin, design: .default))
                                .monospacedDigit()
                            
                            VStack(spacing: 8) {
                                Text("Contagem")
                                    .font(.system(size: 16, weight: .bold))
                                
                                Text("\(count)")
                                    .font(.system(size: 22, weight: .bold))
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Gradient(colors: gradientColors))
                        .foregroundColor(.white)
                        
                        // Control Buttons
                        HStack(spacing: 0) {
                            // Restart Button
                            Button(action: restartButtonTapped) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .foregroundColor(
                                    !isRunning && count > 0 ? .red : .white
                                )
                            }
                            
                            Divider()
                                .frame(height: 56)
                                
                            // Play/Pause Button
                            Button(action: playPauseButtonTapped) {
                                HStack {
                                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                        .font(.system(size: 24))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .foregroundColor(
                                    isRunning ? .green : .white
                                )
                            }
                        }
                        .background(primaryColor)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear {
            timer?.invalidate()
            setIdleTimer(value: false)
        }
    }
    
    private func restartButtonTapped() {
        if isRunning {
            count += 1
            isRunning = false
        } else {
            count = 0
        }
        
        timer?.invalidate()
        elapsedTime = 0
        vibrateEffect()
        setIdleTimer(value: isRunning)
    }
    
    private func playPauseButtonTapped() {
        isRunning.toggle()
        
        if isRunning {
            startTimer()
        } else {
            count += 1
            timer?.invalidate()
        }
        
        vibrateEffect()
        setIdleTimer(value: isRunning)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime += 0.1
        }
    }
    
    private func vibrateEffect() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    private func setIdleTimer(value: Bool) {
        UIApplication.shared.isIdleTimerDisabled = value
    }
}

#Preview {
    ContentView()
}
