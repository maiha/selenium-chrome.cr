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
    
    it "caches status of the filenames" do
      clear_directory!

      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(0)

      write_file!("foo.txt")
      downloads.files.size.should eq(0)
    end
  end

  describe "#-(other)" do
    it "returns substitution" do
      clear_directory!

      write_file!("foo.txt")
      snapshot = Selenium::Chrome::Downloads.new(dir)

      write_file!("bar.txt")
      downloads = Selenium::Chrome::Downloads.new(dir)

      (downloads - snapshot).files.map(&.name).should eq(["bar.txt"])
    end
  end

  describe ".new(ext: foo)" do
    it "filters files by ext" do
      clear_directory!

      write_file!("foo.txt")
      write_file!("bar.csv")
      
      downloads = Selenium::Chrome::Downloads.new(dir)
      downloads.files.size.should eq(2)

      downloads = Selenium::Chrome::Downloads.new(dir, ext: "txt")
      downloads.files.size.should eq(1)
    end
  end
end
