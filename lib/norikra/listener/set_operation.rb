# coding: utf-8

require "norikra/listener"

module Norikra
  module Listener
    class DifferenceNewFromOld < Norikra::Listener::Base
      def self.label
        "DifferenceNewFromOld"
      end

      def initialize(argument, query_name, query_group)
        super
        @stdout = STDOUT
      end

      def process_sync(news, olds)
        news.each do |event|
          @stdout.puts "#{@query_name}\t#{@argument}\t" + JSON.dump(event)
        end
      end
    end
  end
end
