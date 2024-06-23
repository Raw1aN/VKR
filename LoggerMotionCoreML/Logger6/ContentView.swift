import SwiftUI

struct ContentView: View {
    @State private var logStarting = false
    @State private var isSharePresented = false
    @State private var isEmptySubjectLabel = false
    @State private var timingChoice = 0
    @State private var autoChoice = 0
    @State private var username = ""
    @State private var label = ""
    
    @State private var viewChoise = 0
    
    @ObservedObject var connector = WatchConnector()
    @ObservedObject var sensorManager = SensorManager()
    
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 3104)
    
    var body: some View {
        NavigationView {
            List {
                // class label
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text(sensorManager.classLabel)
                                .font(.system(.title, design: .rounded))
                                .padding(5)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                Section {
                    SensorData(axis: "x", value: self.connector.accX)
                    SensorData(axis: "y", value: self.connector.accY)
                    SensorData(axis: "z", value: self.connector.accZ)
                } header: {
                    Text("Accelerometer")
                }
                Section {
                    SensorData(axis: "x", value: self.connector.gyrX)
                    SensorData(axis: "y", value: self.connector.gyrY)
                    SensorData(axis: "z", value: self.connector.gyrZ)
                } header: {
                    Text("Gyroscop")
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        self.logStarting.toggle()
                        
                        let switchFeedback = UIImpactFeedbackGenerator(style: .medium)
                        switchFeedback.impactOccurred()
                        
                        if self.logStarting {
                            self.backgroundTaskID =
                            UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        }
                        else {
                            UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
                        }
                        
                    } label: {
                        if self.logStarting {
                            HStack {
                                Image(systemName: "stop.fill")
                            }
                        }
                        else {
                            HStack {
                                Image(systemName: "arrowtriangle.right.fill")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SensorData: View {
    var axis: String
    var value: Double
    var body: some View {
        HStack {
            Text(axis)
                .font(.system(.body, design: .rounded))
                .padding(.horizontal, 15)
            Spacer()
            Text(String(format: "%.3f", value))
                .font(.system(.body, design: .rounded).monospacedDigit())
                .foregroundColor(.secondary)
        }
    }
}
