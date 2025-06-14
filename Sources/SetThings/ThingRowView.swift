//
//  ThingRowView.swift
//  SetThings
//
//  Created by kin on 5/5/25.
//
import SwiftUI

struct ThingRowView: View {
    let item: ThingItem
    let onEdited: ((String, Any?) -> Void)?

    @State private var stringValue: String = ""
    @State private var boolValue: Bool = false
    @State private var intValue: Int = 0
    @State private var dateValue: Date = Date()
    @State private var colorValue: Color = .clear
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                item.getTitleView()
                if let desc = item.description {
                    Text(desc)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()

            switch item.type {
            case .text(_, let defaultValue):
                TextField("", text: Binding(
                    get: { stringValue },
                    set: {
                        guard stringValue != $0 else { return }
                        stringValue = $0
                        onEdited?(item.key, stringValue)
                    }
                ))
                .multilineTextAlignment(.trailing)
                .onAppear {
                    stringValue = defaultValue ?? ""
                }

            case .bool(let defaultValue):
                Toggle("", isOn: Binding(
                    get: { boolValue },
                    set: {
                        guard boolValue != $0 else { return }
                        boolValue = $0
                        onEdited?(item.key, boolValue)
                    }
                ))
                .labelsHidden()
                .onAppear {
                    boolValue = defaultValue
                }

            case .number(_, let defaultValue):
                TextField("", text: Binding(
                    get: { stringValue },
                    set: {
                        guard stringValue != $0 else { return }
                        stringValue = $0
                        let filtered = stringValue.filter { "0123456789.".contains($0) }
                        if filtered != stringValue {
                            stringValue = filtered
                        }
                        let decimalValue = Decimal(string: filtered)
                        onEdited?(item.key, decimalValue)
                    }
                ))
                    .multilineTextAlignment(.trailing)
        #if os(iOS)
                    .keyboardType(.decimalPad)
        #endif
                    .onAppear {
                        if let value = defaultValue, stringValue != "\(value)" {
                            stringValue = "\(value)"
                        }
                    }

            case .password:
                SecureField("", text: Binding(
                    get: { stringValue },
                    set: {
                        guard stringValue != $0 else { return }
                        stringValue = $0
                        onEdited?(item.key, stringValue)
                    }
                ))
                .multilineTextAlignment(.trailing)

            case .selectString(let options, let defaultValue):
                Menu {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            guard stringValue != option else { return }
                            stringValue = option
                            onEdited?(item.key, stringValue)
                        }
                    }
                } label: {
                    Text(stringValue.isEmpty ? (defaultValue ?? "선택") : stringValue)
                        .foregroundColor(.blue)
                }
                .onAppear {
                    stringValue = defaultValue ?? ""
                }

            case .dateAndTime(let defaultValue):
                DatePicker("", selection: Binding(
                    get: { dateValue },
                    set: {
                        guard dateValue != $0 else { return }
                        dateValue = $0
                        onEdited?(item.key, dateValue)
                    }
                ), displayedComponents: [.date, .hourAndMinute])
                .labelsHidden()
                .onAppear {
                    dateValue = defaultValue
                }
            case .date(let defaultValue):
                DatePicker("", selection: Binding(
                    get: { dateValue },
                    set: {
                        guard dateValue != $0 else { return }
                        dateValue = $0
                        onEdited?(item.key, DateOnly(date: $0))
                    }
                ), displayedComponents: [.date])
                .labelsHidden()
                .onAppear {
                    dateValue = defaultValue.toDate()
                }

            case .time(let defaultValue):
                DatePicker("", selection: Binding(
                    get: { dateValue },
                    set: {
                        guard dateValue != $0 else { return }
                        dateValue = $0
                        onEdited?(item.key, TimeOnly(date: $0))
                    }
                ), displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .onAppear {
                    dateValue = defaultValue.toDate()
                }
            case .color(let defaultValue):
                ColorPicker("", selection: Binding(
                    get: { colorValue },
                    set: {
                        guard colorValue != $0 else { return }
                        colorValue = $0
                        onEdited?(item.key, colorValue)
                    }
                ))
                .labelsHidden()
                .onAppear {
                    colorValue = defaultValue
                }
            case .slider(let range, let defaultValue, let label):
                HStack {
                    Slider(
                        value: Binding(
                            get: { Double(intValue) },
                            set: {
                                let newValue = Int(round($0))
                                guard intValue != newValue else { return }
                                intValue = newValue
                                onEdited?(item.key, intValue)
                            }
                        ),
                        in: Double(range.lowerBound)...Double(range.upperBound),
                        step: 1
                    )
                    .padding(.trailing)
                    if let label = label {
                        label(intValue)
                    }
                }
                .onAppear {
                    intValue = defaultValue ?? range.lowerBound
                }
            case .view(let customView):
                customView
            default:
                Text("🔧 미지원 타입")
            }
        }
    }
}
