import SwiftUI

struct LabeledStepper: View {
    public init(
        _ title: String,
        description: String = "",
        value: Binding<Int>,
        in range: ClosedRange<Int> = Constants.defaultRange,
        longPressInterval: Double = Constants.defaultLongPressInterval,
        repeatOnLongPress: Bool = Constants.defaultRepeatOnLongPress,
        style: Style = .init()
    ) {
        self.title = title
        self.description = description
        self._value = value
        self.range = range
        self.longPressInterval = longPressInterval
        self.repeatOnLongPress = repeatOnLongPress
        self.style = style
    }
    
    @Binding public var value: Int
    
    public var title: String
    public var description: String
    public var range: ClosedRange<Int>
    public var longPressInterval: Double
    public var repeatOnLongPress: Bool
    public var style: Style
    
    @State private var timer: Timer?
    private var isPlusButtonDisabled: Bool { value >= range.upperBound }
    private var isMinusButtonDisabled: Bool { value <= range.lowerBound }
    
    private func onPress(_ isPressing: Bool, operation: @escaping (inout Int, Int) -> ()) {
        guard isPressing else { timer?.invalidate(); return }
        
        func action(_ timer: Timer?) {
            operation(&value, 1)
        }
        action(timer)
        
        guard repeatOnLongPress else { return }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: longPressInterval,
            repeats: true,
            block: action
        )
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .foregroundColor(style.titleColor)
                .font(.inter(.semibold, size: Constants.titleFontSize))
                .fixedSize()
            
            Text(description)
                .foregroundColor(style.descriptionColor)
                .fixedSize()
            Spacer()
            
            HStack(spacing: 0) {
                Button() {  } label: { Image(systemName: "minus") }
                    .onLongPressGesture(
                        minimumDuration: Constants.minimumDuration
                    ) {} onPressingChanged: { onPress($0, operation: -=) }
                    .frame(width: style.buttonWidth, height: style.height)
                    .disabled(isMinusButtonDisabled)
                    .foregroundColor(
                        isMinusButtonDisabled
                        ? style.inactiveButtonColor
                        : style.activeButtonColor
                    )
                    .contentShape(Rectangle())
                    .font(.inter(.medium, size: Constants.FontSizes.icon))
                
                Divider()
                    .padding([.top, .bottom], Constants.dividerPadding)
                
                Text("\(value)")
                    .foregroundColor(style.valueColor)
                    .frame(width: style.labelWidth, height: style.height)
                    .font(.inter(.medium, size: Constants.FontSizes.value))
                Divider()
                    .padding([.top, .bottom], Constants.dividerPadding)
                
                Button() { } label: { Image(systemName: "plus") }
                    .onLongPressGesture(
                        minimumDuration: Constants.minimumDuration
                    ) {} onPressingChanged: { onPress($0, operation: +=) }
                    .frame(width: style.buttonWidth, height: style.height)
                    .disabled(isPlusButtonDisabled)
                    .foregroundColor(
                        isPlusButtonDisabled
                        ? style.inactiveButtonColor
                        : style.activeButtonColor
                    )
                    .contentShape(Rectangle())
                    .font(.inter(.medium, size: Constants.FontSizes.icon))
            }
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
            .frame(height: style.height)
        }
        .lineLimit(1)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.top, Constants.topPadding)
    }
    
    private struct Constants {
        static let defaultRange: ClosedRange<Int> = 1...6
        static let defaultLongPressInterval: Double = 0.3
        static let defaultRepeatOnLongPress: Bool = true
        static let minimumDuration: Double = 0
        static let titleFontSize: CGFloat = 16
        static let dividerPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let topPadding: CGFloat = 16
        
        struct FontSizes {
            static let value: CGFloat = 16
            static let icon: CGFloat = 22
        }
    }
}

struct Style {
    
    public init(
        height: Double = 40.0,
        labelWidth: Double = 41.3,
        buttonWidth: Double = 41.3,
        buttonPadding: Double = 12.0,
        backgroundColor: Color = Color(.layerFour),
        activeButtonColor: Color = Color(.accent),
        inactiveButtonColor: Color = Color(.layerFive),
        titleColor: Color = Color(.layerOne),
        descriptionColor: Color = Color(.layerOne),
        valueColor: Color = Color(.layerOne)
    ) {
        self.height = height
        self.labelWidth = labelWidth
        self.buttonWidth = buttonWidth
        self.buttonPadding = buttonPadding
        self.backgroundColor = backgroundColor
        self.activeButtonColor = activeButtonColor
        self.inactiveButtonColor = inactiveButtonColor
        self.titleColor = titleColor
        self.descriptionColor = descriptionColor
        self.valueColor = valueColor
    }
    var height: Double
    var labelWidth: Double
    
    var buttonWidth: Double
    var buttonPadding: Double
    
    var backgroundColor: Color
    var activeButtonColor: Color
    var inactiveButtonColor: Color
    
    var titleColor: Color
    var descriptionColor: Color
    var valueColor: Color
}

#Preview {
    struct LabeledStepperDemo: View {
        @State private var value: Int = 2
        
        var body: some View {
            LabeledStepper(
                "Guests",
                description: "",
                value: $value,
                in: 1...6
            )
            .background(Color.layerThree)
            .padding()
        }
    }
    
    return LabeledStepperDemo()
}

