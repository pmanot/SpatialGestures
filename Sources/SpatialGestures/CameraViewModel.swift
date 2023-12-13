//
// Copyright (c) Purav Manot
//

import AVFoundation
import Foundation
import CoreImage
import Combine
import SwiftUI
import Vision

class CameraViewModel: NSObject, ObservableObject {
    var outputHandler: (@MainActor (CVPixelBuffer) -> ())?
        
    private let videoDataOutputQueue = DispatchQueue.main
    private var cameraFeedSession: AVCaptureSession?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    override init() {
        super.init()
        setupAVSession()
    }
    
    // MARK: AVSession
    
    public func startFeed() {
        Task { @MainActor in
            self.cameraFeedSession?.startRunning()
        }
    }
    
    public func stopFeed() {
        Task { @MainActor in
            self.cameraFeedSession?.stopRunning
        }
    }
    
    private func setupAVSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        guard session.canAddInput(deviceInput) else {
            return
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        
        session.sessionPreset = .high
        
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            configureCaptureConnection(videoOutput: dataOutput)
        } else {
            return
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    private func configureCaptureConnection(videoOutput: AVCaptureVideoDataOutput) {
        guard let connection = videoOutput.connection(with: .video) else { return }
        connection.automaticallyAdjustsVideoMirroring = false
        connection.isVideoMirrored = false
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    @MainActor
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        outputHandler?(pixelBuffer)
    }
}
