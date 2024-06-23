import Foundation


struct SensorData {
    var accelerometerData: String
    var gyroscopeData: String
    
    private var accelerometerDataSec: String
    private var gyroscopeDataSec: String
    
    private let column = "time,x,y,z\n"
    
    var connector = PhoneConnector()
    
    init() {
        self.accelerometerData = self.column
        self.gyroscopeData = self.column
        self.accelerometerDataSec = ""
        self.gyroscopeDataSec = ""
    }
    
    mutating func append(time: String, x: Double, y: Double, z: Double, sensorType: SensorType) {
        var line = time + ","
        line.append(String(x) + ",")
        line.append(String(y) + ",")
        line.append(String(z) + "\n")
        
        switch sensorType {
        case .watchAccelerometer:
            self.accelerometerData.append(line)
            self.accelerometerDataSec.append(line)
        case .watchGyroscope:
            self.gyroscopeData.append(line)
            self.gyroscopeDataSec.append(line)
        default:
            print("No data of \(sensorType) is available.")
        }
    }
    
    mutating func reset() {
        self.accelerometerData = self.column
        self.gyroscopeData = self.column
        
        self.accelerometerDataSec = ""
        self.gyroscopeDataSec = ""
    }
    
    mutating func sendAccelerometerData() {
        print("Size: \(self.accelerometerDataSec.lengthOfBytes(using: String.Encoding.utf8)) byte")
        
        if self.connector.send(key: "ACC_DATA", value: self.accelerometerDataSec) {
            self.accelerometerDataSec = ""
        }
    }
    
    mutating func sendGyroscopeData() {
        print("Size: \(self.gyroscopeDataSec.lengthOfBytes(using: String.Encoding.utf8)) byte")
        
        if self.connector.send(key: "GYR_DATA", value: self.gyroscopeDataSec) {
            self.gyroscopeDataSec = ""
        }
    }
}
