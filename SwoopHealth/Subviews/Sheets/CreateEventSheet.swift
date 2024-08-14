//
//  CreateEventSheet.swift
//  SwoopHealth
//
//  Created by Jacob Lucas on 8/4/24.
//

import SwiftUI
import SwiftUIDatePickerDialog

struct CreateEventSheet: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    @FocusState private var focusedField: FocusableField?
    @Environment(\.dismiss) var dismiss
    
    private enum FocusableField: Hashable, CaseIterable {
        case description
    }
    
    private var allFieldsFilled: Bool {
        return !viewModel.title.isEmpty &&
        !viewModel.description.isEmpty &&
        viewModel.selectedPatient != nil
    }
    
    var body: some View {
        content
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
            viewModel.saveEvent()
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
            DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: [.date])
                .datePickerStyle(.compact)
                .font(.system(size: 16, weight: .medium))
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color(.systemGray5))
            
            DatePicker("Select Time", selection: $viewModel.selectedDate, displayedComponents: [.hourAndMinute])
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
            TextField("Title", text: $viewModel.title)
                .padding(12)
                .padding(.horizontal, 2)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(Color(.systemGray5))
                        .frame(height: 46)
                }
                .onChange(of: viewModel.title) { (oldValue, newValue) in
                    viewModel.title = viewModel.limitTitleText(newValue, limit: 50)
                }
            
            TextEditor(text: $viewModel.description)
                .padding(10)
                .padding(.horizontal, 2)
                .frame(height: UIScreen.main.bounds.height / 5)
                .focused($focusedField, equals: .description)
                .overlay {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(Color(.systemGray5))
                        if (viewModel.description.isEmpty) {
                            Text("Description")
                                .padding(16)
                                .foregroundStyle(Color(.systemGray3))
                        }
                    }
                }
                .onTapGesture {
                    focusedField = .description
                }
                .onChange(of: viewModel.description) { (oldValue, newValue) in
                    viewModel.description = viewModel.limitDescriptionText(newValue, limit: 200)
                }
        }
        .padding(12)
        .autocorrectionDisabled()
        .autocapitalization(.none)
    }
    
    private var patientList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            let filteredPatients = filterPatients(viewModel.patients)
            VStack(alignment: .leading) {
                HStack {
                    ForEach(0..<filteredPatients.count / 2, id: \.self) { index in
                        let patient = filteredPatients[index]
                        Button {
                            viewModel.selectedPatient = patient
                        } label: {
                            Text(patient.name)
                                .font(.system(size: 16))
                                .padding(12)
                                .padding(.horizontal, 6)
                                .foregroundStyle(viewModel.selectedPatient?.id == patient.id ? .white : Color(.label))
                                .background {
                                    Capsule()
                                        .foregroundStyle(viewModel.selectedPatient?.id == patient.id ? Color.blue : Color(.systemGray5))
                                }
                        }
                        .buttonStyle(ButtonScaleEffectStyle())
                    }
                }
                .padding(.horizontal, 12)
                
                HStack {
                    ForEach(filteredPatients.count / 2..<filteredPatients.count, id: \.self) { index in
                        let patient = filteredPatients[index]
                        Button {
                            viewModel.selectedPatient = patient
                        } label: {
                            Text(patient.name)
                                .font(.system(size: 16))
                                .padding(12)
                                .padding(.horizontal, 6)
                                .foregroundStyle(viewModel.selectedPatient?.id == patient.id ? .white : Color(.label))
                                .background {
                                    Capsule()
                                        .foregroundStyle(viewModel.selectedPatient?.id == patient.id ? Color.blue : Color(.systemGray5))
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
    
    private func filterPatients(_ users: [UserModel]) -> [UserModel] {
        return users.filter { user in
            user.type.rawValue == "patient"
        }
    }
}
