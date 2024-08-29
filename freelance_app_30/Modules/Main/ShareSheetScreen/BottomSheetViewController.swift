import SwiftUI
import UIKit
import Combine

@available(iOS 15, *)
class BottomSheetViewController<Content: View>: UIViewController, UISheetPresentationControllerDelegate {
    @Binding private var isPresented: Bool

    private let detents: [UISheetPresentationController.Detent]
    private let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let prefersGrabberVisible: Bool
    private let prefersScrollingExpandsWhenScrolledToEdge: Bool
    private let prefersEdgeAttachedInCompactHeight: Bool
    @Binding private var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool

    private let contentView: UIHostingController<Content>
    
    private var currentTheme: ColorScheme
    

    
    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier:  UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentIdentifier: Binding<UISheetPresentationController.Detent.Identifier?> = Binding.constant(nil),
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        content: Content
    ) {
        _isPresented = isPresented
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self._selectedDetentIdentifier = selectedDetentIdentifier
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        
        self.contentView = UIHostingController(rootView: content)
        
        self.currentTheme = .dark
        
        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = isModalInPresentation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(contentView)
        view.addSubview(contentView.view)

        contentView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = detents
            presentationController.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
            presentationController.prefersGrabberVisible = prefersGrabberVisible
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            presentationController.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            presentationController.selectedDetentIdentifier = selectedDetentIdentifier
            presentationController.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
            presentationController.delegate = self
        }

        if let hostingController = contentView as? UIHostingController<AnyView> {
            hostingController.rootView = AnyView(hostingController.rootView.environment(\.colorScheme, .dark))
        }
    }

    
    private func applyTheme(_ theme: ColorScheme) {
        switch theme {
        case .dark:
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        case .light:
            view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        @unknown default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyTheme(currentTheme)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isPresented = false
    }
    
    func updateSelectedDetentIdentifier(_ selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?) {
        self.sheetPresentationController?.animateChanges {
            self.sheetPresentationController?.selectedDetentIdentifier = selectedDetentIdentifier
        }
    }
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        self.selectedDetentIdentifier = sheetPresentationController.selectedDetentIdentifier
    }
}

@available(iOS 15, *)
struct BottomSheet<T: Any, ContentView: View>: ViewModifier {
    @Binding private var isPresented: Bool
    
    private let detents: [UISheetPresentationController.Detent]
    private let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let prefersGrabberVisible: Bool
    private let prefersScrollingExpandsWhenScrolledToEdge: Bool
    private let prefersEdgeAttachedInCompactHeight: Bool
    @Binding private var selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    private let widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    private let isModalInPresentation: Bool
    private var onDismiss: (() -> Void)?
    private let contentView: () -> ContentView
    
    @State private var bottomSheetViewController: BottomSheetViewController<ContentView>?

    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentIdentifier: Binding<UISheetPresentationController.Detent.Identifier?> = Binding.constant(nil),
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) {
        _isPresented = isPresented
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self._selectedDetentIdentifier = selectedDetentIdentifier
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        self.isModalInPresentation = isModalInPresentation
        self.contentView = contentView
        self.onDismiss = onDismiss
    }
    
    init(
        item: Binding<T?>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentIdentifier: Binding<UISheetPresentationController.Detent.Identifier?> = Binding.constant(nil),
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
     ) {
        self._isPresented = Binding<Bool>(get: {
            item.wrappedValue != nil
        }, set: { newValue in
            item.wrappedValue = nil
        })
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self._selectedDetentIdentifier = selectedDetentIdentifier
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        self.isModalInPresentation = isModalInPresentation
        self.contentView = contentView
     }

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented, perform: updatePresentation)
            .onChange(of: selectedDetentIdentifier, perform: updateSelectedDetentIdentifier)
    }

    private func updatePresentation(_ isPresented: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene else { return }

        
        guard let root = windowScene.keyWindow?.rootViewController else { return }
        var controllerToPresentFrom = root
        while let presented = controllerToPresentFrom.presentedViewController {
            controllerToPresentFrom = presented
        }

        if isPresented {
            bottomSheetViewController = BottomSheetViewController(
                isPresented: $isPresented,
                detents: detents,
                largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                prefersGrabberVisible: prefersGrabberVisible,
                prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                selectedDetentIdentifier: $selectedDetentIdentifier,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                isModalInPresentation: isModalInPresentation,
                content: contentView()
            )

            controllerToPresentFrom.present(bottomSheetViewController!, animated: true)

        } else {
            onDismiss?()
            bottomSheetViewController?.dismiss(animated: true)
        }
    }
    
    private func updateSelectedDetentIdentifier(_ selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?) {
        bottomSheetViewController?.updateSelectedDetentIdentifier(selectedDetentIdentifier)
    }
}

@available(iOS 15, *)
extension View {
    public func bottomSheet<ContentView: View>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentIdentifier: Binding<UISheetPresentationController.Detent.Identifier?> = Binding.constant(nil),
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        self.modifier(
            BottomSheet<Any, ContentView>(
                isPresented: isPresented,
                detents: detents,
                largestUndimmedDetentIdentifier:  largestUndimmedDetentIdentifier, prefersGrabberVisible: prefersGrabberVisible,
                prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                selectedDetentIdentifier: selectedDetentIdentifier,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                isModalInPresentation: isModalInPresentation,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
    public func bottomSheet<T: Any, ContentView: View>(
        item: Binding<T?>,
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentIdentifier: Binding<UISheetPresentationController.Detent.Identifier?> = Binding.constant(nil),
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        self.modifier(
            BottomSheet(
                item: item,
                detents: detents,
                largestUndimmedDetentIdentifier:  largestUndimmedDetentIdentifier, prefersGrabberVisible: prefersGrabberVisible,
                prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                selectedDetentIdentifier: selectedDetentIdentifier,
                widthFollowsPreferredContentSizeWhenEdgeAttached: widthFollowsPreferredContentSizeWhenEdgeAttached,
                isModalInPresentation: isModalInPresentation,
                onDismiss: onDismiss,
                contentView: contentView
            )
        )
    }
}
