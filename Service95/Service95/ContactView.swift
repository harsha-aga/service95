import SwiftUI
import SceneKit

//struct ContactView: View {
//    var body: some View {
//        VStack {
//            Section {
//                RotatingColorChangingSphereView()
//                    .frame(width: 300, height: 300)
//                    .edgesIgnoringSafeArea(.all)
//            }
////            Text("Contact Us").font(.largeTitle).fontWeight(.black)
//        }
//    }
//}

struct ContactView: View {
    var body: some View {
        List {
            VStack {
                Section {
                    RotatingColorChangingSphereView()
                        .frame(width: 300, height: 300)
                        .edgesIgnoringSafeArea(.all)
                } header: {
                    Text("Contact Us")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.leading)
                }
                Section {
                    ContactTextView(title: "For general enquiries, please email:", description: "info@service95.com")
                }
                Section {
                    ContactTextView(title: "For editorial pitches, please email:", description: "editors@service95.com")
                }
                Section {
                    ContactTextView(title: "For Book Club enquiries, please email:", description: "books@service95.com")
                }
                Section {
                    ContactTextView(title: "For press enquiries, please email:", description: "info@permanentpressmedia.com")
                }
                Section {
                    ContactTextView(title: "Careers:", description: "There are currently no vacancies at Service95. Check back here for any future opportunities.")
                }
                Section {
                    ContactTextView(title: "Follow us at:", description: "Instagram @service95\nTwitter @service95\nTikTok @service95")
                }
            }
        }
    }
}

#Preview {
    ContactView()
}

struct ContactTextView: View {
    var title: String
    var description: String
    
    var body: some View {
        Text(title).frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        Text(description).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading).padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)).multilineTextAlignment(.leading)
    }
}

struct RotatingColorChangingSphereView: View {
    //TODO: Add color changing facility
    @State private var globeColor: UIColor = ColorGenerator.shared.nextColor()
    @State private var timer: Timer?
    var body: some View {
        SceneView(scene: createScene())
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
    }
    private func createScene() -> SCNScene {
        let scene = SCNScene()
        
        // Create a node to tilt the sphere
        let tiltNode = SCNNode()
        scene.rootNode.addChildNode(tiltNode)
        
        // sphere node creation
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 1.0))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        sphereNode.geometry?.firstMaterial = material
        scene.rootNode.addChildNode(sphereNode)
        // Add latitude and longitude lines
        addLatLonLines(to: sphereNode)
        //            let rotationAngle: Float = 252.0 * (.pi / 180.0) // Convert degrees to radians
        //            sphereNode.rotation = SCNVector4(1, 0, 0, rotationAngle) // Rotate around x-axis
        
        scene.rootNode.addChildNode(sphereNode)
        
        // Rotate the sphere
        let rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 252.0 * (Double.pi / 180.0), y: 0, z: 0, duration: 5))
        sphereNode.runAction(rotateAction)
        
        return scene
    }
    
    private func addLatLonLines(to node: SCNNode) {
        let radius: CGFloat = 1.0
        // Latitude lines
        for i in stride(from: -90, through: 90, by: 20) {
            let latitude = CGFloat(i) * CGFloat.pi / 180.0
            let lineNode = createLatitudeLineNode(radius: radius, latitude: latitude)
            node.addChildNode(lineNode)
        }
        
        // Longitude lines
        for i in stride(from: 0, to: 360, by: 20) {
            let longitude = CGFloat(i) * CGFloat.pi / 180.0
            let lineNode = createLongitudeLineNode(radius: radius, longitude: longitude)
            node.addChildNode(lineNode)
        }
        
    }
    
    private func createLatitudeLineNode(radius: CGFloat, latitude: CGFloat) -> SCNNode {
        var positions = [SCNVector3]()
        
        for i in stride(from: 0, through: 360, by: 10) {
            let angle = CGFloat(i) * CGFloat.pi / 180.0
            let x = radius * cos(latitude) * cos(angle)
            let y = radius * sin(latitude)
            let z = radius * cos(latitude) * sin(angle)
            positions.append(SCNVector3(x, y, z))
        }
        
        return createLineNode(from: positions)
    }
    
    private func createLongitudeLineNode(radius: CGFloat, longitude: CGFloat) -> SCNNode {
        var positions = [SCNVector3]()
        
        for i in stride(from: -90, through: 90, by: 10) {
            let latitude = CGFloat(i) * CGFloat.pi / 180.0
            let x = radius * cos(latitude) * cos(longitude)
            let y = radius * sin(latitude)
            let z = radius * cos(latitude) * sin(longitude)
            positions.append(SCNVector3(x, y, z))
        }
        
        return createLineNode(from: positions)
    }
    
    private func createLineNode(from positions: [SCNVector3]) -> SCNNode {
        var positionData = Data()
        var indices = [UInt32]()
        
        for (index, var position) in positions.enumerated() {
            positionData.append(Data(bytes: &position, count: MemoryLayout<SCNVector3>.size))
            if index > 0 {
                indices.append(UInt32(index - 1))
                indices.append(UInt32(index))
            }
        }
        
        let positionSource = SCNGeometrySource(data: positionData,
                                               semantic: .vertex,
                                               vectorCount: positions.count,
                                               usesFloatComponents: true,
                                               componentsPerVector: 3,
                                               bytesPerComponent: MemoryLayout<Float>.size,
                                               dataOffset: 0,
                                               dataStride: MemoryLayout<SCNVector3>.stride)
        
        let indexData = Data(bytes: indices, count: MemoryLayout<UInt32>.size * indices.count)
        let element = SCNGeometryElement(data: indexData,
                                         primitiveType: .line,
                                         primitiveCount: indices.count / 2,
                                         bytesPerIndex: MemoryLayout<UInt32>.size)
        
        let geometry = SCNGeometry(sources: [positionSource], elements: [element])
        let material = SCNMaterial()
        material.diffuse.contents = globeColor
        geometry.materials = [material]
        
        let node = SCNNode(geometry: geometry)
        return node
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            globeColor = ColorGenerator.shared.nextColor()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

class ColorGenerator {
    static let shared = ColorGenerator()
    private var hue: CGFloat = 0.0

    private init() {}

    func nextColor() -> UIColor {
        hue += 0.1
        if hue > 1.0 { hue -= 1.0 }
        return UIColor(hue: hue, saturation: 0.8, brightness: 0.8, alpha: 1.0)
    }
}
