//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

// Model for game scores
struct Score: Codable {
    var opponent: Int
    var unc: Int
}

// Model representing a basketball game
struct Game: Codable {
    var id: Int
    var date: String
    var isHomeGame: Bool
    var score: Score
    var opponent: String
    var team: String // Determines if it's a Men's or Women's game
}

struct ContentView: View {
    @State private var games: [Game] = []
    
    var body: some View {
        NavigationView {
            List(games, id: \.id) { game in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        // (a) Display whether it's a Men's or Women's game + opponent name
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)
                        
                        // (c) Display game date
                        Text(game.date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        // (d) Display game scores in bold
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.title3)
                            .bold()
                        
                        // (e) Show whether it's a home or away game
                        Text(game.isHomeGame ? "Home" : "Away")
                            .font(.caption)
                            .foregroundColor(game.isHomeGame ? .green : .red)
                    }
                }
                .padding(.vertical, 8) // Adjust spacing for a compact look
            }
            .navigationTitle("UNC Basketball") // Match professor's title
        }
        .task {
            await fetchGames()
        }
    }

    // Function to fetch game data from an API
    private func fetchGames() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Error: Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode([Game].self, from: data)
            games = decodedData
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
