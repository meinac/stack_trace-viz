# frozen_string_literal: true

require "erb"
require "json"
require "securerandom"

module StackTrace
  module Viz
    class HTML
      LAYOUT_FILE = "../../public/main.html.erb"

      def initialize(trace, **extra)
        @trace = trace
        @extra = extra
      end

      def save(file_path)
        file_path ||= default_file_path

        File.open(file_path, "w") { |f| f.write(content) }
      end

      private

      attr_reader :trace, :extra

      def content
        erb.result_with_hash({ trace_data: trace_data })
      end

      def trace_data
        JSON.generate({
          description: "Generated by StackTrace::Viz",
          **extra,
          trace: trace
        })
      end

      def erb
        ERB.new(layout)
      end

      def layout
        File.read(layout_path)
      end

      def layout_path
        File.expand_path(LAYOUT_FILE, root_path)
      end

      def root_path
        File.dirname(__dir__)
      end

      def default_file_path
        File.expand_path(random_file_name, Dir.pwd)
      end

      def random_file_name
        "#{SecureRandom.uuid}.html"
      end
    end
  end
end
