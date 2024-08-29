import SwiftUI

struct TimeBottomSheetView: View {
    @Binding var isShowing: Bool
    @Binding var selectedDate: Date

    private var calendar: Calendar {
        Calendar.current
    }

    private var currentYear: Date {
        calendar.date(from: calendar.dateComponents([.year], from: Date()))!
    }

    private var minDate: Date {
        return currentYear
    }

    private var maxDate: Date {
        return calendar.date(byAdding: .year, value: 1, to: currentYear)!
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(Constants.overlayOpacity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowing = false
                        }
                    }

                VStack(spacing: Constants.sheetSpacing) {
                    sheetHeader
                    TimePickerSection(selectedDate: $selectedDate, minDate: minDate, maxDate: maxDate)
                }
                .padding(.top, Constants.headerPadding)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: Constants.sheetHeight)
                .background(Constants.sheetBackgroundColor)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .environment(\.colorScheme, .dark)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }

    @ViewBuilder
    private var sheetHeader: some View {
        HStack {
            cancelButton
            Spacer()
            Text(Constants.headerTitle)
                .font(.headline)
                .fixedSize()
            Spacer()
            selectButton
        }
        .padding(.horizontal, Constants.headerHorizontalPadding)
    }

    @ViewBuilder
    private var cancelButton: some View {
        Button(Constants.cancelButtonTitle) {
            selectedDate = Date.now
            isShowing = false
        }
    }

    @ViewBuilder
    private var selectButton: some View {
        Button(Constants.selectButtonTitle) {
            isShowing = false
        }
    }

    private struct TimePickerSection: View {
        @Binding var selectedDate: Date
        let minDate: Date
        let maxDate: Date
        
        var body: some View {
            DatePicker(Constants.datePickerTitle, selection: $selectedDate, in: minDate...maxDate, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()
                .foregroundColor(.white)
                .environment(\.locale, Locale(identifier: "en_US"))
        }
    }

    private struct Constants {
        static let overlayOpacity: Double = 0.3
        static let sheetSpacing: CGFloat = 0
        static let headerPadding: CGFloat = 40
        static let sheetHeight: CGFloat = 250
        static let sheetBackgroundColor: Color = .bottomSheetBackGround
        static let headerHorizontalPadding: CGFloat = 8
        static let cancelButtonTitle: String = "Cancel"
        static let selectButtonTitle: String = "Select"
        static let headerTitle: String = "Pick Time"
        static let datePickerTitle: String = "Time"
    }
}

#Preview {
    TimeBottomSheetView(isShowing: .constant(true), selectedDate: .constant(Date.now))
}
