import Foundation
import PDFKit
import AppKit

let baseDir = "/Users/prathameshtiwari/smarthub.3d"
let outDir = "\(baseDir)/assets/gari-projects"

let files = [
    "_MR YOGESH SUTAR 3D VIEWS OF 2BHK (2).pdf",
    "_MR. RAJESH GONDHANI 3D VIEWS (3).pdf",
    "_MR.DIGAMBAR-3D VIEWS OF 2BHK .pdf"
]

for (idx, filename) in files.enumerated() {
    let pdfPath = "\(baseDir)/\(filename)"
    guard let doc = PDFDocument(url: URL(fileURLWithPath: pdfPath)) else {
        print("Could not open \(filename)")
        continue
    }
    
    print("Processing \(filename): \(doc.pageCount) pages")
    for p in 0..<doc.pageCount {
        guard let page = doc.page(at: p) else { continue }
        let bounds = page.bounds(for: .mediaBox)
        let targetSize = CGSize(width: bounds.width * 3.0, height: bounds.height * 3.0)
        let image = page.thumbnail(of: targetSize, for: .mediaBox)
        
        guard let tiffData = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: tiffData),
              let jpgData = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.90]) else {
            continue
        }
        
        let outPath = "\(outDir)/gari_render_pdf\(idx + 1)_p\(p + 1).jpg"
        do {
            try jpgData.write(to: URL(fileURLWithPath: outPath))
        } catch {
            print("Failed write \(outPath)")
        }
    }
}
print("Done extracting high-res images!")
