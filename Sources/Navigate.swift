import NavigationBackport
import SwiftUI

public struct Step: Hashable {
    private var id: Int = UUID().hashValue
    private let build: () -> AnyView
    
    public init<V: View>(_ build: @autoclosure @escaping () -> V) {
        self.build = { AnyView(build()) }
    }
    
    public var view: AnyView { build() }
    
    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
    public static func == (lhs: Step, rhs: Step) -> Bool { false }
}

open class Flow {
    public var currentPathBinding: Binding<NBNavigationPath>?
    public var steps: [Step]
    
    public init(steps: [Step] = []) {
        self.steps = steps
    }
    
    public var nextStep: Step? {
        guard let currentStepCount = currentPathBinding?.wrappedValue.count else { return nil }
        guard currentStepCount < steps.count else { return nil }
        return steps[currentStepCount]
    }
}

public class StepNavigator: ObservableObject {
    @Published public var path: NBNavigationPath = .init()
    private var flow: Flow = Flow()
    
    public init() {}
    
    public func start(withFlow flow: Flow) {
        self.flow = flow
        self.flow.currentPathBinding = Binding(get: { self.path }, set: { self.path = $0 })
        moveToNextStep()
    }
    
    public func moveToNextStep() {
        guard let next = flow.nextStep else { return }
        path.append(next)
    }
}

extension View {
    @ViewBuilder
    public func navigate(with navigator: StepNavigator) -> some View {
        nbNavigationDestination(for: Step.self) { $0.view }
    }
}
