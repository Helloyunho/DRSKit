import Foundation

public struct Int32WithType: Codable {
    public let __type = "s32"
    public let value: Int32
    
    public enum CodingKeys: String, CodingKey {
        case __type
        case value = ""
    }
    
    init(_ value: Int32) {
        self.value = value
    }
}

public struct StringWithType: Codable {
    public let __type = "str"
    public let value: String
    
    public enum CodingKeys: String, CodingKey {
        case __type
        case value = ""
    }
    
    init(_ value: String) {
        self.value = value
    }
}

// MARK: - Seq9

public struct Seq9: Codable {
    // MARK: - DataClass

    public struct SeqData: Codable {
        // MARK: - ExtendData

        public struct ExtendData: Codable {
            // MARK: - Extend

            public struct Extend: Codable {
                public let type: StringWithType
                public let tick: Int32WithType
                public let param: Param

                // MARK: - Param

                public struct Param: Codable {
                    // MARK: - Color

                    public struct Color: Codable {
                        public let red, green, blue: Int32WithType

                        public init(red: Int32, green: Int32, blue: Int32) {
                            self.red = Int32WithType(red)
                            self.green = Int32WithType(green)
                            self.blue = Int32WithType(blue)
                        }
                    }

                    public let time: Int32WithType
                    public let kind: StringWithType
                    public let layerName: StringWithType
                    public let id, lane, speed: Int32WithType
                    public let color: Color?

                    public enum CodingKeys: String, CodingKey {
                        case time, kind
                        case layerName = "layer_name"
                        case id, lane, speed, color
                    }

                    public init(
                        time: Int32, kind: String, layerName: String, id: Int32,
                        lane: Int32, speed: Int32, color: Color?
                    ) {
                        self.time = Int32WithType(time)
                        self.kind = StringWithType(kind)
                        self.layerName = StringWithType(layerName)
                        self.id = Int32WithType(id)
                        self.lane = Int32WithType(lane)
                        self.speed = Int32WithType(speed)
                        self.color = color
                    }
                }

                public init(type: String, tick: Int32, param: Param) {
                    self.type = StringWithType(type)
                    self.tick = Int32WithType(tick)
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
                    public let tick, bpm: Int32WithType

                    public init(tick: Int32, bpm: Int32) {
                        self.tick = Int32WithType(tick)
                        self.bpm = Int32WithType(bpm)
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
                    public let tick, num, denomi: Int32WithType

                    public init(tick: Int32, num: Int32, denomi: Int32) {
                        self.tick = Int32WithType(tick)
                        self.num = Int32WithType(num)
                        self.denomi = Int32WithType(denomi)
                    }
                }

                public let measure: [Measure]

                public init(measure: [Measure]) {
                    self.measure = measure
                }
            }

            public let timeUnit, endTick: Int32WithType
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
                self.timeUnit = Int32WithType(timeUnit)
                self.endTick = Int32WithType(endTick)
                self.bpmInfo = bpmInfo
                self.measureInfo = measureInfo
            }
        }

        // MARK: - RecData

        public struct RecData: Codable {
            // MARK: - Clip

            public struct Clip: Codable {
                public let startTime, endTime: Int32WithType

                public enum CodingKeys: String, CodingKey {
                    case startTime = "start_time"
                    case endTime = "end_time"
                }

                public init(startTime: Int32, endTime: Int32) {
                    self.startTime = Int32WithType(startTime)
                    self.endTime = Int32WithType(endTime)
                }
            }

            // MARK: - Effect

            public struct Effect: Codable {
                public let tick, time: Int32WithType
                public let command: StringWithType

                public init(tick: Int32, time: Int32, command: String) {
                    self.tick = Int32WithType(tick)
                    self.time = Int32WithType(time)
                    self.command = StringWithType(command)
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
                        public let tick, leftPos, rightPos: Int32WithType
                        public let leftEndPos, rightEndPos: Int32WithType?

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
                            self.tick = Int32WithType(tick)
                            self.leftPos = Int32WithType(leftPos)
                            self.rightPos = Int32WithType(rightPos)
                            self.leftEndPos = leftEndPos != nil ? Int32WithType(leftEndPos!) : nil
                            self.rightEndPos = rightEndPos != nil ? Int32WithType(rightEndPos!) : nil
                        }
                    }

                    public let point: [Point]

                    public init(point: [Point]) {
                        self.point = point
                    }
                }

                public let startTick, endTick, leftPos, rightPos, kind, playerID: Int32WithType
                public let longPoint: LongPoint

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
                    rightPos: Int32, kind: Int32, playerID: Int32,
                    longPoint: LongPoint
                ) {
                    self.startTick = Int32WithType(startTick)
                    self.endTick = Int32WithType(endTick)
                    self.leftPos = Int32WithType(leftPos)
                    self.rightPos = Int32WithType(rightPos)
                    self.kind = Int32WithType(kind)
                    self.playerID = Int32WithType(playerID)
                    self.longPoint = longPoint
                }
            }

            public let step: [Step]

            public init(step: [Step]) {
                self.step = step
            }
        }

        public var seqVersion: Int32WithType = .init(9)
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
