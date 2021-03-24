class PcoBox
  include Thor::Shell

  def self.update
    new.update
  end

  def self.update_apps(run_webpack)
    new.update_apps(run_webpack)
  end

  def self.start
    new.start
  end

  def self.stop
    new.stop
  end

  def initialize
    @home = ENV.fetch("HOME")
  end

  def update
    say "⚙️  Updating pco-box", :green
    Dir.chdir("#{home}/pco-box") do
      run_command("git", "pull")
      run_command("box", "update")
    end
  end

  def update_apps(run_webpack)
    say "⚙️  Updating apps", :green
    args = %w[box update-apps --auto-master]
    args << "--skip-webpack" unless run_webpack
    run_command(*args)
  end

  def start
    say "⚙️  starting box", :green
    run_command("box", "start")
  end

  def stop
    say "⚙️  shutting down box", :green
    run_command("box", "stop")
  end

  private

  attr_reader :home

  def run_command(*args)
    # https://nickcharlton.net/posts/ruby-subprocesses-with-stdout-stderr-streams.html
    Open3.popen3({"NON_INTERACTIVE" => "true"}, *args) do |stdin, stdout, stderr, status_thread|
      [stdout, stderr].each do |stream|
        Thread.new do
          until (line = stream.gets).nil?
            puts line
          end
        end
      end

      status_thread.join
    end
  end
end
