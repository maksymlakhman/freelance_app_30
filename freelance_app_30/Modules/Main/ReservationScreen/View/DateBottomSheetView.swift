import SwiftUI

struct DateBottomSheetView: View {
    @Binding var isShowing: Bool
    @Binding var selectedDate: Date

    private var calendar: Calendar {
        Calendar.current
    }

    private var today: Date {
        calendar.startOfDay(for: Date())
    }

    private var currentMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
    }

    private var nextMonth: Date? {
        let currentMonthComponent = calendar.component(.month, from: today)
        if currentMonthComponent == 12 {
            return nil
        }
        return calendar.date(byAdding: .month, value: 1, to: currentMonth)
    }

    private var minDate: Date {
        return today
    }

    private var maxDate: Date {
        if let nextMonth = nextMonth {
            let range = calendar.range(of: .day, in: .month, for: nextMonth)!
            return calendar.date(bySetting: .day, value: range.last!, of: nextMonth)!
        } else {
            let range = calendar.range(of: .day, in: .month, for: currentMonth)!
            return calendar.date(bySetting: .day, value: range.last!, of: currentMonth)!
        }
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
                    DatePickerSection(selectedDate: $selectedDate, minDate: minDate, maxDate: maxDate)
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

    private struct DatePickerSection: View {
        @Binding var selectedDate: Date
        var minDate: Date
        var maxDate: Date
        
        var body: some View {
            DatePicker("", selection: $selectedDate, in: minDate...maxDate, displayedComponents: .date)
                  .datePickerStyle(WheelDatePickerStyle())
                  .labelsHidden()
                  .padding()
                  .foregroundColor(.white)
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
        static let headerTitle: String = "Pick Date"
        static let datePickerTitle: String = "Date"
    }
}

#Preview {
    DateBottomSheetView(isShowing: .constant(true), selectedDate: .constant(Date.now))
}
