# frozen_string_literal: true

namespace :logs do
  # TODO: use other paths than #{shared_path}/log
  desc 'tail specified log or all'
  task :tail, :file, :len do |_, args|
    SSHKit.config.use_format :blackhole
    n = args[:len] || fetch(:ops_nlines)
    logf = args[:file] || fetch(:ops_log)
    logf = [logf] unless logf.is_a?(Array)
    logf.map! { |f| "-f #{shared_path}/log/#{f}.log" }
    cmd = "-n #{n} #{logf.join(' ')}"
    on fetch(:ops_servers), in: :parallel do |host|
      execute :tail, cmd, interaction_handler: DumbIH.new(host)
    end
  end
end
