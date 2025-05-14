import SwiftUI
import QuartzCore
import Combine

// MARK: - Camera VM
// Courtesy : https://gist.github.com/AmyF/a7ccbe2b1099b1775afe9477d5b0f277
/// 相机视图模型，用于管理缩放、旋转和平移状态
final class CameraViewModel: ObservableObject {
    @Published var zoom: CGFloat = 1.0       // 缩放比例
    @Published var rotation: Angle = .zero   // 旋转角度
    @Published var offset: CGSize = .zero    // 平移偏移
}

// MARK: - Orbit VM (with CADisplayLink)

/// 轨道视图模型，使用 CADisplayLink 驱动实时更新，缓存每帧计算结果以减少重复投影
/// 轨道视图模型，使用 CADisplayLink 驱动实时更新
/// 性能优化要点：
/// 1. 仅发布 time，一次通知驱动所有视图刷新
/// 2. 降帧到 30fps，并预计算／预分配历史轨迹容量
/// 3. 批量 in-place 更新，避免多重 Combine 发布与数组 COW
final class OrbitViewModel: ObservableObject {
    /// 只发布 time，一次发布驱动所有子视图刷新
    @Published private(set) var time: Double = 0

    private let satellites: [Satellite]
    private var worldPositions: [(x: Double, y: Double, z: Double)]
    private var projectedPositions: [CGPoint]
    private var historyBuffers: [RingBuffer<CGPoint>]

    private var displayLink: CADisplayLink?
    private let historyDuration: Double = 3.0
    let fps = 30
    private let maxHistoryCount: Int

    init(satellites: [Satellite]) {
        self.satellites = satellites

        // 预计算历史缓冲区大小
        let maxHistoryCount = Int(historyDuration * Double(fps))
        self.maxHistoryCount = maxHistoryCount

        // 并行数组初始化
        self.worldPositions     = Array(repeating: (0,0,0), count: satellites.count)
        self.projectedPositions = Array(repeating: .zero,   count: satellites.count)
        self.historyBuffers     = satellites.map { _ in RingBuffer<CGPoint>(capacity: maxHistoryCount) }
    }

    /// 供子视图读取的并行数组接口
    var currentWorldPositions: [(x: Double, y: Double, z: Double)] { worldPositions }
    var currentProjectedPositions: [CGPoint]                { projectedPositions }
    var trails: [RingBuffer<CGPoint>]                       { historyBuffers }

    func start() {
        let link = CADisplayLink(target: self, selector: #selector(step(_:)))
        link.preferredFramesPerSecond = fps
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func step(_ link: CADisplayLink) {
        let dt = link.targetTimestamp - link.timestamp
        let newTime = time + dt
        time = newTime

        // 一次性取出常量
        let sats = satellites
        var worlds = worldPositions
        var projs  = projectedPositions
        var buffs  = historyBuffers

        for i in sats.indices {
            let sat = sats[i]
            let θ = sat.projection.trueAnomaly(time: newTime, period: sat.period)
            let w = sat.projection.worldPosition(theta: θ)
            let p = sat.projection.projectedPosition(theta: θ)

            worlds[i] = w
            projs[i]  = p

            buffs[i].append(p)
        }

        // 批量归还
        worldPositions     = worlds
        projectedPositions = projs
        historyBuffers     = buffs
    }
}

// MARK: - Models

/// 轨道投影模型，负责从参数计算三维位置并投影到二维
struct OrbitProjection {
    let semiMajorAxis: Double
    let semiMinorAxis: Double
    let inclination: Double    // 倾角（弧度）
    let equatorTilt: Double    // 赤道相对视角倾斜（弧度）
    let cameraDistance: Double // 相机到原点距离
    
    /// 偏心率
    var eccentricity: Double {
        sqrt(1 - (semiMinorAxis * semiMinorAxis) / (semiMajorAxis * semiMajorAxis))
    }
    
    /// 根据真近点角计算世界坐标
    func worldPosition(theta: Double) -> (x: Double, y: Double, z: Double) {
        let e = eccentricity
        let r = semiMajorAxis * (1 - e * e) / (1 + e * cos(theta))
        let xOrb = r * cos(theta)
        let yOrb = r * sin(theta)
        let yP = yOrb * cos(inclination)
        let zP = yOrb * sin(inclination)
        let x2 = xOrb * cos(equatorTilt) + zP * sin(equatorTilt)
        let z2 = -xOrb * sin(equatorTilt) + zP * cos(equatorTilt)
        return (x2, yP, z2)
    }
    
    /// 将三维世界坐标投影到屏幕二维
    func projectedPosition(theta: Double) -> CGPoint {
        let w = worldPosition(theta: theta)
        let f = cameraDistance / (cameraDistance + w.z)
        return CGPoint(x: w.x * f, y: w.y * f)
    }
    
    /// 开普勒方程数值解，返回真近点角
    func trueAnomaly(time: Double, period: Double) -> Double {
        let e = eccentricity
        let M = (2 * .pi * (time / period))
            .truncatingRemainder(dividingBy: 2 * .pi)
        var E = M
        for _ in 0..<6 {
            E -= (E - e * sin(E) - M) / (1 - e * cos(E))
        }
        return 2 * atan2(sqrt(1 + e) * sin(E / 2), sqrt(1 - e) * cos(E / 2))
    }
}

/// 卫星模型
struct Satellite: Identifiable {
    let id = UUID()
    let projection: OrbitProjection  // 投影参数
    let color: Color                 // 渲染颜色
    let radius: CGFloat              // 半径（世界单位）
    let period: Double               // 轨道周期（秒）
}

// MARK: - Subviews

/// 轨道路径视图，利用缓存避免重复计算
struct OrbitPathView: View {
    let satellites: [Satellite]
    let worldScale: CGFloat
    let worldOffset: CGPoint

    @State private var cached: [UUID: Path] = [:]
    @State private var computeWorkItem: DispatchWorkItem?
    
    private let updateTrigger = PassthroughSubject<Void, Never>()
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            context.translateBy(x: center.x, y: center.y)
            for sat in satellites {
                if let path = cached[sat.id] {
                    context.stroke(path,
                                   with: .color(sat.color.opacity(0.5)),
                                   lineWidth: 1)
                }
            }
        }
        .onReceive(updateTrigger.debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)) {
            computePathsAsync()
        }
        .onAppear {
            // 首次立即触发一次
            updateTrigger.send()
        }
        .onChange(of: worldScale) { _, _ in updateTrigger.send() }
        .onChange(of: worldOffset) { _, _ in updateTrigger.send() }
    }

    // 后台异步计算，再回到主线程更新 cached
    private func computePathsAsync() {
        let sats = satellites
        let scale = worldScale.isFinite ? worldScale : 1.0
        let offset = worldOffset
        let sampleCount = max(64, Int(scale * 50))  // 下限 64
        DispatchQueue.global(qos: .userInitiated).async {
            var newCache: [UUID: Path] = [:]
            for sat in sats {
                var path = Path()
                for i in 0...sampleCount {
                    let θ = Double(i)/Double(sampleCount) * 2 * .pi
                    let p = sat.projection.projectedPosition(theta: θ)
                    let x = (p.x - offset.x) * scale
                    let y = (p.y - offset.y) * scale
                    let pt = CGPoint(x: x, y: y)
                    if i == 0 { path.move(to: pt) }
                    else      { path.addLine(to: pt) }
                }
                newCache[sat.id] = path
            }
            DispatchQueue.main.async {
                self.cached = newCache
            }
        }
    }

    
    @State private var cancellables = Set<AnyCancellable>()
}

/// 卫星尾迹视图，根据缓存的轨迹点进行绘制，避免重复投影计算
struct SatelliteTrailView: View {
    @ObservedObject var viewModel: OrbitViewModel
    let satellites: [Satellite]
    let worldScale: CGFloat
    let worldOffset: CGPoint

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            context.translateBy(x: center.x, y: center.y)

            for i in satellites.indices {
                let hist = viewModel.trails[i]
                guard hist.count > 1 else { continue }

                // 合并一条 Path
                var trail = Path()
                for (j, wp) in hist.enumerated() {
                    let pt = CGPoint(
                        x: (wp.x - worldOffset.x) * worldScale,
                        y: -(wp.y - worldOffset.y) * worldScale
                    )
                    if j == 0 { trail.move(to: pt) }
                    else      { trail.addLine(to: pt) }
                }

                // 根据最后一小段速度计算样式
                let p1 = hist.secondLast!, p2 = hist.last!
                let pt1 = CGPoint(
                    x: (p1.x - worldOffset.x) * worldScale,
                    y: -(p1.y - worldOffset.y) * worldScale
                )
                let pt2 = CGPoint(
                    x: (p2.x - worldOffset.x) * worldScale,
                    y: -(p2.y - worldOffset.y) * worldScale
                )
                let dist = hypot(pt2.x - pt1.x, pt2.y - pt1.y)
                let speed = dist / CGFloat(1.0 / Double(viewModel.fps))
                let lw = min(max(1, speed * 0.02), 5)
                let alpha = min(max(Double(speed * 0.002), 0.2), 0.8)

                context.stroke(trail,
                               with: .color(satellites[i].color.opacity(alpha)),
                               lineWidth: lw)
            }
        }
    }
}


/// 行星与卫星视图，根据缓存的坐标实现遮挡效果
struct PlanetAndSatelliteView: View {
    @ObservedObject var viewModel: OrbitViewModel
    let satellites: [Satellite]
    let worldScale: CGFloat
    let worldOffset: CGPoint
    let planetRadius: CGFloat

    /// 只与卫星“静态”属性相关的数据，提前生成避免每帧重复构造
    private let gradients: [Gradient]
    private let baseRadii: [CGFloat]

    init(
        viewModel: OrbitViewModel,
        satellites: [Satellite],
        worldScale: CGFloat,
        worldOffset: CGPoint,
        planetRadius: CGFloat
    ) {
        self.viewModel = viewModel
        self.satellites = satellites
        self.worldScale = worldScale
        self.worldOffset = worldOffset
        self.planetRadius = planetRadius

        // 预生成每颗卫星的 Shade Gradient 和 基础半径
        self.gradients = satellites.map {
            Gradient(colors: [Color.white.opacity(0.7), $0.color])
        }
        self.baseRadii = satellites.map { $0.radius }
    }

    var body: some View {
        Canvas { context, size in
            // 画布中心
            let center = CGPoint(x: size.width/2, y: size.height/2)

            // 取并行数组
            let worlds = viewModel.currentWorldPositions
            let projs  = viewModel.currentProjectedPositions

            // 1. “背后”卫星：world.z > 0
            for i in satellites.indices where worlds[i].z > 0 {
                draw(satIndex: i, in: &context, center: center, projs: projs)
            }

            // 2. 行星
            let planetDiameter = 2 * planetRadius * worldScale
            let planetRect = CGRect(
                x: center.x - planetDiameter/2,
                y: center.y - planetDiameter/2,
                width: planetDiameter,
                height: planetDiameter
            )
            // 行星渐变
            let planetGrad = Gradient(colors: [Color.white.opacity(0.7), .green])
            let planetShading = GraphicsContext.Shading.radialGradient(
                planetGrad,
                center: CGPoint(x: center.x, y: center.y),
                startRadius: 0,
                endRadius: planetDiameter/2
            )
            context.fill(Path(ellipseIn: planetRect), with: planetShading)

            // 3. “前面”卫星：world.z <= 0
            for i in satellites.indices where worlds[i].z <= 0 {
                draw(satIndex: i, in: &context, center: center, projs: projs)
            }
        }
    }

    /// 绘制第 `i` 颗卫星
    private func draw(
        satIndex i: Int,
        in context: inout GraphicsContext,
        center: CGPoint,
        projs: [CGPoint]
    ) {
        let p = projs[i]
        let grad = gradients[i]
        let r = baseRadii[i] * worldScale

        // 1. 计算在画布上的位置和大小
        let cx = center.x + (p.x - worldOffset.x) * worldScale
        let cy = center.y - (p.y - worldOffset.y) * worldScale
        let rect = CGRect(
            x: cx - r,
            y: cy - r,
            width: r * 2,
            height: r * 2
        )

        // 2. 按照缓存的 Gradient 生成 Shading
        let shading = GraphicsContext.Shading.radialGradient(
            grad,
            center: CGPoint(x: cx, y: cy),
            startRadius: 0,
            endRadius: r
        )

        // 3. 一次性填充椭圆
        context.fill(Path(ellipseIn: rect), with: shading)
    }
}

// MARK: - Main View

/// 综合多个卫星轨道的主视图，支持平移、缩放、旋转手势
struct MultiOrbitView: View {
    let satellites: [Satellite]
    let planetRadius: CGFloat

    @StateObject private var orbitVM: OrbitViewModel
    @StateObject private var camera: CameraViewModel
    
    // —— 缓存包围盒，只更新一次或在轨道数组变更时更新 ——
    @State private var boundingBox: CGRect = .zero

    init(satellites: [Satellite], planetRadius: CGFloat) {
        _orbitVM = StateObject(wrappedValue: OrbitViewModel(satellites: satellites))
        _camera  = StateObject(wrappedValue: CameraViewModel())
        self.satellites = satellites
        self.planetRadius = planetRadius
    }

    // 1. 计算所有轨道在世界坐标下的包围盒
    private func calculateBoundingBox(sampleCount: Int = 200) -> CGRect {
        var points: [CGPoint] = []
        for sat in satellites {
            for i in 0...sampleCount {
                let θ = Double(i) / Double(sampleCount) * 2 * .pi
                points.append(sat.projection.projectedPosition(theta: θ))
            }
        }
        guard let first = points.first else { return .zero }
        var minX = first.x, maxX = first.x, minY = first.y, maxY = first.y
        for p in points {
            minX = min(minX, p.x); maxX = max(maxX, p.x)
            minY = min(minY, p.y); maxY = max(maxY, p.y)
        }
        return CGRect(x: minX, y: minY,
                      width: maxX-minX, height: maxY-minY)
    }

    var body: some View {
        GeometryReader { geo in
            // 2. 动态计算缩放与偏移
            let worldSize = boundingBox.size
            let margin: CGFloat = 0.9
            let scaleX = geo.size.width / worldSize.width
            let scaleY = geo.size.height / worldSize.height
            let baseWorldScale = min(scaleX, scaleY) * margin
            let worldScale = baseWorldScale * camera.zoom
            let worldOffset = CGPoint(x: boundingBox.midX, y: boundingBox.midY)

            ZStack {
                OrbitPathView(
                    satellites: satellites,
                    worldScale: worldScale,
                    worldOffset: worldOffset
                )
                SatelliteTrailView(
                    viewModel: orbitVM,
                    satellites: satellites,
                    worldScale: worldScale,
                    worldOffset: worldOffset
                )
                PlanetAndSatelliteView(
                    viewModel: orbitVM,
                    satellites: satellites,
                    worldScale: worldScale,
                    worldOffset: worldOffset,
                    planetRadius: planetRadius
                )
            }
            .rotationEffect(camera.rotation)
            .offset(camera.offset)
            .onAppear {
                orbitVM.start()
                DispatchQueue.global(qos: .userInitiated).async {
                    let bbox = calculateBoundingBox()
                    DispatchQueue.main.async { boundingBox = bbox }
                }
            }
            .onDisappear { orbitVM.stop() }
        }
    }
}

extension Satellite {
    /// 生成一个随机卫星
    /// - Parameters:
    ///   - semiMajorAxisRange: 半长轴范围
    ///   - eccentricityRange: 偏心率范围 (0..<1)
    ///   - inclinationRange: 倾角范围（弧度）
    ///   - equatorTiltRange: 赤道倾斜范围（弧度）
    ///   - cameraDistanceMultiplier: 相机距离 = 半长轴 * multiplierRange
    ///   - radiusRange: 卫星半径范围（世界单位）
    ///   - periodRange: 轨道周期范围（秒）
    static func random(
        semiMajorAxisRange: ClosedRange<Double>      = 5...20,
        eccentricityRange: ClosedRange<Double>       = 0...0.8,
        inclinationRange: ClosedRange<Double>        = 0...(Double.pi),
        equatorTiltRange: ClosedRange<Double>        = -(Double.pi/8)...(Double.pi/8),
        cameraDistanceMultiplier: ClosedRange<Double> = 2...4,
        radiusRange: ClosedRange<CGFloat>            = 0.1...0.5,
        periodRange: ClosedRange<Double>             = 5...30
    ) -> Satellite {
        // 随机半长轴
        let a = Double.random(in: semiMajorAxisRange)
        // 随机偏心率 e，确保 0 <= e < 1
        let e = Double.random(in: eccentricityRange).clamped(to: 0..<1)
        // 根据 e 和 a 计算半短轴 b = a * sqrt(1 - e^2)
        let b = a * sqrt(1 - e * e)
        
        // 随机倾角 & 赤道倾斜
        let incl = Double.random(in: inclinationRange)
        let tilt = Double.random(in: equatorTiltRange)
        
        // 随机相机距离，保证 > a
        let camDist = a * Double.random(in: cameraDistanceMultiplier)
        
        let projection = OrbitProjection(
            semiMajorAxis: a,
            semiMinorAxis: b,
            inclination: incl,
            equatorTilt: tilt,
            cameraDistance: camDist
        )
        
        // 随机颜色（HSV 模式，色相全域随机，饱和度和亮度固定在较高值）
        let color = Color(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.7...1),
            brightness: Double.random(in: 0.7...1)
        )
        
        // 随机半径 & 周期
        let radius = CGFloat.random(in: radiusRange)
        let period = Double.random(in: periodRange)
        
        return Satellite(
            projection: projection,
            color: color,
            radius: radius,
            period: period
        )
    }
}

// Helper：ClosedRange<Double> clamp
fileprivate extension Double {
    func clamped(to range: Range<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound - .leastNonzeroMagnitude)
    }
}

// MARK: - Preview

struct MultiOrbitView_Previews: PreviewProvider {
    static var previews: some View {
        MultiOrbitView(satellites: (0..<200).map { _ in Satellite.random() }, planetRadius: 1.5)
            .frame(width: 350, height: 350)
            .padding()
    }
}

/// 一个固定容量的环形缓冲区，O(1) 追加与遍历
struct RingBuffer<T>: Sequence {
    private var buffer: [T?]
    private var head = 0
    private var tail = 0
    private(set) var count = 0
    let capacity: Int

    init(capacity: Int) {
        self.capacity = capacity
        self.buffer = Array<T?>(repeating: nil, count: capacity)
    }

    mutating func append(_ element: T) {
        buffer[tail] = element
        tail = (tail + 1) % capacity
        if count == capacity {
            head = (head + 1) % capacity
        } else {
            count += 1
        }
    }

    /// 按“最旧→最新”顺序迭代
    func makeIterator() -> AnyIterator<T> {
        var idx = head
        var n = 0
        return AnyIterator {
            guard n < self.count, let el = self.buffer[idx] else { return nil }
            defer {
                idx = (idx + 1) % self.capacity
                n += 1
            }
            return el
        }
    }

    /// 取最近一条记录
    var last: T? {
        guard count > 0 else { return nil }
        let idx = (head + count - 1) % capacity
        return buffer[idx]
    }

    /// 取倒数第二条记录
    var secondLast: T? {
        guard count > 1 else { return nil }
        let idx = (head + count - 2) % capacity
        return buffer[idx]
    }
}
