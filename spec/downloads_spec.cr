require "./spec_helper"

CURRENT_DOWNLOADS = Array(Selenium::Chrome::Downloads).new

private def dir
  "#{__DIR__}/../tmp/downloads"
end

private def clear_directory!
  FileUtils.rm_rf(dir)
  Dir.mkdir_p(dir)
end

private def write_file!(name : String)
  File.write("#{dir}/#{name}", "")
end

describe Selenium::Chrome::Downloads do
  describe "#files" do
    it "returns files in the directory" do
      clear_directory!
      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(0)
    end
    
    it "manages only files those filename contains 2000 years" do
      write_file!("foo.txt")
      write_file!("10010203040506.txt")

      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(0)

      write_file!("20010203040506.txt")
      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(1)
    end

    it "caches status of the filenames" do
      clear_directory!

      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(0)

      write_file!("20010203040506.txt")
      downloads.files.size.should eq(0)
    end
  end

  describe "#reload!" do
    it "clear caches" do
      clear_directory!

      downloads = Selenium::Chrome::Downloads.new(dir)
      write_file!("20010203040506.txt")

      downloads.files.size.should eq(0)
      downloads.reload!
      downloads.files.size.should eq(1)
    end
  end

  describe "#created" do
    it "returns newly created filenames" do
      clear_directory!

      future1 = Time.now + 1.minute
      future2 = Time.now + 2.minute

      write_file!(future1.to_s("%Y%m%d%H%M%S.txt"))

      downloads = Selenium::Chrome::Downloads.new(dir)

      downloads.files.size.should eq(1)
      downloads.load.size.should eq(1)
      downloads.created.size.should eq(0)

      write_file!(future2.to_s("%Y%m%d%H%M%S.txt"))

      downloads.files.size.should eq(1)
      downloads.load.size.should eq(2)
      downloads.created.size.should eq(1)
    end

    it "ignores old timestamp even if they are newly created" do
      clear_directory!

      future1 = Time.now + 1.minute
      future2 = Time.now + 2.minute

      write_file!(future2.to_s("%Y%m%d%H%M%S.txt"))

      downloads = Selenium::Chrome::Downloads.new(dir)

      downloads.files.size.should eq(1)
      downloads.load.size.should eq(1)
      downloads.created.size.should eq(0)

      write_file!(future1.to_s("%Y%m%d%H%M%S.txt"))

      downloads.files.size.should eq(1)
      downloads.load.size.should eq(2)
      downloads.created.size.should eq(0)
    end

    it "filters by given ext" do
      clear_directory!

      future1 = Time.now + 1.minute
      future2 = Time.now + 2.minute

      downloads = Selenium::Chrome::Downloads.new(dir)

      write_file!(future1.to_s("%Y%m%d%H%M%S.txt"))
      write_file!(future1.to_s("%Y%m%d%H%M%S.csv"))

      downloads.files.size.should eq(0)
      downloads.load.size.should eq(2)
      downloads.created.size.should eq(2)
      downloads.created("txt").size.should eq(1)
    end
  end
end
