# frozen_string_literal: true

class Typesensual
  class Config
    attr_accessor :connection_timeout_seconds
    attr_writer :env, :client, :nodes, :api_key

    def initialize(&block)
      yield self if block
    end

    def env
      @env ||= ENV.fetch('TYPESENSUAL_ENV', (defined?(Rails) ? Rails.env : nil))
    end

    def client
      @client ||= Typesense::Client.new(connection_options)
    end

    def nodes
      @nodes ||= ENV['TYPESENSUAL_NODES']&.split(',')&.map do |node|
        node_uri = URI.parse(node)
        { port: node_uri.port, host: node_uri.host, protocol: node_uri.scheme }
      end
    end

    def api_key
      @api_key ||= ENV.fetch('TYPESENSUAL_API_KEY', nil)
    end

    def connection_timeout_seconds
      @connection_timeout_seconds ||= ENV.fetch('TYPESENSUAL_CONNECTION_TIMEOUT_SECONDS', 1800)
    end

    private

    def connection_options
      { nodes: nodes, api_key: api_key, connection_timeout_seconds: connection_timeout_seconds}
    end
  end
end
