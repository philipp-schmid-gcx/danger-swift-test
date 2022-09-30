import Danger
import Foundation


let danger = Danger()
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles

let bigPRThreshold = 300
let minimumCoveragePercentage: Double = 50

if ((danger.github.pullRequest.additions ?? 0) + (danger.github.pullRequest.deletions ?? 0) > bigPRThreshold) {
    warn("> Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split each into separate PR will helps faster, easier review.")
}

let files = danger.git.createdFiles + danger.git.modifiedFiles
let swiftFiles = files.filter { $0.fileType == .swift }
print("swiftFiles:", swiftFiles)
if swiftFiles.isEmpty {
    print("No files found to lint")
} else {
    SwiftLint.lint(.files(swiftFiles), inline: true)
}

createCodeCoverageReport(for: swiftFiles, minimumCoveragePercentage: minimumCoveragePercentage)


// MARK: - ReportElement
struct ReportElement: Codable {
    let file: String
    let coverage: [Int?]
}

typealias Report = [ReportElement]

struct CoverageItem {
    let name: String
    let coveragePercentage: Double
}

func createCodeCoverageReport(for includeFiles: [File], minimumCoveragePercentage: Double) {
    // guard let schemeName = ProcessInfo.processInfo.environment["SCHEME"] else {
    //     print("Aborting the creation of the Code Coverage Report - Environment variable SCHEME hasn't been set.")
    //     return
    // }
    let reportURL = URL(fileURLWithPath: "./report.json")
    let report: Report
    do {
        let data = try Data(contentsOf: reportURL)
        report = try JSONDecoder().decode(Report.self, from: data)
    } catch {
        print("Decode report.json at \(reportURL.absoluteString) failed with error: \(error)")
        return
    }
    print("report: ", report)
    let filteredReport = report.filter { includeFiles.contains($0.file) }
    print("filteredReport: ", filteredReport)
    let items = filteredReport.map { CoverageItem(name: getName(for: $0),
                                                 coveragePercentage: getCoveragePercentage(for: $0))}
    
    var markdownStr = """
            | File | Coverage ||
            | --- | --- | --- |\n
            """

    markdownStr += items.map {
                "\($0.name) | \($0.coveragePercentage)% | \($0.coveragePercentage > minimumCoveragePercentage ? "✅" : "⚠️")\n"
            }.joined()
    danger.markdown(markdownStr)
    
}

func getName(for element: ReportElement) -> String {
    let url = URL(fileURLWithPath: element.file)
    return url.lastPathComponent
}

func getCoveragePercentage(for element: ReportElement) -> Double {
    let coverage = getCoverage(for: element)
    return transformToPercentage(coverage)
}

func getCoverage(for element: ReportElement) -> Double {
    let relevantLines = element.coverage.compactMap { $0 }
    let totalRelevantLines = relevantLines.count
    guard totalRelevantLines > 0 else {
        return 0
    }
    let testedLines = relevantLines.filter { $0 > 0 }
    return Double(testedLines.count) / Double(totalRelevantLines)
}

func transformToPercentage(_ value: Double) -> Double {
    let percentageCoverage = value * 100
    // Round to 2 decimal places
    return (percentageCoverage * 100).rounded() / 100
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
