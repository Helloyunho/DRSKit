//
//  Seq+Convert.swift
//  read-drs-swift
//
//  Created by Helloyunho on 2024/8/21.
//

import Foundation

extension Seq {
    public static func parseFromSeq9(_ seq: Seq9) -> Seq {
        let seqData = seq.data

        let infoOrig = seqData.info
        let info = Seq.Info(
            timeUnit: infoOrig.timeUnit.value,
            endTick: infoOrig.endTick.value,
            bpm: infoOrig.bpmInfo.bpm.map({
                Info.BPM(tick: $0.tick.value, bpm: $0.bpm.value)
            }),
            measure: infoOrig.measureInfo.measure.map({
                Info.Measure(tick: $0.tick.value, num: $0.num.value, denominator: $0.denomi.value)
            })
        )

        let extendOrig = seqData.extendData.extend
        let extends = extendOrig.map({ ext in
            return Seq.Extend(
                tick: ext.tick.value,
                type: Extend.TypeEnum(rawValue: ext.type.value)!,
                param: Extend.Param(
                    layerName: ext.param.layerName.value, time: ext.param.time.value,
                    id: ext.param.id.value, lane: ext.param.lane.value,
                    speed: ext.param.speed.value,
                    kind: Extend.Param.Kind(rawValue: ext.param.kind.value)!,
                    color: (ext.param.color != nil)
                        ? Extend.Param.Color(
                            r: ext.param.color!.red.value, g: ext.param.color!.green.value,
                            b: ext.param.color!.blue.value) : nil)
            )
        })

        let recClipOrig = seqData.recData.clip
        let recClip = Rec.Clip(
            startTime: recClipOrig.startTime.value, endTime: recClipOrig.endTime.value)
        let recEffectsOrig = seqData.recData.effect
        let recEffects: [Rec.Effect] = recEffectsOrig.map({
            Rec.Effect(
                tick: $0.tick.value, time: $0.time.value,
                command: Rec.Effect.Command(rawValue: $0.command.value)!)
        })
        let rec = Rec(clip: recClip, effects: recEffects)

        let stepsOrig = seqData.sequenceData.step
        let steps: [Step] = stepsOrig.map({ step in
            return Step(
                startTick: step.startTick.value,
                endTick: step.endTick.value,
                leftPos: step.leftPos.value,
                rightPos: step.rightPos.value,
                longPoints: step.longPoint.point.map({
                    Step.LongPoint(
                        tick: $0.tick.value, leftPos: $0.leftPos.value,
                        rightPos: $0.rightPos.value, leftEndPos: $0.leftEndPos?.value,
                        rightEndPos: $0.rightEndPos?.value)
                }),
                kind: Step.Kind(rawValue: step.kind.value)!,
                playerID: Step.PlayerID(rawValue: step.playerID.value)!
            )
        })

        return Seq(info: info, extends: extends, rec: rec, steps: steps)
    }

    public func convertToSeq9() -> Seq9 {
        let info = Seq9.SeqData.Info(
            timeUnit: info.timeUnit,
            endTick: info.endTick,
            bpmInfo: Seq9.SeqData.Info.BPMInfo(
                bpm: info.bpm.map({
                    Seq9.SeqData.Info.BPMInfo.BPM(tick: $0.tick, bpm: $0.bpm)
                })),
            measureInfo: Seq9.SeqData.Info.MeasureInfo(
                measure: info.measure.map({
                    Seq9.SeqData.Info.MeasureInfo.Measure(
                        tick: $0.tick, num: $0.num, denomi: $0.denominator)
                }))
        )

        let extendData = Seq9.SeqData.ExtendData(
            extend: extends.map({ ext in
                return Seq9.SeqData.ExtendData.Extend(
                    type: ext.type.rawValue, tick: ext.tick,
                    param: Seq9.SeqData.ExtendData.Extend.Param(
                        time: ext.param.time,
                        kind: ext.param.kind.rawValue,
                        layerName: ext.param.layerName,
                        id: ext.param.id, lane: ext.param.lane,
                        speed: ext.param.speed,

                        color: (ext.param.color != nil)
                            ? Seq9.SeqData.ExtendData.Extend.Param.Color(
                                red: ext.param.color!.r,
                                green: ext.param.color!.g,
                                blue: ext.param.color!.b) : nil)
                )
            }))

        let recData = Seq9.SeqData.RecData(
            clip: Seq9.SeqData.RecData.Clip(
                startTime: rec.clip.startTime, endTime: rec.clip.endTime),
            effect: rec.effects.map({
                Seq9.SeqData.RecData.Effect(
                    tick: $0.tick, time: $0.time,
                    command: $0.command.rawValue)
            })
        )

        let seqData = Seq9.SeqData.SequenceData(
            step: steps.map({ step in
                return Seq9.SeqData.SequenceData.Step(
                    startTick: step.startTick,
                    endTick: step.endTick,
                    leftPos: step.leftPos,
                    rightPos: step.rightPos,
                    kind: step.kind.rawValue,
                    playerID: step.playerID.rawValue,
                    longPoint: Seq9.SeqData.SequenceData.Step.LongPoint(
                        point: step.longPoints.map({ point in
                            return Seq9.SeqData.SequenceData.Step.LongPoint
                                .Point(
                                    tick: point.tick,
                                    leftPos: point.leftPos,
                                    rightPos: point.rightPos,
                                    leftEndPos: point.leftEndPos,
                                    rightEndPos: point.rightEndPos)
                        }))
                )
            }))

        return Seq9(
            data: Seq9.SeqData(
                info: info, sequenceData: seqData, extendData: extendData,
                recData: recData))
    }

    public static func convert8To9(from: Seq8.SeqData) -> Seq9.SeqData {
        func timeToTick(_ time: Int64, tick: Int32) -> Int32 {
            let t = Int32(truncatingIfNeeded: time)
            let div = t / tick + 1
            return tick * div
        }

        return Seq9.SeqData(
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
                        kind: old.kind.rawValue,
                        playerID: old.playerID,
                        longPoint: Seq9.SeqData.SequenceData.Step.LongPoint(
                            point: old.longPoint.point.map {
                                old
                                    -> Seq9.SeqData.SequenceData.Step
                                    .LongPoint.Point in
                                .init(
                                    tick: timeToTick(
                                        old.pointTime, tick: from.info.tick),
                                    leftPos: old.posLeft,
                                    rightPos: old.posRight,
                                    leftEndPos: old.posLend,
                                    rightEndPos: old.posRend)
                            }))
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
                        tick: timeToTick(old.time, tick: from.info.tick),
                        time: Int32(truncatingIfNeeded: old.time),
                        command: old.command)
                }))
    }
}
