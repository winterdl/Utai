//
//  ChooseView.swift
//  Utai
//
//  Created by Toto Minai on 2021/06/12.
//

import SwiftUI

struct ChooseView: View {
    @EnvironmentObject var store: Store
    
    @Environment(\.openURL) var openURL
    
    @State private var isSettingsPresented: Bool = false
    @State private var searchResult: SearchResult?
    
    @FocusState private var chosen: Int?
    
    let pasteboard = NSPasteboard.general
    
    var shelf: some View {
        Rectangle()
            .frame(height: 84)
            .foregroundColor(.clear)
            .background(LinearGradient(
                stops: [Gradient.Stop(color: Color.white.opacity(0), location: 0),
                        Gradient.Stop(color: Color.white.opacity(0.12), location: 0.4),
                        Gradient.Stop(color: Color.white.opacity(0), location: 1)],
                startPoint: .top, endPoint: .bottom))
            .offset(y: 108)
    }
    
    var body: some View {
        if let _ = store.album {
            ZStack(alignment: .top) {
                if let _ = searchResult { shelf }
                
                VStack(spacing: lilSpacing2x) {
                    Spacer().frame(height: 12)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            Spacer().frame(width: lilSpacing2x+lilIconLength)
                            
                            // TODO: Add artists-only helper text
                            Text("\(artists)")
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            if album.artists != nil && album.title != nil
                                { Text(" – ") .fontWeight(.bold) }
                            Text("\(title)")
                                .fontWeight(.bold)
                            Text("\(yearText)")
                                .fontWeight(.bold)
                                .foregroundColor(.secondary)
                            
                            Spacer().frame(width: lilSpacing2x+lilIconLength)
                        }
                        .contextMenu {
                            Menu("Copy") {
                                if let title = album.title {
                                    Button(action: {
                                        pasteboard.declareTypes([.string], owner: nil)
                                        pasteboard.setString(title, forType: .string)
                                    }) { Text("Title") }
                                }
                                if let artists = album.artists {
                                    Button(action: {
                                        pasteboard.declareTypes([.string], owner: nil)
                                        pasteboard.setString(artists, forType: .string)
                                    }) { Text("Artist(s)") }
                                }
                                if let year = album.year {
                                    Button(action: {
                                        pasteboard.declareTypes([.string], owner: nil)
                                        pasteboard.setString("\(year)", forType: .string)
                                    }) { Text("Year") }
                                }
                                Divider()
                                Button(action: {
                                    let seperator = album.artists != nil && album.title != nil ? " – " : ""
                                    
                                    pasteboard.declareTypes([.string], owner: nil)
                                    pasteboard.setString(artists + seperator + title + yearText,
                                                         forType: .string)
                                }) { Text("All") }
                            }
                        }
                    }
                    
                    if let _ = searchResult {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: lilSpacing) {
                                Spacer().frame(width: lilSpacing+lilIconLength)
                                
                                ForEach(0..<min(6, results.count)) { index in
                                    if let thumb = results[index].coverImage {
                                        AsyncImage(url: URL(string: thumb)!) { image in
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(4)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 80, height: 80)
                                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
                                        .frame(height: 100)
                                        .focusable(true)
                                        .focused($chosen, equals: index)
                                        .onTapGesture {
                                            chosen = index
                                        }
                                    }
                                }
                                
                                Spacer().frame(width: lilSpacing+lilIconLength)
                            }
                        }
                        .padding(.vertical, -9.5)
                        .onAppear { chosen = 0 }
                        
                        HStack(spacing: lilSpacing) {
                            ButtonCus(action: { isSettingsPresented = true },
                                      label: "Settings",
                                      systemName: "gear")
                            .sheet(isPresented: $isSettingsPresented, onDismiss: {}) {
                                SettingsSheet(systemName: "gear",
                                              instruction:
                                    "Adjust global settings for picking rather album.")
                            }
                            
                            ButtonCus(action: {
                                let discogs = "https://discogs.com\(results[(chosen ?? 0)].uri)"
                                openURL(URL(string: discogs)!)
                            }, label: "View on Discogs",
                                      systemName: "smallcircle.fill.circle.fill")
                            
                            ButtonCus(action: {}, label: "Pick-It", systemName: "bag")
                        }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: lilSpacing) {
                                    Spacer().frame(width: lilSpacing2x+lilIconLength)
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("Versus")
                                            .fontWeight(.bold)
                                        Text("Format")
                                            .fontWeight(.bold)
                                            .opacity(results[(chosen ?? 0)].format != nil ? 1 : 0.3)
                                        Text("Released")
                                            .fontWeight(.bold)
                                            .opacity(results[(chosen ?? 0)].year != nil ? 1 : 0.3)
                                        
                                        Spacer()  // Keep 2 VStack aligned
                                    }
                                    .foregroundColor(.secondary)
                                    .animation(.default, value: chosen)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(chosenTitle)")
                                            .fontWeight(.bold)
                                            .contextMenu {
                                                Button(action: {
                                                    pasteboard.declareTypes([.string], owner: nil)
                                                    pasteboard.setString(chosenTitle, forType: .string)
                                                }) { Text("Copy") }
                                            }
                                        Text("\(chosenFormat)")
                                            .fontWeight(.bold)
                                            .contextMenu {
                                                Button(action: {
                                                    pasteboard.declareTypes([.string], owner: nil)
                                                    pasteboard.setString(chosenFormat, forType: .string)
                                                }) { Text("Copy") }
                                            }
                                        Text("\(chosenYear)")
                                            .fontWeight(.bold)
                                            .contextMenu {
                                                Button(action: {
                                                    pasteboard.declareTypes([.string], owner: nil)
                                                    pasteboard.setString(chosenYear, forType: .string)
                                                }) { Text("Copy") }
                                            }
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(width: lilSpacing2x+lilIconLength)
                                }
                            }
                        
                    }
                    
                    Spacer()
                }
                .frame(width: unitLength, height: unitLength)
                
                if store.page == 2 {
                    Spacer().onAppear { if store.needUpdate { search() } }
                }
            }
        }
    }
}

extension ChooseView {
    private var album: Album { store.album! }
    private var title: String { album.title ?? "" }
    private var artists: String { album.artists ?? "" }
    private var yearText: String {
        if let year = album.year { return " (\(year))" } else { return "" }
    }
    
    private var results: [SearchResult.Results] {
        searchResult!.results
    }
    
    private var chosenTitle: String {
        results[(chosen ?? 0)].title.replacingOccurrences(of: "*", with: "†")
    }
    private var chosenFormat: String {
        results[(chosen ?? 0)].format?.uniqued().joined(separator: " / ") ?? "*"
    }
    private var chosenYear: String {
        results[(chosen ?? 0)].year ?? ""
    }
    
    private func search() {
        URLSession.shared.dataTask(with: store.searchUrl!) { data, _, _ in
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    
                    searchResult = result
                }
            } catch { print(error) }
        }.resume()
        
        store.needUpdate = false
    }
}

struct SettingsSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let systemName: String
    let instruction: String
    
    var body: some View {
        Form {
            Group {
                Text(instruction)
                Divider()
            }.offset(y: 1.2)
            
            Spacer()
            
            TextField("**Debugging**", text: .constant(""))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Spacer().frame(height: lilSpacing2x)
            
            HStack {
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("**Apply**")
                }
                .controlProminence(.increased)
            }
        }.modifier(ConfigureSheet(systemName: systemName))
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
