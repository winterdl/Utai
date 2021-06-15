//
//  MatchPanel.swift
//  Utai
//
//  Created by Toto Minai on 2021/06/13.
//

import SwiftUI

struct MatchPanel: View {
    @EnvironmentObject var store: Store
    @State private var scrolled: CGFloat = 0
    
    var body: some View {
        ZStack {
            if !store.artworkMode {
                GeometryReader { outter in
                    ScrollView(.vertical) {
                        ZStack(alignment: .top) {
                            GeometryReader { inner in
                                Text("")
                                    .preference(key: ScrolledPreferenceKey.self,
                                                value: [delta(outter: outter, inner: inner)])
                            }
                            
                            VStack(alignment: .leading, spacing: lilSpacing2x) {
                                HStack(spacing: 0) {
                                    Text(store.page < 3 ? "Tracklist" : "Mismatched")
                                        .fontWeight(.bold)
                                    
                                    Text(" (\(tracks.count) Track\(tracks.count == 1 ? "" : "s"))")
                                        .fontWeight(.bold)
                                        .foregroundColor(.secondary)
                                }
                                    
                                VStack(spacing: 8) {
                                    ForEach(tracksSortedByNo) { track in
                                        HStack(spacing: 0) {
                                            GroupBox {
                                                HStack(spacing: 8) {
                                                    Text("\(track.trackNoText)")
                                                        .fontWeight(.bold)
                                                        .monospacedDigit()
                                                        .foregroundColor(.secondary)
                                                        .frame(width: 16)
                                                    
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text("**\(track.title ?? track.filename.withoutExtension)**")
                                                            .lineSpacing(4)
                                                            .foregroundColor(.primary)
                                                            .textSelection(.enabled)
                                                            
                                                        if album.artists == nil ||
                                                            track.artist != nil && track.artist != album.artists! {
                                                            Text("**\(track.artist!)**")
                                                                .lineSpacing(4)
                                                                .foregroundColor(.secondary)
                                                                .textSelection(.enabled)
                                                        }
                                                    }
                                                    .padding(.vertical, 6.8)
                                                    .padding(.horizontal, 8)
                                                    .background(TranslucentBackground())
                                                    .cornerRadius(4)
                                                    
                                                    MatchButton(length: Int(track.length),
                                                                lengthText: track.lengthText)
                                                    
                                                    
                                                }
                                                .padding(.horizontal, 4)
                                            }
                                                
                                            Spacer()
                                                .frame(width: lilSpacing2x+lilIconLength)
                                            
                                            Spacer()
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.bottom, 4)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, lilSpacing2x+lilIconLength)
                    .padding(.top, lilSpacing2x+lilIconLength)
                    .onPreferenceChange(ScrolledPreferenceKey.self) { values in
                        scrolled = values[0]
                    }
                }
            
                if scrolled > -27 {
                    VStack {
                        VStack(spacing: 0) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(height: lilSpacing2x+lilIconLength-0.5)
                            }
                                
                            Rectangle()
                                .frame(width: unitLength-1, height: 1)
                                .foregroundColor(Color.secondary.opacity(0.4))
                                .offset(x: -0.5)
                            
                        }
                        .background(TranslucentBackground())
                        
                        Spacer()
                    }
                }
                
                if store.page != 3 {
                    VStack {
                        HStack {
                            Spacer()
                            
                            ButtonMini(systemName: "sidebar.squares.right", helpText: "Hide Match")
                                .onTapGesture {
                                    store.showMatchPanel = false
                                }
                        }
                        .padding(8)
                        
                        Spacer()
                    }
                }
            }
        }
        .frame(width: unitLength)
    }
}

extension String {
    var withoutExtension: String {
        self.split(separator: ".").dropLast().joined(separator: ".")
    }
}

extension MatchPanel {
    var album: Album {
        store.album!
    }
    
    var tracks: [Album.Track] {
        store.album!.tracks
    }
    
    var tracksSortedByNo: [Album.Track] {
        store.album!.tracks.sorted {
            ($0.trackNo ?? 0) < ($1.trackNo ?? 0)
        }
    }
    
    struct ScrolledPreferenceKey: PreferenceKey {
        static var defaultValue: [CGFloat] = [0]

        static func reduce(value: inout [CGFloat],
                           nextValue: () -> [CGFloat]) {
            value.append(contentsOf: nextValue())
        }
    }
    
    private func delta(outter: GeometryProxy, inner: GeometryProxy) -> CGFloat {
        return outter.frame(in: .global).minY - inner.frame(in: .global).minY
    }
}

struct MatchButton: View {
    let length: Int
    let lengthText: String
    
    @State private var hover: Bool = false
    
    var body: some View {
        ZStack {
            if hover {
                Menu {
                    Text("Unmatched")
                    Divider()
                    Text("Matched")
                } label: {
                    Text("Match")
                        .font(.custom("Yanone Kaffeesatz", size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .menuIndicator(.hidden)
                .frame(width: 29)
                .padding(.leading, 2.5)
                .padding(.trailing, -2.5)
            }
            
            if !hover {
                Text(lengthText)
                    .font(.custom("Yanone Kaffeesatz", size: 16))
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: length >= 3600 ? 47 : 29)
        .onHover { hovering in
            withAnimation {
                hover = hovering
            }
        }
    }
}
