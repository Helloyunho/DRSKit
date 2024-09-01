import ArgumentParser
import Foundation
import XMLCoder
import DRSKit
import DRSXMLImporter

@main
struct ReadDRSSwift: ParsableCommand {
    @Argument(
        help: "XML(or JSON) file path",
        completion: .file(extensions: ["xml", "json"]),
        transform: URL.init(fileURLWithPath:))
    var xmlFile: URL!

    func timeToTick(_ time: Int64, tick: Int32) -> Int32 {
        let t = Int32(truncatingIfNeeded: time)
        let div = t / tick + 1
        return tick * div
    }

    func run() throws {
        let result: Seq

        result = try Seq.importXML(xmlFile)

        print(result)
        
        var copy = xmlFile!
        copy.deleteLastPathComponent()
        copy.appendPathComponent("test.xml")
        
        try result.exportXML(copy)
        print("done")
    }
}
