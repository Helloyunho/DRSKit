import Foundation

// MARK: - Seq9

public struct Seq9: Codable {
    // MARK: - DataClass

    public struct SeqData: Codable {
        // MARK: - ExtendData

        public struct ExtendData: Codable {
            // MARK: - Extend

            public struct Extend: Codable {
                public enum TypeEnum: String, Codable {
                    case vfx = "Vfx"
                }

                public let type: TypeEnum
                public let tick: Int32
                public let param: Param

                // MARK: - Param

                public struct Param: Codable {
                    public enum Kind: String, Codable {
                        case background = "Background"
                        case overEffect = "OverEffect"
                    }

                    // MARK: - Color

                    public struct Color: Codable {
                        public let red, green, blue: Int32

                        public init(red: Int32, green: Int32, blue: Int32) {
                            self.red = red
                            self.green = green
                            self.blue = blue
                        }
                    }

                    public let time: Int32
                    public let kind: Kind
                    public let layerName: String
                    public let id, lane, speed: Int32
                    public let color: Color?

                    public enum CodingKeys: String, CodingKey {
                        case time, kind
                        case layerName = "layer_name"
                        case id, lane, speed, color
                    }

                    public init(
                        time: Int32, kind: Kind, layerName: String, id: Int32,
                        lane: Int32, speed: Int32, color: Color?
                    ) {
                        self.time = time
                        self.kind = kind
                        self.layerName = layerName
                        self.id = id
                        self.lane = lane
                        self.speed = speed
                        self.color = color
                    }
                }

                public init(type: TypeEnum, tick: Int32, param: Param) {
                    self.type = type
                    self.tick = tick
                    self.param = param
                }
            }

            public let extend: [Extend]

            public init(extend: [Extend]) {
                self.extend = extend
            }
        }

        // MARK: - Info

        public struct Info: Codable {
            // MARK: - BPMInfo

            public struct BPMInfo: Codable {
                // MARK: - BPM

                public struct BPM: Codable {
                    public let tick, bpm: Int32

                    public init(tick: Int32, bpm: Int32) {
                        self.tick = tick
                        self.bpm = bpm
                    }
                }

                public let bpm: [BPM]

                public init(bpm: [BPM]) {
                    self.bpm = bpm
                }
            }

            // MARK: - MeasureInfo

            public struct MeasureInfo: Codable {
                // MARK: - Measure

                public struct Measure: Codable {
                    public let tick, num, denomi: Int32

                    public init(tick: Int32, num: Int32, denomi: Int32) {
                        self.tick = tick
                        self.num = num
                        self.denomi = denomi
                    }
                }

                public let measure: [Measure]

                public init(measure: [Measure]) {
                    self.measure = measure
                }
            }

            public let timeUnit, endTick: Int32
            public let bpmInfo: BPMInfo
            public let measureInfo: MeasureInfo

            public enum CodingKeys: String, CodingKey {
                case timeUnit = "time_unit"
                case endTick = "end_tick"
                case bpmInfo = "bpm_info"
                case measureInfo = "measure_info"
            }

            public init(
                timeUnit: Int32, endTick: Int32, bpmInfo: BPMInfo,
                measureInfo: MeasureInfo
            ) {
                self.timeUnit = timeUnit
                self.endTick = endTick
                self.bpmInfo = bpmInfo
                self.measureInfo = measureInfo
            }
        }

        // MARK: - RecData

        public struct RecData: Codable {
            // MARK: - Clip

            public struct Clip: Codable {
                public let startTime, endTime: Int32

                public enum CodingKeys: String, CodingKey {
                    case startTime = "start_time"
                    case endTime = "end_time"
                }

                public init(startTime: Int32, endTime: Int32) {
                    self.startTime = startTime
                    self.endTime = endTime
                }
            }

            // MARK: - Effect

            public struct Effect: Codable {
                public enum Command: String, Codable {
                    case ndwnc1 = "Ndwnc1"
                    case njmpcs = "Njmpcs"
                    case ntapcl = "Ntapcl"
                    case ntapcs = "Ntapcs"
                    case ntapll = "Ntapll"
                    case ntapls = "Ntapls"
                    case ntaprl = "Ntaprl"
                    case ntaprs = "Ntaprs"
                    case nsldlr1 = "Nsldlr1"
                    case nsldrl1 = "Nsldrl1"
                    case ndwnl1 = "Ndwnl1"
                    case ndwnr1 = "Ndwnr1"
                    case nsftl2 = "Nsftl2"
                    case nsftr2 = "Nsftr2"
                    case nsldcl1 = "Nsldcl1"
                    case nsldcr1 = "Nsldcr1"
                }

                public let tick, time: Int32
                public let command: Command

                public init(tick: Int32, time: Int32, command: Command) {
                    self.tick = tick
                    self.time = time
                    self.command = command
                }
            }

            public let clip: Clip
            public let effect: [Effect]

            public init(clip: Clip, effect: [Effect]) {
                self.clip = clip
                self.effect = effect
            }
        }

        // MARK: - SequenceData

        public struct SequenceData: Codable {
            // MARK: - Step

            public struct Step: Codable {
                // MARK: - LongPoint

                public struct LongPoint: Codable {
                    // MARK: - Point

                    public struct Point: Codable {
                        public let tick, leftPos, rightPos: Int32
                        public let leftEndPos, rightEndPos: Int32?

                        public enum CodingKeys: String, CodingKey {
                            case tick
                            case leftPos = "left_pos"
                            case rightPos = "right_pos"
                            case leftEndPos = "left_end_pos"
                            case rightEndPos = "right_end_pos"
                        }

                        public init(
                            tick: Int32, leftPos: Int32, rightPos: Int32,
                            leftEndPos: Int32?, rightEndPos: Int32?
                        ) {
                            self.tick = tick
                            self.leftPos = leftPos
                            self.rightPos = rightPos
                            self.leftEndPos = leftEndPos
                            self.rightEndPos = rightEndPos
                        }
                    }

                    public let point: [Point]

                    public init(point: [Point]) {
                        self.point = point
                    }
                }

                public enum Kind: Int32, Codable {
                    case left = 1
                    case right = 2
                    case down = 3
                    case jump = 4
                }

                public let startTick, endTick, leftPos, rightPos: Int32
                public let kind: Kind
                public let playerID: Int32
                public let longPoint: LongPoint?

                public enum CodingKeys: String, CodingKey {
                    case startTick = "start_tick"
                    case endTick = "end_tick"
                    case leftPos = "left_pos"
                    case rightPos = "right_pos"
                    case kind
                    case playerID = "player_id"
                    case longPoint = "long_point"
                }

                public init(
                    startTick: Int32, endTick: Int32, leftPos: Int32,
                    rightPos: Int32, kind: Kind, playerID: Int32,
                    longPoint: LongPoint?
                ) {
                    self.startTick = startTick
                    self.endTick = endTick
                    self.leftPos = leftPos
                    self.rightPos = rightPos
                    self.kind = kind
                    self.playerID = playerID
                    self.longPoint = longPoint
                }
            }

            public let step: [Step]

            public init(step: [Step]) {
                self.step = step
            }
        }

        public var seqVersion: Int32 = 9
        public let info: Info
        public let sequenceData: SequenceData
        public let extendData: ExtendData
        public let recData: RecData

        public enum CodingKeys: String, CodingKey {
            case seqVersion = "seq_version"
            case info
            case sequenceData = "sequence_data"
            case extendData = "extend_data"
            case recData = "rec_data"
        }

        public init(
            info: Info, sequenceData: SequenceData,
            extendData: ExtendData, recData: RecData
        ) {
            self.info = info
            self.sequenceData = sequenceData
            self.extendData = extendData
            self.recData = recData
        }
    }

    public let data: SeqData

    public init(data: SeqData) {
        self.data = data
    }
}
