//
//  MissionView.swift
//  Moonshot
//
//  Created by Eric Schofield on 8/8/20.
//  Copyright © 2020 Eric Schofield. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts.first(where: { $0.id == member.name }) {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing member [\(member)] in crew [\(mission.displayName)]")
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    ForEach(self.crew, id: \.role) { member in
                        NavigationLink(destination: AstronautView(astronaut: member.astronaut)) {
                            HStack {
                                Image(member.astronaut.id)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(member.astronaut.name)
                                        .font(.headline)
                                    Text(member.role)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName),
                            displayMode: .inline)
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
