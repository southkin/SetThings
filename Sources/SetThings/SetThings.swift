// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI

public struct SetThings: View {
    let items: [ThingItem]
    let onEdited: ((String, Any?) -> Void)?

    public init(items: [ThingItem], onEdited: ((String, Any?) -> Void)? = nil) {
        self.items = items
        self.onEdited = onEdited
    }
    @ViewBuilder
    func render(_ item: ThingItem) -> some View {
        switch item.type {
        case .section(let items):
            AnyView(
                Section(item.name) {
                    ForEach(items, id: \.key) { item in
                        render(item)
                    }
                }
            )
        case .group(let items):
            AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    Text(item.name)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    ForEach(Array(items.enumerated()), id: \.element.key) { index, item in
                                    render(item)
                                        .padding(.leading)
                                        .padding(.bottom, index == items.count - 1 ? 0 : 8) // 마지막은 0
                                }
                }
            )
        case .block(let view):
            view
        default:
            AnyView(ThingRowView(item: item, onEdited: onEdited))
        }
    }

    public var body: some View {
        List {
            ForEach(items, id: \.key) { item in
                render(item)
            }
        }
    }
}
extension SetThings {
    public func onEdited(_ action: @escaping (String, Any?) -> Void) -> SetThings {
        SetThings(items: self.items, onEdited: action)
    }
}

struct MinimalThingItem: ThingItem {
    var key: String = UUID().uuidString
    var name: String
    var type: ThingType
    var description: String?
}
struct ValueSummaryView: View {
    @Binding var values: [String: Any]

    var body: some View {
        VStack(alignment: .leading) {
            Text("changedValues")
                .font(.headline)
            ForEach(values.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                Text("\(key): \(String(describing: value))")
                    .font(.caption)
            }
        }
        .padding()
    }
}

#Preview("ThingType Showcase") {
    SetThingsPreviewWrapper()
}
@available(macOS 14.0, *)
#Preview("macOS Preview", traits: .fixedLayout(width: 400, height: 550)) {
    SetThingsPreviewWrapper()
}
struct SetThingsPreviewWrapper: View {
    @State var editedValues: [String: Any] = [:]

    var body: some View {
        SetThings(items: [
            MinimalThingItem(name: "Debug", type: .section([
                MinimalThingItem(name: "", type: .block(AnyView(ValueSummaryView(values: $editedValues)))),
            ])),
            MinimalThingItem(key:"sliderBasic" , name: "Basic Slider", type: .slider(range: -2...2, defaultValue: 0)),
            MinimalThingItem(key:"sliderBasic NoneLabel" , name: "Basic Slider None Label", type: .slider(range: -2...2, defaultValue: 0, label: nil)),
            MinimalThingItem(key:"sliderWithLabel" , name: "Slider with Label", type: .slider(range: 0...50, defaultValue: 0) { value in
                AnyView(Text("\(value)/50").foregroundColor(.blue).font(.headline))
            }),
            MinimalThingItem(key:"textField" , name: "Text Field", type: .text(placeholder: "Enter text", defaultValue: "Sample"), description: "it's description!!!"),
            MinimalThingItem(key:"numberField" , name: "Number Field", type: .number(placeholder: "1234", defaultValue: Decimal(42))),
            MinimalThingItem(key:"password" , name: "Password", type: .password(placeholder: "Secret")),
            MinimalThingItem(key:"option" , name: "Select Option", type: .selectString(["One", "Two", "Three"], defaultValue: "Two")),
            MinimalThingItem(key:"toggle" , name: "Toggle", type: .bool(true)),
            MinimalThingItem(name: "Section", type: .section([
                MinimalThingItem(key:"toggleInGroup" , name: "Nested Toggle", type: .bool(false)),
                MinimalThingItem(key:"textInGroup" , name: "Nested Text", type: .text(placeholder: "Nested"))
            ])),
            MinimalThingItem(key:"onlyDate" , name: "Date Only", type: .date(DateOnly(year: 2025, month: 1, day: 1))),
            MinimalThingItem(key:"onlyTime", name: "Time Only", type: .time(TimeOnly(hour: 10, minute: 10))),
            MinimalThingItem(key:"dateAndTime",name: "Date and Time", type: .dateAndTime(Date())),
            MinimalThingItem(name:"Group",type:.group([
                MinimalThingItem(key:"color1",name: "Color Picker", type: .color(.blue)),
                MinimalThingItem(key:"color2",name: "Color Picker", type: .color(.green)),
                MinimalThingItem(name:"GroupInGroup",type:.group([
                    MinimalThingItem(key:"color3",name: "Color Picker", type: .color(.red)),
                    MinimalThingItem(key:"color4",name: "Color Picker", type: .color(.yellow)),
                ])),
            ])),
            
            MinimalThingItem(name: "Custom View", type: .view(AnyView(Text("🧩 Custom View")))),
            
        ])
        .onEdited { key, value in
            editedValues[key] = value
            print("Edited: \(key) = \(String(describing: value))")
        }
    }
}
#if DEBUG
extension TimeOnly: CustomStringConvertible {
    public var description: String { String(format: "%02d:%02d", hour, minute) }
}
extension DateOnly: CustomStringConvertible {
    public var description: String { String(format: "%04d-%02d-%02d", year, month, day) }
}
#endif
