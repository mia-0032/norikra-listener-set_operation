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
    listener = Norikra::Listener::SetOperation.new('target1', 'name', 'DIFF_NEW_OLD(n1,new_target)')
    listener.engine = dummy_engine = Norikra::ListenerSpecHelper::DummyEngine.new

    it 'sends events into engine with target name' do
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

      expect_result = {
          "difference_new_old" => [1,2],
          "difference_old_new" => [5,6,7],
          "union" => [1,2,3,4,5,6,7],
          "intersection" => [3,4]
      }

      expect(dummy_engine.events['new_target'].size).to eql(1)
      expect(dummy_engine.events['new_target'][0]).to eql(expect_result)

      listener.process_sync([{"n1" => 8, "s" => "eight"}], [])

      expect_result = {
          "difference_new_old" => [8],
          "difference_old_new" => [],
          "union" => [8],
          "intersection" => []
      }

      expect(dummy_engine.events['new_target'].size).to eql(2)
      expect(dummy_engine.events['new_target'][1]).to eql(expect_result)
    end
  end
end
