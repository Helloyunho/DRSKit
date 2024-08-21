//
//  Seq.swift
//  read-drs-swift
//
//  Created by Helloyunho on 2024/8/20.
//

public struct Seq {
    public let version = 9
    static public let defaultTick: Int32 = 480

    public struct Info {
        public var timeUnit, endTick: Int32

        public struct BPM {
            public var tick, bpm: Int32
            
            public init(tick: Int32, bpm: Int32) {
                self.tick = tick
                self.bpm = bpm
            }
        }
        public var bpm: [BPM]

        public struct Measure {
            public var tick, num, denominator: Int32
            
            public init(tick: Int32, num: Int32, denominator: Int32) {
                self.tick = tick
                self.num = num
                self.denominator = denominator
            }
        }
        public var measure: [Measure]
        
        public init(timeUnit: Int32, endTick: Int32, bpm: [BPM], measure: [Measure]) {
            self.timeUnit = timeUnit
            self.endTick = endTick
            self.bpm = bpm
            self.measure = measure
        }
    }
    public var info: Info

    public struct Extend {
        public var tick: Int32

        public enum TypeEnum: String {
            case Vfx
        }
        public var type: TypeEnum

        public struct Param {
            public var layerName: String
            public var time, id, lane, speed: Int32

            public enum Kind: String {
                case Background
                case OverEffect
            }
            public var kind: Kind

            public struct Color {
                public var r, g, b: Int32
                
                public init(r: Int32, g: Int32, b: Int32) {
                    self.r = r
                    self.g = g
                    self.b = b
                }
            }
            public var color: Color?
            
            public init(layerName: String, time: Int32, id: Int32, lane: Int32, speed: Int32, kind: Kind, color: Color? = nil) {
                self.layerName = layerName
                self.time = time
                self.id = id
                self.lane = lane
                self.speed = speed
                self.kind = kind
                self.color = color
            }
        }
        public var param: Param
        
        public init(tick: Int32, type: TypeEnum, param: Param) {
            self.tick = tick
            self.type = type
            self.param = param
        }
    }
    public var extends: [Extend]

    public struct Rec {
        public struct Clip {
            public var startTime, endTime: Int32
            
            public init(startTime: Int32, endTime: Int32) {
                self.startTime = startTime
                self.endTime = endTime
            }
        }
        public var clip: Clip

        public struct Effect {
            public var tick, time: Int32

            public enum Command: String {
                case Ndwnc1
                case Njmpcs
                case Ntapcl
                case Ntapcs
                case Ntapll
                case Ntapls
                case Ntaprl
                case Ntaprs
                case Nsldlr1
                case Nsldrl1
                case Ndwnl1
                case Ndwnr1
                case Nsftl2
                case Nsftr2
                case Nsldcl1
                case Nsldcr1
            }
            public var command: Command
            
            public init(tick: Int32, time: Int32, command: Command) {
                self.tick = tick
                self.time = time
                self.command = command
            }
        }
        public var effects: [Effect]
        
        public init(clip: Clip, effects: [Effect]) {
            self.clip = clip
            self.effects = effects
        }
    }
    public var rec: Rec

    public struct Step {
        public var startTick, endTick, leftPos, rightPos: Int32

        public struct LongPoint {
            public var tick, leftPos, rightPos: Int32
            public var leftEndPos, rightEndPos: Int32?
            
            public init(tick: Int32, leftPos: Int32, rightPos: Int32, leftEndPos: Int32? = nil, rightEndPos: Int32? = nil) {
                self.tick = tick
                self.leftPos = leftPos
                self.rightPos = rightPos
                self.leftEndPos = leftEndPos
                self.rightEndPos = rightEndPos
            }
        }
        public var longPoints: [LongPoint]

        public enum Kind: Int32 {
            case left = 1
            case right, down, jump
        }
        public var kind: Kind

        public enum PlayerID: Int32 {
            case Player1, Player2, dummy1, dummy2, dummy3
        }
        public var playerID: PlayerID
        
        public init(startTick: Int32, endTick: Int32, leftPos: Int32, rightPos: Int32, longPoints: [LongPoint], kind: Kind, playerID: PlayerID) {
            self.startTick = startTick
            self.endTick = endTick
            self.leftPos = leftPos
            self.rightPos = rightPos
            self.longPoints = longPoints
            self.kind = kind
            self.playerID = playerID
        }
    }
    public var steps: [Step]

    public static func timeToTick(_ time: Int32, tick: Int32) -> Int32 {
        let div = time / tick + 1
        return tick * div
    }

    public init(info: Info, extends: [Extend], rec: Rec, steps: [Step]) {
        self.info = info
        self.extends = extends
        self.rec = rec
        self.steps = steps
    }

    public init(end: Int32, bpm: Float32) {
        self.init(end: end, bpm: bpm, num: 4, denominator: 4)
    }

    public init(end: Int32, bpm: Float32, tickUnit: Int32) {
        self.init(
            end: end, bpm: bpm, num: 4, denominator: 4, tickUnit: tickUnit)
    }

    public init(end: Int32, bpm: Float32, num: Int32, denominator: Int32) {
        self.init(
            end: end, bpm: bpm, num: num, denominator: denominator,
            tickUnit: Seq.defaultTick)
    }

    public init(
        end: Int32, bpm: Float32, num: Int32, denominator: Int32,
        tickUnit: Int32
    ) {
        let endTick = Seq.timeToTick(end, tick: tickUnit)
        let info = Info(
            timeUnit: tickUnit, endTick: endTick,
            bpm: [Info.BPM(tick: 0, bpm: Int32((bpm * 100).rounded()))],
            measure: [Info.Measure(tick: 0, num: num, denominator: denominator)]
        )
        let extends: [Extend] = []
        let rec = Rec(
            clip: Rec.Clip(startTime: 0, endTime: endTick), effects: [])
        let step: [Step] = []
        self.init(info: info, extends: extends, rec: rec, steps: step)
    }
}
