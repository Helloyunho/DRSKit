import ArgumentParser
import Foundation
import XMLCoder
import DRSKit

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

    func convertTo9(from: Seq8.SeqData) -> Seq9.SeqData {
        Seq9.SeqData(
            info: Seq9.SeqData.Info(
                timeUnit: from.info.tick,
                endTick: from.gridData.grid.last!.etimeDt,
                bpmInfo: Seq9.SeqData.Info.BPMInfo(
                    bpm: from.info.bpmInfo.bpm.map({
                        Seq9.SeqData.Info.BPMInfo.BPM(
                            tick: $0.time,
                            bpm: $0.bpm)
                    })),
                measureInfo: Seq9.SeqData.Info.MeasureInfo(
                    measure: from.info.measureInfo.measure.map({
                        Seq9.SeqData.Info.MeasureInfo.Measure(
                            tick: $0.time,
                            num: $0.num,
                            denomi: $0.denomi)
                    }))),
            sequenceData: Seq9.SeqData.SequenceData(
                step: from.sequenceData.step.map {
                    old -> Seq9.SeqData.SequenceData.Step in
                    .init(
                        startTick: old.stimeDt, endTick: old.etimeDt,
                        leftPos: old.posLeft, rightPos: old.posRight,
                        kind: Seq9.SeqData.SequenceData.Step.Kind(
                            rawValue: old.kind.rawValue)!,
                        playerID: old.playerID,
                        longPoint: old.longPoint != nil
                            ? Seq9.SeqData.SequenceData.Step.LongPoint(
                                point: old.longPoint!.point.map {
                                    old
                                        -> Seq9.SeqData.SequenceData.Step
                                        .LongPoint.Point in
                                    .init(
                                        tick: self.timeToTick(
                                            old.pointTime, tick: from.info.tick),
                                        leftPos: old.posLeft,
                                        rightPos: old.posRight,
                                        leftEndPos: old.posLend,
                                        rightEndPos: old.posRend)
                                }) : nil)
                }), extendData: Seq9.SeqData.ExtendData(extend: []),
            recData: Seq9.SeqData.RecData(
                clip: Seq9.SeqData.RecData.Clip(
                    startTime: Int32(
                        truncatingIfNeeded: from.recData.clip.last!.stimeMS),
                    endTime: Int32(
                        truncatingIfNeeded: from.recData.clip.last!.etimeMS)),
                effect: from.recData.effect.map {
                    old -> Seq9.SeqData.RecData.Effect in
                    .init(
                        tick: self.timeToTick(old.time, tick: from.info.tick),
                        time: Int32(truncatingIfNeeded: old.time),
                        command: Seq9.SeqData.RecData.Effect.Command(
                            rawValue: old.command) ?? .ndwnc1)
                }))
    }

    func run() throws {
        let data = try Data(contentsOf: xmlFile)
        let result: Seq9.SeqData

        if data.starts(with: [0xEF, 0xBB, 0xBF, 0x3C, 0x3F]) {  // <?xml
            let decoder = XMLDecoder()
            let decoded = try decoder.decode(SeqOrig.SeqData.self, from: data)
            switch decoded.version {
            case 8:
                let allDecoded = try decoder.decode(
                    Seq8.SeqData.self, from: data)
                result = convertTo9(from: allDecoded)
            case 9:
                result = try decoder.decode(Seq9.SeqData.self, from: data)
            default:
                fatalError("Unknown version detected.")
            }
        } else {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(SeqOrig.self, from: data)
            switch decoded.data.version {
            case 8:
                let allDecoded = try decoder.decode(Seq8.self, from: data)
                result = convertTo9(from: allDecoded.data)
            case 9:
                result = try (decoder.decode(Seq9.self, from: data)).data
            default:
                fatalError("Unknown version detected.")
            }
        }

        print(Seq.parseFromSeq9(Seq9(data: result)))
    }
}
