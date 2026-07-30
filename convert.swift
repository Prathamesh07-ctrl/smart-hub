import Foundation
import PDFKit
import AppKit

let pdfPaths = [
  "/Users/prathameshtiwari/.gemini/antigravity-ide/brain/5259a501-5047-4729-8984-33068eb7616f/media__1785241520601.pdf",
  "/Users/prathameshtiwari/.gemini/antigravity-ide/brain/5259a501-5047-4729-8984-33068eb7616f/media__1785241527470.pdf",
  "/Users/prathameshtiwari/.gemini/antigravity-ide/brain/5259a501-5047-4729-8984-33068eb7616f/media__1785241538852.pdf"
]

let outDir = "/Users/prathameshtiwari/smarthub.3d/assets/gari-projects"
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)

var count = 0
for (pIdx, path) in pdfPaths.enumerated() {
    guard let doc = PDFDocument(url: URL(fileURLWithPath: path)) else { continue }
    for i in 0..<doc.pageCount {
        guard let page = doc.page(at: i) else { continue }
        let pageBounds = page.bounds(for: .mediaBox)
        // Skip blank title pages or generate all
        let image = page.thumbnail(of: CGSize(width: pageBounds.width * 1.5, height: pageBounds.height * 1.5), for: .mediaBox)
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let jpgData = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.85]) else { continue }
        
        count += 1
        let outPath = "\(outDir)/gari_render_pdf\(pIdx+1)_p\(i+1).jpg"
        try? jpgData.write(to: URL(fileURLWithPath: outPath))
        print("Saved: \(outPath)")
    }
}
print("TOTAL EXTRACTED:", count)
