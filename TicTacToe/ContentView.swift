//
//  ContentView.swift
//  TicTacToe
//
//  Created by Ngô Nam on 16/08/2023.
//

import SwiftUI

extension Color {
    static let background = Color(UIColor(named: "colorBackground")!)
    
    static let colorui = Color(UIColor(named: "Color1")!)
}

struct ContentView: View {
    
    @State private var moves: [String] = Array(repeating: "", count: 9)
    @State private var playGame = false
    @State private var player = true
    @State private var gameOver = false
    @State private var msg = "" //message
    
    var body: some View {
        ZStack {
            (LinearGradient(gradient: Gradient(colors: [.background, .colorui, .background]), startPoint: .leading, endPoint: .trailing))
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(width: 100, height: 100, alignment: .center)
                
                Image("name")
                    .resizable()
                    .frame(width: 350, height: 100, alignment: .center)
                
                if !playGame {
                    Button {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            playGame = true
                        }
                    } label: {
                        Text("Play Game")
                            .font(.title.bold())
                            .padding()
                            .foregroundColor(.yellow)
                            .background(.white)
                            .cornerRadius(20)
                    }
                    
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 380, height: 380, alignment: .center)
                        (LinearGradient(gradient: Gradient(colors: [.background, .colorui, .background]), startPoint: .leading, endPoint: .trailing))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(LinearGradient(gradient: Gradient(colors: [.colorui, .background, .colorui]), startPoint: .leading, endPoint: .trailing), lineWidth: 2)
                                    .frame(width: 380, height: 380)
                            )
                        
                        
                        VStack {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15) {
                                ForEach(0..<9, id: \.self) { index in
                                    ZStack {
                                        Color.yellow.opacity(1)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(.white, lineWidth: 4)
                                            )
                                            .shadow(color: .black, radius: 10)
                                        
                                        Color.background
                                            .opacity(moves[index] == "" ? 1 : 0)
                                        
                                        if moves[index] == "X" {
                                            Image("cross")
                                                .resizable()
                                                .opacity(moves[index] != "" ? 1 : 0)
                                        }
                                        
                                        if moves[index] == "O" {
                                            Image("circle")
                                                .resizable()
                                                .opacity(moves[index] != "" ? 1 : 0)
                                        }
                                    }
                                    .frame(width: 110, height: 110, alignment: .center)
                                    .cornerRadius(25)
                                    .rotation3DEffect(Angle(degrees: moves[index] != "" ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0), anchor: .center, anchorZ: 0.0, perspective: 1.0)
                                    .onTapGesture {
                                        withAnimation(Animation.easeIn(duration: 0.5)) {
                                            if moves[index] == "" {
                                                moves[index] = player ? "X" : "O"
                                            }
                                            
                                            player.toggle()
                                        }
                                    }
                                }
                            }
                            .padding(30)
                        }
                        
                        .onChange(of: moves) { _ in
                            checkWinner()
                        }
                        
                        .alert(isPresented: $gameOver) {
                            Alert(
                                title: Text("Winner"),
                                message: Text(msg),
                                dismissButton: .destructive(Text("OK"), action: {
                                    withAnimation(Animation.easeIn(duration: 0.5)) {
                                        moves.removeAll()
                                        moves = Array(repeating: "", count: 9)
                                        player = true
                                        playGame = false
                                    }
                                })
                            )
                        }
                    }
                }
                
                Text("Ngo Nam")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
            }
        }
    }
    
    func checkMoves(player: String) -> Bool {
        //vertical check
        for i in 0...2 {
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player {
                return true
            }
        }
        
        //horizontal check
        for i in stride(from: 0, to: 9, by: 3) {
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player {
                return true
            }
        }
        
        //diagonal check
        if moves[0] == player && moves[4] == player && moves[8] == player {
            return true
        }
        
        if moves[2] == player && moves[4] == player && moves[6] == player {
            return true
        }
        
        return false
    }
    
    func checkWinner() {
        if checkMoves(player: "X") {
            msg = "X is the winner!"
            gameOver.toggle()
        }
        else if checkMoves(player: "O") {
            msg = "O is the winner!"
            gameOver.toggle()
        }
        else {
            let status = moves.contains { (value) -> Bool in
                return value == ""
            }
            
            if !status {
                msg = "Game over! No one win this match!"
                gameOver.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
