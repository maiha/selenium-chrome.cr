require "./wait"

class Selenium::Session
  property downloads_dir : String = Chrome::Downloads.new.dir

  def downloads(ext = nil)
    Chrome::Downloads.new(downloads_dir, ext: ext)
  end

  def download(ext : String? = nil, timeout : Time::Span? = nil, interval : Time::Span? = nil, &block : -> T) : Bytes forall T
    snapshot = downloads(ext: ext)
    block.call
    sleep 1

    found : Selenium::Chrome::Downloads::File? = nil

    wait("downloading", timeout: timeout, interval: interval) do
      current = downloads(ext: ext)
      created = (current - snapshot)

      case created.files.size
      when 1
        found = created.files.first
        true
      when 0
        false
      else
        raise "found multiple files in downloading: %s" % created.files.map(&.path).inspect
      end
    end

    if file = found
      bytes = Bytes.new(File.size(file.path))
      File.open(file.path) do |io|
        io.read_fully(bytes)
      end
      return bytes
    else
      raise "[BUG] download has been finished, but file not found"
    end
  end
end
