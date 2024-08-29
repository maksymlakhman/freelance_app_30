import SwiftUI

enum FocusableField: Hashable {
    case userName, userPhone
}

fileprivate struct Constants {
    struct Spacing {
        static let zero: CGFloat = 0
        static let inner: CGFloat = 8
        static let smallHorizontalPadding: CGFloat = 12
        static let largeHorizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
    }
    
    struct Dimensions {
        static let textFieldHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 16
        static let pickerCornerRadius: CGFloat = 8
        static let strokeWidth: CGFloat = 1
        static let clearButtonSize: CGFloat = 24
        static let buttonHeight: CGFloat = 52
    }
    
    struct FontSizes {
        static let header: CGFloat = 16
        static let placeholder: CGFloat = 16
        static let picker: CGFloat = 16
        static let error: CGFloat = 12
        static let button: CGFloat = 16
    }
    
    struct Button {
        static let cornerRadius: CGFloat = 8
        static let scaleEnabled: CGFloat = 0.90
        static let scaleDisabled: CGFloat = 0.85
    }
}

struct ReservationScreen<VM: ReservationViewModelProtocol & ReservationFlowStateProtocol>: View {
    @StateObject var viewModel: VM
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedData: SharedData
    
    init(viewModel: VM) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @FocusState private var focusedField: FocusableField?

    private func dismissKeyboard() {
        focusedField = nil
    }
    
    var body: some View {
        ReservationFlowCoordinator(state: viewModel, content: content)
            .environmentObject(viewModel)
            .configureNavigationBar()
            .gesture(
                TapGesture()
                    .onEnded {
                        dismissKeyboard()
                    }
            )
    }
    
    @ViewBuilder private func content() -> some View {
        ZStack(alignment: .leading) {
            Color.layerThree
            reservationView
            DateBottomSheetView(isShowing: $viewModel.showDatePickerSheet, selectedDate: $viewModel.date)
            TimeBottomSheetView(isShowing: $viewModel.showTimePickerSheet, selectedDate: $viewModel.date)
        }
        .toolbar {
            leadingNavItems()
        }
        .background(Color.backgroundTwo)
    }
    
    @ViewBuilder
      private var reservationView: some View {
          VStack(alignment: .leading, spacing: Constants.Spacing.zero) {
              VStack(alignment: .leading, spacing: Constants.Spacing.inner) {
                  reservationUserNameTF
                  reservationUserPhoneNumberTF
              }
              .padding(.horizontal, Constants.Spacing.largeHorizontalPadding)
              VStack(alignment: .leading, spacing: Constants.Spacing.inner) {
                  LabeledStepper(viewModel.labelStepperText, value: $viewModel.stepperValue)
                  datePicker
                  timePicker
              }
              
              Spacer()
              reservationButton
                  .padding(.vertical, Constants.Spacing.verticalPadding)
                  .background(Color.backgroundTwo)
          }
          .padding(.top, Constants.Spacing.topPadding)
      }
    
    // MARK: - ReservationScreen: UserNameTextField
    @ViewBuilder
    private var reservationUserNameTF: some View {
        Section(header: Text(viewModel.reservationUserNameHeaderText)
            .foregroundStyle(.layerOne)
            .font(.inter(.semibold, size: Constants.FontSizes.header))
        ) {
            VStack(alignment : .leading, spacing : Constants.Spacing.inner) {
                TextField("", text: $viewModel.reservationUserName)
                    .frame(height: Constants.Dimensions.textFieldHeight)
                    .focused($focusedField, equals: .userName)
                    .placeholder(when: viewModel.reservationUserName.isEmpty) {
                        Text(viewModel.reservationUserNamePlaceholderText)
                            .foregroundColor(.layerFive)
                            .font(.inter(.medium, size: Constants.FontSizes.placeholder))
                    }
                    .padding(.horizontal, Constants.Spacing.largeHorizontalPadding)
                    .foregroundStyle(.layerOne)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textCase(nil)
                    .accentColor(.accentColor)
                    .submitLabel(.next)
                    .onChange(of: viewModel.reservationUserName) { newValue in
                        let components = newValue.components(separatedBy: " ")
                        let filteredComponents = components.filter { !$0.isEmpty }
                        let containsMultipleSpaces = components.count - 1 > 1
                        
                        if filteredComponents.count > 1 && containsMultipleSpaces {
                            viewModel.reservationUserName = String(filteredComponents.joined(separator: " ").prefix(24))
                        } else if newValue.count > 24 {
                            viewModel.reservationUserName = String(newValue.prefix(24))
                        }
                        
                        let _ = viewModel.validateReservationUserName()
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                            .strokeBorder(viewModel.isNameTooShort ? Color.red : (focusedField == .userName ? Color.accentColor : Color.layerFive), lineWidth: Constants.Dimensions.strokeWidth)
                        if !viewModel.isNameTooShort {
                            if !viewModel.reservationUserName.isEmpty && focusedField == .userName {
                                HStack(spacing: Constants.Spacing.zero) {
                                    Spacer()
                                    Button {
                                        viewModel.reservationUserName = ""
                                    } label: {
                                        Image(systemName: "x.circle.fill")
                                            .resizable()
                                            .frame(width: Constants.Dimensions.clearButtonSize, height: Constants.Dimensions.clearButtonSize)
                                            .foregroundStyle(.accent)
                                    }
                                }
                                .padding(.trailing, Constants.Spacing.largeHorizontalPadding)
                            }
                        }
                    }
                    .keyboardType(.default)
                    .onSubmit {
                        focusedField = .userPhone
                    }

                if viewModel.isNameTooShort {
                    Text(viewModel.userNameErrors.rawValue)
                        .foregroundColor(.red)
                        .font(.inter(.medium, size: Constants.FontSizes.error))
                        .fixedSize()
                }
            }
        }
    }


    
    // MARK: - ReservationScreen: UserPhoneNumberTextField
    @ViewBuilder
    private var reservationUserPhoneNumberTF: some View {
        Section(header: Text(viewModel.reservationUserPhoneNumberHeaderText)
            .foregroundStyle(.layerOne)
            .font(.inter(.semibold, size: Constants.FontSizes.header))
        ) {
            VStack(alignment : .leading, spacing : Constants.Spacing.inner) {
                TextField("", text: $viewModel.reservationUserPhoneNumber)
                    .frame(height: Constants.Dimensions.textFieldHeight)
                    .focused($focusedField, equals: .userPhone)
                    .placeholder(
                        placeholder: viewModel.reservationUserPhoneNumberPlaceholderText,
                        text: $viewModel.reservationUserPhoneNumber,
                        color: .layerFive,
                        font: .inter(.medium, size: Constants.FontSizes.placeholder)
                    )
                    .padding(.horizontal, Constants.Spacing.largeHorizontalPadding)
                    .foregroundStyle(.layerOne)
                    .textInputAutocapitalization(.never)
                    .textCase(nil)
                    .submitLabel(.done)
                    .onChange(of: focusedField) { field in
                        if field == .userPhone && viewModel.reservationUserPhoneNumber.isEmpty {
                            withAnimation(.smooth) {
                                viewModel.reservationUserPhoneNumber = "+55("
                            }
                        }
                    }
                    .onChange(of: viewModel.reservationUserPhoneNumber) { newValue in
                        let formattedNumber = viewModel.formatPhoneNumber(newValue)
                        if formattedNumber != viewModel.reservationUserPhoneNumber {
                            viewModel.reservationUserPhoneNumber = formattedNumber
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                            .strokeBorder(viewModel.isPhoneTooShort ? Color.red : (focusedField == .userPhone ? Color.accentColor : Color.layerFive), lineWidth: Constants.Dimensions.strokeWidth)
                        if (!viewModel.isPhoneTooShort) {
                            if (!viewModel.reservationUserPhoneNumber.isEmpty && focusedField == .userPhone) {
                                HStack(spacing: Constants.Spacing.zero) {
                                    Spacer()
                                    Button {
                                        viewModel.reservationUserPhoneNumber = ""
                                    } label: {
                                        Image(systemName: "x.circle.fill")
                                            .resizable()
                                            .frame(width: Constants.Dimensions.clearButtonSize, height: Constants.Dimensions.clearButtonSize)
                                            .foregroundStyle(.accent)
                                    }
                                }
                                .padding(.trailing, Constants.Spacing.largeHorizontalPadding)
                            }
                        }
                    }
                    .keyboardType(.numberPad)
                    .font(.inter(.medium, size: Constants.FontSizes.placeholder))
                    .onSubmit {
                        dismissKeyboard()
                    }

                if viewModel.isPhoneTooShort || viewModel.isPhoneTooLong {
                    Text(viewModel.userPhoneErrors.rawValue)
                        .foregroundColor(.red)
                        .font(.inter(.medium, size: Constants.FontSizes.error))
                        .fixedSize()
                }
            }
        }
    }
    
    // MARK: - ReservationScreen: Pickers(Date & Time)
    @ViewBuilder
    private var datePicker: some View {
        pickerView(label: viewModel.datePickerLabelText, text: Date.dateFormatter.string(from: viewModel.date), showSheet: $viewModel.showDatePickerSheet)
    }

    @ViewBuilder
    private var timePicker: some View {
        pickerView(label: viewModel.timePickerLabelText, text: Date.timeFormatter.string(from: viewModel.date), showSheet: $viewModel.showTimePickerSheet)
    }
    
    @ViewBuilder
    private func pickerView(label: String, text: String, showSheet: Binding<Bool>) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.layerOne)
                .font(.inter(.semibold, size: 16))
                .fixedSize()
            Spacer()
            Button {
                showSheet.wrappedValue = true
                dismissKeyboard()
            } label: {
                Text(text)
                    .foregroundColor(.accentColor)
                    .font(.inter(.medium, size: Constants.FontSizes.picker))
                    .fixedSize()
                    .padding(Constants.Spacing.smallHorizontalPadding)
                    .background(RoundedRectangle(cornerRadius: Constants.Dimensions.pickerCornerRadius)
                        .fill(Color.layerFour))
            }
        }
        .padding(.horizontal, Constants.Spacing.largeHorizontalPadding)
    }
    
    // MARK: - ReservationScreen: ReservationBtn
    @ViewBuilder
    private var reservationButton: some View {
        Button()  {
            if viewModel.validateAll() {
                withAnimation {
                    viewModel.saveReservation()
                    viewModel.activeLink = .mainScreenLink
                    sharedData.isToastShowing = true
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.Button.cornerRadius)
                    .fill(viewModel.isReservationButtonEnabled ? Color.accentColor : Color.layerFive)
                    .scaleEffect(viewModel.isReservationButtonEnabled ? Constants.Button.scaleEnabled : Constants.Button.scaleDisabled)
                    .animation(.spring(), value: viewModel.isReservationButtonEnabled)
                Text(viewModel.reservationButtonText)
                    .foregroundStyle(.layerTwo)
                    .font(.inter(.semibold, size: Constants.FontSizes.button))
                    .fixedSize()
            }
        }
        .frame(height: Constants.Dimensions.buttonHeight)
        .disabled(!viewModel.isReservationButtonEnabled)
    }
    

}


// MARK: - ReservationScreen: NavigationBar/Toolbar
extension ReservationScreen {

    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        let navigationBarConstants = NavigationBarConstants()
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: navigationBarConstants.leadingDefaultSpacing) {
                Button {
                    if !viewModel.reservationUserName.isEmpty || !viewModel.reservationUserPhoneNumber.isEmpty {
                        viewModel.showingAlert = true
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                } label: {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: navigationBarConstants.leadingCornerRadius)
                            .fill(Color.layerThree)
                        Image(systemName: viewModel.leftNavBarImage)
                            .frame(width: navigationBarConstants.leadingImageWidth, height: navigationBarConstants.leadingImageHeight)
                    }
                    .frame(width: navigationBarConstants.leadingStackWidth, height: navigationBarConstants.leadingStackHeight)
                }
                .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
                    Button(viewModel.editCancelActionButton, role: .cancel, action: {

                    })
                    Button(viewModel.cancelDestructiveActionButton, role: .destructive, action: {
                        presentationMode.wrappedValue.dismiss()
                    })
                } message: {
                    Text(viewModel.alertMessageText)
                        .fixedSize()
                }
                
                Text(viewModel.leftNavBarTextOne)
                    .foregroundStyle(Color.layerOne)
                    .font(.inter(.medium, size: navigationBarConstants.leadingLargestFont))
                    .fixedSize()
            }
            .navigationBarPaddingBottomPercentage()
        }
    }
    
    private struct NavigationBarConstants {
        let leadingDefaultSpacing: CGFloat = 0
        let leadingLargestFont: CGFloat = 18
        let leadingCornerRadius: CGFloat = 8
        let leadingImageWidth: CGFloat = 24
        let leadingImageHeight: CGFloat = 24
        let leadingStackWidth: CGFloat = 40
        let leadingStackHeight: CGFloat = 40
    }
}

#Preview {
    ReservationScreen(viewModel: ReservationViewModel())
        .environmentObject(SharedData())
}
