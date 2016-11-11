begin
  require "scss_lint/rake_task"
  SCSSLint::RakeTask.new { |task| task.files = ["app/assets"] }
rescue LoadError => error
  puts error.message
end
