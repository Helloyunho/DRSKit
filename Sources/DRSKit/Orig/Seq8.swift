import Foundation

// MARK: - Seq8

public struct Seq8: Codable {
    // MARK: - SeqData

    public struct SeqData: Codable {
        // MARK: - GridData

        public struct GridData: Codable {
            // MARK: - Grid

            public struct Grid: Codable {
                public enum GridType: Int32, Codable {
                    case measure = 2
                    case beat = 1
                }

                public let stimeMS, etimeMS: Int64
                public let stimeDt, etimeDt: Int32
                public let type: GridType

                public enum CodingKeys: String, CodingKey {
                    case stimeMS = "stime_ms"
                    case etimeMS = "etime_ms"
                    case stimeDt = "stime_dt"
                    case etimeDt = "etime_dt"
                    case type
                }

                public init(
                    stimeMS: Int64, etimeMS: Int64, stimeDt: Int32,
                    etimeDt: Int32, type: GridType
                ) {
                    self.stimeMS = stimeMS
                    self.etimeMS = etimeMS
                    self.stimeDt = stimeDt
                    self.etimeDt = etimeDt
                    self.type = type
                }
            }

            public let grid: [Grid]

            public init(grid: [Grid]) {
                self.grid = grid
            }
        }

        // MARK: - Info

        public struct Info: Codable {
            // MARK: - BPMInfo

            public struct BPMInfo: Codable {
                // MARK: - BPM

                public struct BPM: Codable {
                    public let time, deltaTime: Int32
                    public let bpm: Int32
                    /// 135.00 -> 13500

                    public enum CodingKeys: String, CodingKey {
                        case time
                        case deltaTime = "delta_time"
                        case bpm
                    }

                    public init(time: Int32, deltaTime: Int32, bpm: Int32) {
                        self.time = time
                        self.deltaTime = deltaTime
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
                    public let time, deltaTime, num, denomi: Int32

                    public enum CodingKeys: String, CodingKey {
                        case time
                        case deltaTime = "delta_time"
                        case num, denomi
                    }

                    public init(
                        time: Int32, deltaTime: Int32, num: Int32, denomi: Int32
                    ) {
                        self.time = time
                        self.deltaTime = deltaTime
                        self.num = num
                        self.denomi = denomi
                    }
                }

                public let measure: [Measure]

                public init(measure: [Measure]) {
                    self.measure = measure
                }
            }

            public let tick: Int32
            public let bpmInfo: BPMInfo
            public let measureInfo: MeasureInfo

            public enum CodingKeys: String, CodingKey {
                case tick
                case bpmInfo = "bpm_info"
                case measureInfo = "measure_info"
            }

            public init(tick: Int32, bpmInfo: BPMInfo, measureInfo: MeasureInfo)
            {
                self.tick = tick
                self.bpmInfo = bpmInfo
                self.measureInfo = measureInfo
            }
        }

        // MARK: - MotionData

        public struct MotionData: Codable {
            // MARK: - Motion

            public struct Motion: Codable {
                public let time: Int64
                public let category, kind: Int32
                public let player: Int32?
                public let val1, val2: Int32
                public let command: String
                public let val3: Int32?

                public init(
                    time: Int64, category: Int32, kind: Int32, player: Int32?,
                    val1: Int32, val2: Int32, command: String, val3: Int32?
                ) {
                    self.time = time
                    self.category = category
                    self.kind = kind
                    self.player = player
                    self.val1 = val1
                    self.val2 = val2
                    self.command = command
                    self.val3 = val3
                }
            }

            public let motion: [Motion]

            public init(motion: [Motion]) {
                self.motion = motion
            }
        }

        // MARK: - RecData

        public struct RecData: Codable {
            public struct Effect: Codable {
                public let time: Int64
                public var category: Int32 = 1
                public let kind: Int32
                public let val1: Int32
                public let val2: Int32
                public let val3: Int32
                public let command: String

                public init(
                    time: Int64, category: Int32, kind: Int32, val1: Int32,
                    val2: Int32, val3: Int32, command: String
                ) {
                    self.time = time
                    self.category = category
                    self.kind = kind
                    self.val1 = val1
                    self.val2 = val2
                    self.val3 = val3
                    self.command = command
                }
            }

            // MARK: - Clip

            public struct Clip: Codable {
                public let id: Int32
                public let stimeMS, etimeMS: Int64

                public enum CodingKeys: String, CodingKey {
                    case id
                    case stimeMS = "stime_ms"
                    case etimeMS = "etime_ms"
                }

                public init(id: Int32, stimeMS: Int64, etimeMS: Int64) {
                    self.id = id
                    self.stimeMS = stimeMS
                    self.etimeMS = etimeMS
                }
            }

            public let clip: [Clip]
            public let effect: [Effect]

            public init(clip: [Clip], effect: [Effect]) {
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
                        public let pointTime: Int64
                        public let posLeft, posRight: Int32
                        public let posLend, posRend: Int32?

                        public enum CodingKeys: String, CodingKey {
                            case pointTime = "point_time"
                            case posLeft = "pos_left"
                            case posRight = "pos_right"
                            case posLend = "pos_lend"
                            case posRend = "pos_rend"
                        }

                        public init(
                            pointTime: Int64, posLeft: Int32, posRight: Int32,
                            posLend: Int32?, posRend: Int32?
                        ) {
                            self.pointTime = pointTime
                            self.posLeft = posLeft
                            self.posRight = posRight
                            self.posLend = posLend
                            self.posRend = posRend
                        }
                    }

                    public let point: [Point]

                    public init(point: [Point]) {
                        self.point = point
                    }
                }

                public enum Category: Int32, Codable {
                    case short = 0
                    case long = 1
                }

                public enum Kind: Int32, Codable {
                    case left = 1
                    case right = 2
                    case down = 3
                    case jump = 4
                }

                public let stimeMS, etimeMS: Int64
                public let stimeDt, etimeDt: Int32
                public let category: Category
                public let posLeft, posRight: Int32
                public let kind: Kind
                public let stepVar, playerID: Int32
                public let longPoint: LongPoint?

                public enum CodingKeys: String, CodingKey {
                    case stimeMS = "stime_ms"
                    case etimeMS = "etime_ms"
                    case stimeDt = "stime_dt"
                    case etimeDt = "etime_dt"
                    case category
                    case posLeft = "pos_left"
                    case posRight = "pos_right"
                    case kind
                    case stepVar = "var"
                    case playerID = "player_id"
                    case longPoint = "long_point"
                }

                public init(
                    stimeMS: Int64, etimeMS: Int64, stimeDt: Int32,
                    etimeDt: Int32, category: Category, posLeft: Int32,
                    posRight: Int32, kind: Kind, stepVar: Int32,
                    playerID: Int32, longPoint: LongPoint?
                ) {
                    self.stimeMS = stimeMS
                    self.etimeMS = etimeMS
                    self.stimeDt = stimeDt
                    self.etimeDt = etimeDt
                    self.category = category
                    self.posLeft = posLeft
                    self.posRight = posRight
                    self.kind = kind
                    self.stepVar = stepVar
                    self.playerID = playerID
                    self.longPoint = longPoint
                }
            }

            public let step: [Step]

            public init(step: [Step]) {
                self.step = step
            }
        }

        public var seqVersion: Int = 8
        public let info: Info
        public let sequenceData: SequenceData
        public let gridData: GridData
        public let recData: RecData
        public let motionData: MotionData?

        public enum CodingKeys: String, CodingKey {
            case seqVersion = "seq_version"
            case info
            case sequenceData = "sequence_data"
            case gridData = "grid_data"
            case recData = "rec_data"
            case motionData = "motion_data"
        }

        public init(
            info: Info, sequenceData: SequenceData,
            gridData: GridData, recData: RecData, motionData: MotionData?
        ) {
            self.info = info
            self.sequenceData = sequenceData
            self.gridData = gridData
            self.recData = recData
            self.motionData = motionData
        }
    }

    public let data: SeqData

    public init(data: SeqData) {
        self.data = data
    }
}
