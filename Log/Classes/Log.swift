//
//  Log.swift
//  TourismAudioManagement
//
//  Created by itc on 2021/7/27.
//

import Foundation

struct Common {
    
    /// Target 配置
    enum Config {
        case test
        case debug
        case release
    }
    
    /// 当前命名空间
    static let namespace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
    
    /// 获取系统环境变量
    static func environment() -> [String : String] { ProcessInfo.processInfo.environment }
    
    static var config: Config = {
        #if TEST
        return .test
        #elseif DEBUG
        return .debug
        #else
        return .release
        #endif
    }()
}

struct LogOptionSet: OptionSet {
    
    /// 原始值类型
    let rawValue: Int
    
    // 在 Edit Scheme... 多添加一个 Environment Variables
    // 那么需要在这添加一个枚举值, 并且在 LogOptionSet 也要增加对应的属性
    // DYLD_PRINT_STATISTICS 启动信息key
    
    static var environments: Array<String> = [
        "socketLog",     // Socket通讯
        "HeartBeatLog",  // 心跳
        "HTTPLog",       // HTTP请求
        "DatabaseLog",   // 数据库操作
        "RunTimeLog",    // 运行时信息
        "TouchLog",      // 手势信息
        "FeatureLog",    // 新特性向导
        "LoginLog",      // 登录
        "HomeLog",       // 首页
        "Module1Log",    // 模块1 备用
        "Module2Log",    // 模块2 备用
        "Module3Log",    // 模块3 备用
        "MineLog",       // 我的
        "OtherLog",      // 其他
        ]

    // 以下与环境变量数组下标  1 << index 一一对应
    static let socket       = Self(rawValue: 1 << 0)
    static let heartBeat    = Self(rawValue: 1 << 1)
    static let http         = Self(rawValue: 1 << 2)
    static let database     = Self(rawValue: 1 << 3)
    static let runTime      = Self(rawValue: 1 << 4)
    static let touch        = Self(rawValue: 1 << 5)
    static let feature      = Self(rawValue: 1 << 6)
    static let login        = Self(rawValue: 1 << 7)
    static let home         = Self(rawValue: 1 << 8)
    static let module1      = Self(rawValue: 1 << 9)
    static let module2      = Self(rawValue: 1 << 10)
    static let module3      = Self(rawValue: 1 << 11)  
    static let mine         = Self(rawValue: 1 << 12)  
    static let other        = Self(rawValue: 1 << 13)
    
    // 默认配置的环境变量个数，与上面数组元素数量一致
    static let environmentNumber = 14
    
    static var config: Self = {
        var result: Self = []
        let environment = Common.environment()
        for(index, element) in environments.enumerated(){
            if environment[element] != nil {
                result.insert(LogOptionSet(rawValue: 1 << index))
            }

        }
        return result
    }()
    
    static func addEnvironments(_ environments: Array<String>) {
        LogOptionSet.environments.append(contentsOf: environments)
    }
}

// MARK: - 文件路径处理
extension String {
    
    /// 文件名
    var lastPathComponent: String { (self as NSString).lastPathComponent }
    
    /// 文件后缀
    var pathExtension: String { (self as NSString).pathExtension }
    
    /// 除文件后缀
    var deletingPathExtension: String { (self as NSString).deletingPathExtension }
    
    /// 路径
    var deletingLastPathComponent: String { (self as NSString).deletingLastPathComponent }
    
}

/// 自定义Log
func Log(_ log: @autoclosure () -> Any, _ environment: LogOptionSet, file: String = #file, line: Int = #line, function: String = #function) {
    #if !RELEASE
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "zh_CN")
    let fileName = file.lastPathComponent.deletingPathExtension
    let message = "# \(fileName)(\(line)) \(function) \(dateFormatter.string(from: Date()))\n\(log())\n"
    if isatty(STDOUT_FILENO) != 0 { // 如果标准输出流是终端机(Xcode)
        if LogOptionSet.config.intersection(environment).rawValue != 0 {
            print(message)
        }
    } else { // 没连接xcode
        NSLog("\n \(message)")
    }

    #endif
}

/// 打印OC对象中信息的类型
enum LogObjectType: String {

    /// 打印对象成员变量 _ivarDescription
    case ivar = "_ivarDescription"
    /// 打印对象方法 _methodDescription
    case method = "_methodDescription"
    /// 打印对象方法(不包含父类) _shortMethodDescription
    case shortMethod = "_shortMethodDescription"
    /// 打印视图(对象必须是UIView) _recursiveDescription
    case view = "_recursiveDescription"

}

/// 打印Objective-C对象信息
func Log(_ object: NSObject, type: LogObjectType, file: String = #file, line: Int = #line, function: String = #function) {
    #if !RELEASE
    let selector: Selector = Selector(type.rawValue)
    guard let message = object.perform(selector) else { return }
    // takeUnretainedValue 与 takeRetainedValue 的区别可以使用option查看
    // 在 返回值是 Unmanaged<AnyObject> 时才使用上面2个方法
    // 当 perform 的 selector 会创建对象(如copy, create)时使用 takeRetainedValue
    // 否则使用 takeUnretainedValu
    Log(message.takeUnretainedValue(), .runTime, file: file, line: line, function: function)
    #endif
}
