import Core
import Testing
@testable import FileServices

@Test
func categorizeCommonExtensions() {
    #expect(FileCategorizer.categorize(fileExtension: "jpg") == .image)
    #expect(FileCategorizer.categorize(fileExtension: "png") == .image)
    #expect(FileCategorizer.categorize(fileExtension: "mp4") == .video)
    #expect(FileCategorizer.categorize(fileExtension: "mp3") == .audio)
    #expect(FileCategorizer.categorize(fileExtension: "pdf") == .document)
    #expect(FileCategorizer.categorize(fileExtension: "zip") == .archive)
    #expect(FileCategorizer.categorize(fileExtension: "xyz123") == .other)
}
