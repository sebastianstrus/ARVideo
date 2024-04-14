import SwiftUI
import ARKit
import RealityKit
import AVFoundation
import AVKit

struct ARVideoView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Helper function to configure looping video on an AR entity
        func setupVideoAREntity(named resourceName: String, at anchorEntity: AnchorEntity, offsetX: Float = 0.0, offsetZ: Float = 0.0, rotation: Float = 0.0) -> ARView {
            if let url = Bundle.main.url(forResource: resourceName, withExtension: "mp4") {
                let player = AVPlayer(url: url)
                let material = VideoMaterial(avPlayer: player)
                let modelEntity = ModelEntity(mesh: .generateBox(width: 2.0, height: 1.125, depth: 0.01), materials: [material])
                
                modelEntity.transform.rotation = simd_quatf(angle: rotation * Float.pi / 180.0, axis: SIMD3<Float>(0, 1, 0))
                modelEntity.transform.translation += SIMD3<Float>(0.0, 0.0, 0.0)
                
                // Adding observer for video loop
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: .main) { _ in
                        player.seek(to: .zero)
                        player.play()
                }
                
                player.play()
                
                modelEntity.position.x += offsetX
                modelEntity.position.z += offsetZ
                modelEntity.setParent(anchorEntity)
                arView.scene.addAnchor(anchorEntity)
            }
            return arView
        }

        // Create AR entities for each video
        let anchor1 = AnchorEntity()
        _ = setupVideoAREntity(named: "video1ok", at: anchor1, offsetX: -1.15, rotation: 90)

        let anchor2 = AnchorEntity()
        _ = setupVideoAREntity(named: "video2ok", at: anchor2, offsetZ: -1.1)

        let anchor3 = AnchorEntity()
        _ = setupVideoAREntity(named: "video3ok", at: anchor3, offsetX: 1.15, rotation: -90)

        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Update view logic if needed
    }
}
