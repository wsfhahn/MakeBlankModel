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
    var newModel = Model(version: 4, author: "William Hahn", license: "MIT")
    
    newModel.addInput(Input(name: "data_in", shape: [1]))
    newModel.addTrainingInput(TrainingInput(name: "training_data_in", shape: [1]))
    newModel.addOutput(Output(name: "data_out", shape: [1]))
    
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip1", input: ["data_in"], output: ["ip1_out"], inputChannels: 1, outputChannels: 8, updatable: true))
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip2", input: ["ip1_out"], output: ["ip2_out"], inputChannels: 8, outputChannels: 8, updatable: true))
    newModel.neuralNetwork.addLayer(InnerProduct(name: "ip3", input: ["ip2_out"], output: ["data_out"], inputChannels: 8, outputChannels: 1, updatable: true))
    
    return newModel
}

func writeModelFile(modelURL: URL, model: Model) {
    try! model.coreMLData!.write(to: modelURL)
}

writeModelFile(modelURL: makeModelURL(), model: prepareModel())
