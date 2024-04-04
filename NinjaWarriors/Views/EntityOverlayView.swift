//
//  EntityOverlayView.swift
//  NinjaWarriors
//
//  Created by Joshen on 22/3/24.
//

import Foundation
import SwiftUI

struct EntityOverlayView: View {
    let entities: [Entity]
    let componentManager: EntityComponentManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(/*componentManager.getAllEntities()*/ entities, id: \.id) { entity in
                    EntityDetailView(entity: entity, componentManager: componentManager)
                }
            }
            .padding()
            .background(Color.black.opacity(0.6))
            .cornerRadius(8)
            .foregroundColor(.white)
            .font(.caption)
        }
    }
}

struct EntityDetailView: View {
    var entity: Entity
    let componentManager: EntityComponentManager

    var body: some View {
        VStack(alignment: .leading) {
            Text("Entity ID: \(entity.id)")
                .bold()
            // This assumes Component has a CustomStringConvertible conformance
            ForEach(componentManager.getAllComponents(for: entity), id: \.self) { component in
                Text("Component: \(component.id)")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}
