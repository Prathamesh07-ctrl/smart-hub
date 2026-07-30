import Foundation
import PDFKit
import AppKit

let pdfFiles = [
    (id: "yogesh_sutar", name: "Mr. Yogesh Sutar - 2BHK 3D Views", file: "_MR YOGESH SUTAR 3D VIEWS OF 2BHK (2).pdf"),
    (id: "rajesh_gondhani", name: "Mr. Rajesh Gondhani - 3D Views", file: "_MR. RAJESH GONDHANI 3D VIEWS (3).pdf"),
    (id: "digambar", name: "Mr. Digambar - 2BHK 3D Views", file: "_MR.DIGAMBAR-3D VIEWS OF 2BHK .pdf")
]

let baseDir = "/Users/prathameshtiwari/smarthub.3d"
let outDir = "\(baseDir)/assets/pdf-previews"

try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

var summary: [[String: Any]] = []

for item in pdfFiles {
    let pdfPath = "\(baseDir)/\(item.file)"
    guard let doc = PDFDocument(url: URL(fileURLWithPath: pdfPath)) else {
        print("Failed to open \(pdfPath)")
        continue
    }
    
    var pagesInfo: [[String: String]] = []
    print("Processing \(item.name): \(doc.pageCount) pages")
    
    for i in 0..<doc.pageCount {
        guard let page = doc.page(at: i) else { continue }
        let bounds = page.bounds(for: .mediaBox)
        
        // High quality render (scale 2.0)
        let renderSize = CGSize(width: bounds.width * 2.0, height: bounds.height * 2.0)
        let image = page.thumbnail(of: renderSize, for: .mediaBox)
        
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let jpgData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.90]) else {
            continue
        }
        
        let filename = "\(item.id)_p\(i+1).jpg"
        let outPath = "\(outDir)/\(filename)"
        try? jpgData.write(to: URL(fileURLWithPath: outPath))
        
        pagesInfo.append([
            "page": "\(i+1)",
            "image": "assets/pdf-previews/\(filename)",
            "aspectRatio": String(format: "%.2f", bounds.width / bounds.height)
        ])
    }
    
    summary.append([
        "id": item.id,
        "name": item.name,
        "pdfFile": item.file,
        "pageCount": doc.pageCount,
        "pages": pagesInfo
    ])
}

print("Render complete!")
