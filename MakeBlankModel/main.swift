//
//  main.swift
//  MakeBlankModel
//
//  Created by William Hahn on 12/18/22.
//

import Foundation
import SwiftCoreMLTools

func makeModelURL() -> URL {
    var modelURL: URL
    
    print("File name for model?")
    let fileName = readLine()!
    
    modelURL = URL(fileURLWithPath: NSHomeDirectory())
        .appendingPathComponent(fileName)
    
    return modelURL
}

func prepareModel() -> Model {
    var newModel = Model(version: 4, author: "William Hahn", license: "MIT") {
        NeuralNetwork(losses: [CategoricalCrossEntropy(name: "lossLayer",
                                   input: "data_out",
                                   target: "output_true")],
                      optimizer: Adam(learningRateDefault: 0.0001,
                                     learningRateMax: 0.3,
                                     miniBatchSizeDefault: 8,
                                     miniBatchSizeRange: [8],
                                     beta1Default: 0.9,
                                     beta1Max: 1.0,
                                     beta2Default: 0.999,
                                     beta2Max: 1.0,
                                     epsDefault: 0.00000001,
                                     epsMax: 0.00000001),
                      epochDefault: UInt(5),
                      epochSet: [UInt(5)],
                      shuffle: true)
    }
    
    newModel.addInput(Input(name: "data_in", shape: [1]))
    
    newModel.addTrainingInput(TrainingInput(name: "data_in", shape: [1]))
    newModel.addTrainingInput(TrainingInput(name: "output_true", shape: [1]))
    
    newModel.addOutput(Output(name: "data_out", shape: [1]))
    
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip1", input: ["data_in"], output: ["ip1_out"], inputChannels: 1, outputChannels: 8, updatable: true))
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip2", input: ["ip1_out"], output: ["ip2_out"], inputChannels: 8, outputChannels: 8, updatable: true))
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip3", input: ["ip2_out"], output: ["ip3_out"], inputChannels: 8, outputChannels: 1, updatable: true))
    newModel.neuralNetwork.addLayer(Softmax(name: "softmax", input: ["ip3_out"], output: ["data_out"]))
    
    return newModel
}

func writeModelFile(modelURL: URL, model: Model) {
    try! model.coreMLData!.write(to: modelURL)
}

writeModelFile(modelURL: makeModelURL(), model: prepareModel())
