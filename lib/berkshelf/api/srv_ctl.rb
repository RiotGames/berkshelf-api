require 'optparse'
require 'buff/extensions'

module Berkshelf::API
  class SrvCtl
    class << self
      # @param [Array] args
      #
      # @return [Hash]
      def parse_options(args, filename)
        options = Hash.new

        OptionParser.new("Usage: #{filename} [options]") do |opts|
          opts.on("-p", "--port PORT", Integer, "set the listening port") do |v|
            options[:port] = v
          end

          opts.on("-v", "--verbose", "run with verbose output") do
            options[:log_level] = "INFO"
          end

          opts.on("-d", "--debug", "run with debug output") do
            options[:log_level] = "DEBUG"
          end

          opts.on("-q", "--quiet", "silence output") do
            options[:log_location] = '/dev/null'
          end

          opts.on_tail("-h", "--help", "show this message") do
            puts opts
            exit
          end
        end.parse!(args)

        options.symbolize_keys
      end

      # @param [Array] args
      # @param [String] filename
      def run(args, filename)
        options = parse_options(args, filename)
        new(options).start
      end
    end

    attr_reader :options

    # @param [Hash] options
    #   @see {Berkshelf::API::Application.run} for the list of valid options
    def initialize(options = {})
      @options = options
    end

    def start
      require 'berkshelf/api'
      Berkshelf::API::Application.run(options)
    end
  end
end
