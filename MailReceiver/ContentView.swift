//
//  ContentView.swift
//  MailReceiver
//
//  Created by Andreas Bentele on 04.09.25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var dropMessage = "Drag an email here"

    let dropDelegate = EmailDropDelegate()

    var body: some View {
        VStack {
            Text(dropMessage)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)
                .onDrop(of: [.emailMessage], delegate: dropDelegate)
        }
        .padding()
    }
}

struct EmailDropDelegate: DropDelegate
{
    
    func validateDrop(info: DropInfo) -> Bool
    {
        return true
    }
    
    func dropEntered(info: DropInfo)
    {
        print ("Drop Entered")
    }
    
    func performDrop(info: DropInfo) -> Bool {
        
        
        let pasteboard = NSPasteboard(name: .drag)
        
        guard let filePromises = pasteboard.readObjects(forClasses: [NSFilePromiseReceiver.self], options: nil) else { return false }
        guard let receiver = filePromises.first as? NSFilePromiseReceiver else { return false }
        let dispatchGroup = DispatchGroup()
        let queue = OperationQueue()
        let destUrl = URL.downloadsDirectory
        dispatchGroup.enter()
        
        var urls: [URL] = []
        receiver.receivePromisedFiles(atDestination: destUrl, operationQueue: queue) { (url, error) in
            
            if let error = error {
                print(error)
            } else {
                urls.append(url)
            }
            
            print(receiver.fileNames, receiver.fileTypes)
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            print(urls)
        })
        
        return true
    }
    
}

#Preview {
    ContentView()
}
