# coding: utf-8

require "norikra/listener"

module Norikra
  module Listener
    class SetOperation < Norikra::Listener::Base
      attr_writer :engine

      def self.label
        "SET_OPERATION"
      end

      def initialize(argument, query_name, query_group)
        super
        conf = Norikra::Listener.parse query_group
        @field_name, @new_target = conf[:argument].split(',')
        if @field_name.nil? || @field_name.empty?
          raise Norikra::ClientError, "#{self.label} field name not specified"
        end
        if @new_target.nil? || @new_target.empty?
          raise Norikra::ClientError, "#{self.label} target name not specified"
        end
      end

      def extract_specify_field(events)
        events.map {|e| e[@field_name] }
      end

      def process_sync(news, olds)
        new_items = extract_specify_field news
        old_items = extract_specify_field olds

        result = {}
        result["difference_new_old"] = new_items - old_items
        result["difference_old_new"] = old_items - new_items
        result["union"] = new_items | old_items
        result["intersection"] = new_items & old_items
        @engine.send(@new_target,[result])
      end
    end
  end
end
