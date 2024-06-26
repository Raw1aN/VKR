import SwiftUI

struct ContentView: View {
    @State private var logStarting = false
  
    @ObservedObject var sensorLogger = WatchSensorLogManager()
    
    var body: some View {
        VStack {
            Button(action: {
                self.logStarting.toggle()
                
                if self.logStarting {
                    self.sensorLogger.startUpdate(50.0)
                }
                else {
                    self.sensorLogger.stopUpdate()
                    
                }
            }) {
                if self.logStarting {
                    Image(systemName: "pause.circle")
                }
                else {
                    Image(systemName: "play.circle")
                }
            }
            
            VStack {
                VStack {
                Text("Accelerometer").font(.headline)
                HStack {
                    Text(String(format: "%.2f", self.sensorLogger.accX))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.accY))
                    Spacer()
                    Text(String(format: "%.2f", self.sensorLogger.accZ))
                }.padding(.horizontal)
                }

            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
