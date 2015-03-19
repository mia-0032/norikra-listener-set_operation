# coding: utf-8

require 'norikra-listener-set_operation'
require 'norikra/listener_spec_helper'

describe Norikra::Listener::SetOperation do

  describe '.label' do
    it 'returns "SetOperation"' do
      expect(Norikra::Listener::SetOperation.label).to eql("SET_OPERATION")
    end
  end

  describe '#process_sync' do
    it 'sends events into engine with target name' do
      listener = Norikra::Listener::SetOperation.new('target1', 'name', 'SET_OPERATION(n1,new_target)')
      listener.engine = dummy_engine = Norikra::ListenerSpecHelper::DummyEngine.new

      listener.process_sync([
          {"n1" => 1, "s" => "one"},
          {"n1" => 2, "s" => "two"},
          {"n1" => 3, "s" => "three"},
          {"n1" => 4, "s" => "four"},
          {"n1" => 4, "s" => "four"}
        ], [
          {"n1" => 3, "s" => "three"},
          {"n1" => 4, "s" => "four"},
          {"n1" => 5, "s" => "five"},
          {"n1" => 6, "s" => "six"},
          {"n1" => 7, "s" => "seven"}
      ])

      expect_result = [
          {"item" => 1, "operation" => "difference_new_old"},
          {"item" => 2, "operation" => "difference_new_old"},
          {"item" => 5, "operation" => "difference_old_new"},
          {"item" => 6, "operation" => "difference_old_new"},
          {"item" => 7, "operation" => "difference_old_new"},
          {"item" => 1, "operation" => "union"},
          {"item" => 2, "operation" => "union"},
          {"item" => 3, "operation" => "union"},
          {"item" => 4, "operation" => "union"},
          {"item" => 5, "operation" => "union"},
          {"item" => 6, "operation" => "union"},
          {"item" => 7, "operation" => "union"},
          {"item" => 3, "operation" => "intersection"},
          {"item" => 4, "operation" => "intersection"}
      ]

      expect(dummy_engine.events['new_target'].size).to eql(14)
      expect(dummy_engine.events['new_target']).to match_array(expect_result)
    end

    it 'sends only new events into engine with target name' do
      listener = Norikra::Listener::SetOperation.new('target1', 'name', 'SET_OPERATION(n1,new_target)')
      listener.engine = dummy_engine = Norikra::ListenerSpecHelper::DummyEngine.new

      listener.process_sync([{"n1" => 8, "s" => "eight"}], [])

      expect_result = [
          {"item" => 8, "operation" => "difference_new_old"},
          {"item" => 8, "operation" => "union"}
      ]

      expect(dummy_engine.events['new_target'].size).to eql(2)
      expect(dummy_engine.events['new_target']).to match_array(expect_result)
    end

    it 'sends only old events into engine with target name' do
      listener = Norikra::Listener::SetOperation.new('target1', 'name', 'SET_OPERATION(n1,new_target)')
      listener.engine = dummy_engine = Norikra::ListenerSpecHelper::DummyEngine.new

      listener.process_sync([], [{"n1" => 8, "s" => "eight"}])

      expect_result = [
          {"item" => 8, "operation" => "difference_old_new"},
          {"item" => 8, "operation" => "union"}
      ]

      expect(dummy_engine.events['new_target'].size).to eql(2)
      expect(dummy_engine.events['new_target']).to match_array(expect_result)
    end
  end
end
