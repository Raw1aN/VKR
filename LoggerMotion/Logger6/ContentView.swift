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
    
    @State private var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 3104)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    
                    if self.username.count == 0 || self.label.count == 0 {
                        
                        self.isEmptySubjectLabel = true
                        self.isSharePresented = false
                        
                        let errorFeedback = UINotificationFeedbackGenerator()
                        errorFeedback.notificationOccurred(.error)
                    }
                    else {
                        self.isEmptySubjectLabel = false
                        self.isSharePresented = true
                    }
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Save")
                    }
                }
                .sheet(isPresented: $isSharePresented, content: {
                    
                    ActivityViewController(activityItems: self.connector.saver.getDataURLs(label: self.label), applicationActivities: nil)
                    })
                    .alert(isPresented: $isEmptySubjectLabel, content: {
                        Alert(title: Text("Ошибка"), message: Text("Ошибка"))
                    })
                
                Spacer()
                Button(action: {
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
                    
                }) {
                    if self.logStarting {
                        HStack {
                            Image(systemName: "pause.circle")
                            Text("Stop")
                        }
                    }
                    else {
                        HStack {
                            Image(systemName: "play.circle")
                            Text("Start")
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            VStack {
                HStack {
                    
                    TextField("Name", text: $label).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }.padding(.horizontal)
                
                VStack {
                    HStack {
                        Image(systemName: "applewatch")
                        Text("Watch").font(.headline)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Accelerometer")
                            .font(.headline)
                        
                        HStack {
                            Text(String(format: "%.3f", self.connector.accX))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(String(format: "%.3f", self.connector.accY))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(String(format: "%.3f", self.connector.accZ))
                                .multilineTextAlignment(.leading)
                            
                        }.padding(.horizontal)
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 2)
                    
                    VStack(alignment: .leading) {
                        Text("Gyroscope")
                        .font(.headline)
                        
                        HStack {
                            Text(String(format: "%.3f", self.connector.gyrX))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(String(format: "%.3f", self.connector.gyrY))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Text(String(format: "%.3f", self.connector.gyrZ))
                                .multilineTextAlignment(.leading)
                        }.padding(.horizontal)
                    }.padding(.horizontal, 25)
                        .padding(.vertical, 2)
                    
                }.padding(.vertical, 10)
            }
            
            
            
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
