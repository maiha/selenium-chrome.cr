# This class manages downloaded files.
# We assume the syntax of "%Y%m%d%H%M%S.ext" for filenames.
class Selenium::Chrome::Downloads
  # selenium/standalone-chrome-debug:3.11.0
  DEFAULT_DIR = "/home/seluser/Downloads"

  record File, path : String do
    def name : String
      ::File.basename(path) # 20180323052725.csv
    end

    def ext : String
      ::File.extname(path).sub(/^\./, "") # "csv"
    end
  end

  getter dir : String
  getter files : Array(File) = Array(File).new
  
  def initialize(@dir = DEFAULT_DIR, files : Array(File)? = nil, ext : String? = nil)
    # seluser@188f16f355e6:~$ ls -l /home/seluser/Downloads
    # total 40
    # -rw-r--r-- 1 seluser seluser 35846 Mar 23 05:27 20180323052725.csv
    # -rw-r--r-- 1 seluser seluser     0 Mar 23 05:33 20180323053322.csv.crdownload
    @files = files || load
    @files.select!(&.ext.== ext) if ext
  end

  def load
    Dir["#{@dir}/*"].sort.map{|path| File.new(path)}
  end

  def -(other) : Downloads
    denied = other.files.map(&.name).to_set
    files  = @files.reject{|f| denied.includes?(f.name)}
    return Downloads.new(dir, files)
  end
end
