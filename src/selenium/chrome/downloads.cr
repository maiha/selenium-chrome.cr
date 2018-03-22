# This class manages downloaded files.
# We assume the syntax of "%Y%m%d%H%M%S.ext" for filenames.
class Selenium::Chrome::Downloads
  # selenium/standalone-chrome-debug:3.11.0
  DEFAULT_DIR = "/home/seluser/Downloads"
  TIME_FORMAT = "%Y%m%d%H%M%S"

  getter dir : String
  getter files : Array(File) = Array(File).new
  getter last_file_time : Time?
  
  def initialize(@dir = DEFAULT_DIR)
    @last_file_time = nil
    reload!
  end

  record File, path : String do
    def name : String
      ::File.basename(path) # 20180323052725.csv
    end

    def ext : String
      ::File.extname(path).sub(/^\./, "") # "csv"
    end

    def created_at : Time
      Time.parse(name, TIME_FORMAT) # => 2018-03-23 05:27:25
    end
  end

  def reload! : Downloads
    # seluser@188f16f355e6:~$ ls -l /home/seluser/Downloads
    # total 40
    # -rw-r--r-- 1 seluser seluser 35846 Mar 23 05:27 20180323052725.csv
    # -rw-r--r-- 1 seluser seluser     0 Mar 23 05:33 20180323053322.csv.crdownload
    @files = load
    if last = @files[-1]?
      @last_file_time = last.created_at
    end
    return self
  end

  def load : Array(File)
    Dir["#{@dir}/2*"].sort.map{|path| File.new(path)}
  end

  def created(ext = nil) : Array(File)
    files = load
    if time = @last_file_time
      files = files.select(&.created_at.> time)
    end
    files = files.select(&.ext.== ext) if ext
    files
  end
end
