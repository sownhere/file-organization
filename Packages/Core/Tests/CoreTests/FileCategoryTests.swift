import Testing
@testable import Core

@Test
func fileCategoryDisplayNames() {
    #expect(FileCategory.image.displayName == "Images")
    #expect(FileCategory.document.displayName == "Documents")
}

@Test
func fileSizeFormatting() {
    let size: Int64 = 2_500_000
    #expect(size.formattedFileSize.contains("2"))
}
