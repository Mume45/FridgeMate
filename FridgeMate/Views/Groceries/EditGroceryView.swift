//
//  EditGroceryView.swift
//  FridgeMate
//
//  Created by 袁钟盈 on 2025/10/21.
//

import SwiftUI


struct EditGroceryView: View {
    @Environment(\.dismiss) private var dismiss

    @State var draftName: String
    @State var draftAmount: Int
    @State var hasExpiration: Bool
    @State var draftExpiration: Date

    let onSave: (_ name: String, _ amount: Int, _ expiration: Date?) -> Void

    init(name: String, amount: Int, expiration: Date?, onSave: @escaping (_ name: String, _ amount: Int, _ expiration: Date?) -> Void) {
        self._draftName = State(initialValue: name)
        self._draftAmount = State(initialValue: max(1, amount))
        self._hasExpiration = State(initialValue: expiration != nil)
        self._draftExpiration = State(initialValue: expiration ?? Date())
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $draftName)
                        .textInputAutocapitalization(.words)
                }
                Section("Amount") {
                    Stepper(value: $draftAmount, in: 1...999) {
                        Text("\(draftAmount)")
                            .font(.headline)
                    }
                }
                Section("Expiration") {
                    Toggle("Has expiration date", isOn: $hasExpiration)
                    if hasExpiration {
                        DatePicker("Date", selection: $draftExpiration, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(draftName.trimmingCharacters(in: .whitespacesAndNewlines),
                               max(1, draftAmount),
                               hasExpiration ? draftExpiration : nil)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
