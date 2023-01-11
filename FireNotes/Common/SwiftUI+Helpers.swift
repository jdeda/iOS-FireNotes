//
//  SynchronizeEnvironment.swift
//  Backblaze11
//
//  Created by cdeda on 5/31/22.
//

import Foundation
import SwiftUI

/// A ViewModifier that allows one to syncronize the change of a SwiftUI.Environment value with a binding
///
public struct SynchronizeEnvironment<Value>: ViewModifier {
    private struct EquatableBox<Value>: Equatable {
        let value: Value
        let isDuplicate: (Value, Value) -> Bool
        
        func valueIsEqual(to other: Value) -> Bool {
            isDuplicate(value, other)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.valueIsEqual(to: rhs.value)
        }
    }
    
    @Environment(\.self) var environment
    @Binding var value: Value
    let isDuplicate: (Value, Value) -> Bool
    let toValue: (EnvironmentValues) -> Value
    
    public func body(content: Content) -> some View {
        let current = EquatableBox(value: toValue(environment), isDuplicate: isDuplicate)
        
        return content
            .onAppear {
                if !current.valueIsEqual(to: value) {
                    value = current.value
                }
            }
            .onChange(of: current) {
                value = $0.value
            }
    }
}

extension View {
    public func syncronize<Value>(
        _ value: Binding<Value>,
        removeDuplicates isDuplicate: @escaping (Value, Value) -> Bool,
        _ toValue: @escaping (EnvironmentValues) -> Value
    ) -> some View {
        self.modifier(SynchronizeEnvironment(value: value, isDuplicate: isDuplicate, toValue: toValue))
    }
    
    /**
     Syncronizes a value on our state with a value from SwiftUI.Environment
     
     - Parameter value: a binding to the value in our state
     - Parameter toValue: a transform from SwiftUI.Environment to what the value should be
     
     ~~~
     var body: some View {
        WithViewStore(store) { viewStore in
            PlayerView(avPlayerHelper: viewStore.avPlayerHelper)
            .syncronize(viewStore.binding(\.$colorScheme), { $0.colorScheme })
     }
     ~~~
     */
    public func syncronize<Value>(
        _ value: Binding<Value>,
        _ toValue: @escaping (EnvironmentValues) -> Value
    ) -> some View where Value: Equatable {
        self.syncronize(value, removeDuplicates: ==, toValue)
    }
}

