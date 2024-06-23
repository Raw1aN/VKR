import CoreMotion
import Combine
import CoreML

@available(iOS 15.0, *)
class SensorManager: NSObject, ObservableObject {
    var motionManager: CMMotionManager?
    
    
    private var accelerometerData = [Double]()

    private var cancellable: AnyCancellable?
    
    lazy var classifier: CoreMLModel = {
        do {
            let config = MLModelConfiguration()
            return try CoreMLModel(configuration: config)
        } catch {
            fatalError("Failed to load a model: \(error)")
        }
    }()
    
    @Published var classLabel: String = "?"
    @Published var confidence: Double = 0.0
    
    
    override init() {
        super.init()
        self.motionManager = CMMotionManager()
    }
    
    private func update() {
        
        if accelerometerData.count == 200 * 6 {
            do {
                let multiArray = try MLMultiArray.fromDouble(accelerometerData)
                let output = try classifier.prediction(conv1d_6_input: multiArray)
                classLabel = output.featureNames.first ?? "?"
            } catch {
                fatalError("Failed to predict: \(error)")
            }
            
            accelerometerData.removeAll()
        }
    }
    
    func make(accX: Double, accY: Double, accZ:Double, gyrX: Double, gyrY: Double, gyrZ: Double) {
        accelerometerData.append(accX)
        accelerometerData.append(accY)
        accelerometerData.append(accZ)
        accelerometerData.append(gyrX)
        accelerometerData.append(gyrY)
        accelerometerData.append(gyrZ)
        if accelerometerData.count == 200 * 6 {
            update()
        }
    }
}

extension MLMultiArray {
    static func fromDouble(_ input: [Double]) throws -> MLMultiArray {
        let mlArray = try! MLMultiArray(shape: [1, input.count as NSNumber], dataType: .double)
        let ptr = mlArray.dataPointer.bindMemory(to: Double.self, capacity: input.count)
        let ptrBuf = UnsafeMutableBufferPointer.init(start: ptr, count: input.count)
        _ = ptrBuf.initialize(from: input)
        return mlArray
    }
}
