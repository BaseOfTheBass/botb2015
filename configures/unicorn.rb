@path = '/home/botb/bptb2015'

worker_processes 2
user "webops", "webops"
working_directory @path

listen "#{@path}/tmp/unicorn.sock"
pid "#{@path}/tmp/pids/unicorn.pid"
#listen 3000

timeout 60

preload_app true

stdout_path "#{@path}/log/unicorn.stdout.log"
stderr_path "#{@path}/log/unicorn.stderr.log"

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  sleep 1
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
