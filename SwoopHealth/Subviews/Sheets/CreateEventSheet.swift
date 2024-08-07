//
//  CreateEventSheet.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import SwiftUI
import SwiftUIDatePickerDialog

struct CreateEventSheet: View {
    
    @State var title: String = ""
    @State var description: String = ""
    @State var selectedDate = Date()
    @State var selectedPatient: UserModel? = nil
    
    @ObservedObject var viewModel: CalendarViewModel
    
    @FocusState private var focusedField: FocusableField?
    @Environment(\.dismiss) var dismiss
    
    private enum FocusableField: Hashable, CaseIterable {
        case description
    }
    
    private var allFieldsFilled: Bool {
        return !title.isEmpty &&
        !description.isEmpty &&
        selectedPatient != nil
    }
    
    var body: some View {
        content
    }
    
    func saveEvent() {
        viewModel.saveEvent(
            title: title,
            description: description,
            selectedDate: selectedDate,
            selectedPatient: selectedPatient
        )
    }
}

#Preview {
    CreateEventSheet(viewModel: CalendarViewModel())
}

extension CreateEventSheet {
    private var content: some View {
        VStack {
            Capsule()
                .frame(width: 45, height: 5)
                .foregroundStyle(Color(.systemGray4))
                .padding(.top)
            
            picker
            Spacer()
            details
            Spacer()
            patientList
            button
        }
        .onTapGesture {
            if (focusedField == .description) {
                focusedField = nil
            }
        }
        .alert(isPresented: $viewModel.success) {
            return SwiftUI.Alert(
                title: Text("Success"),
                message: Text("Your appointment has been created successfully."),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                }
            )
        }
    }
    
    private var button: some View {
        Button {
            saveEvent()
        } label: {
            HStack {
                Spacer()
                if (viewModel.isLoading) {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Save Appointment")
                }
                Spacer()
            }
            .padding([.vertical, .bottom])
            .padding(.bottom)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(.white)
            .background {
                Rectangle()
                    .foregroundStyle(.blue)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .opacity(allFieldsFilled ? 1.0 : 0.5)
        .disabled(allFieldsFilled ? false : true)
    }
    
    private var picker: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .font(.system(size: 16, weight: .medium))
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.systemGray5))
            
            DatePicker("Select Time", selection: $selectedDate, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.compact)
                .font(.system(size: 16, weight: .medium))
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(.systemGray5))
        }
        .padding(12)
    }
    
    private var details: some View {
        VStack(spacing: 12) {
            TextField("Title", text: $title)
                .padding(12)
                .padding(.horizontal, 2)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color(.systemGray5))
                        .frame(height: 46)
                }
            
            TextEditor(text: $description)
                .padding(10)
                .padding(.horizontal, 2)
                .frame(height: UIScreen.main.bounds.height / 5)
                .focused($focusedField, equals: .description)
                .overlay {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color(.systemGray5))
                        if (description.isEmpty) {
                            Text("Description")
                                .padding(16)
                                .foregroundStyle(Color(.systemGray3))
                        }
                    }
                }
                .onTapGesture {
                    focusedField = .description
                }
            
        }
        .padding(12)
        .autocorrectionDisabled()
        .autocapitalization(.none)
    }
    
    private var patientList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    ForEach(0..<viewModel.patients.count / 2, id: \.self) { index in
                        let patient = viewModel.patients[index]
                        Button {
                            selectedPatient = patient
                        } label: {
                            Text(patient.name)
                                .font(.system(size: 16))
                                .padding(12)
                                .padding(.horizontal, 6)
                                .foregroundStyle(selectedPatient?.id == patient.id ? .white : Color(.label))
                                .background {
                                    Capsule()
                                        .foregroundStyle(selectedPatient?.id == patient.id ? Color.blue : Color(.systemGray5))
                                }
                        }
                        .buttonStyle(ButtonScaleEffectStyle())
                    }
                }
                .padding(.horizontal, 12)
                
                HStack {
                    ForEach(viewModel.patients.count / 2..<viewModel.patients.count, id: \.self) { index in
                        let patient = viewModel.patients[index]
                        Button {
                            selectedPatient = patient
                        } label: {
                            Text(patient.name)
                                .font(.system(size: 16))
                                .padding(12)
                                .padding(.horizontal, 6)
                                .foregroundStyle(selectedPatient?.id == patient.id ? .white : Color(.label))
                                .background {
                                    Capsule()
                                        .foregroundStyle(selectedPatient?.id == patient.id ? Color.blue : Color(.systemGray5))
                                }
                        }
                        .buttonStyle(ButtonScaleEffectStyle())
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .padding(.vertical)
    }
}
