require 'pry'

RSpec.configure do |config|
  config.order = "random"

  config.before(:suite) do
    puts "Testing with #{CONNECTION_TYPE.to_s.upcase} socket type"
  end
end

HOST = ENV['HOST'] || '0.0.0.0'
PORT = ENV.fetch('PORT', 5228).to_i
CONNECTION_TYPE ||= (ENV['TYPE'] || 'UDP').to_s.downcase.to_sym

RSpec.shared_context 'logger' do
  # The type of connection we're testing
  def connection_type
    CONNECTION_TYPE
  end

  let(:host) { HOST }
  let(:hostname) { Socket.gethostname }
  let(:port) { PORT }

  # The logstash logger
  let(:logger) { LogStashLogger.new(host: host, port: port, type: connection_type) }
  # The log device that the logger writes to
  let(:logdev) { logger.instance_variable_get(:@logdev) }

  let(:connection) { LogStash::Connection.new(port: port)}
end