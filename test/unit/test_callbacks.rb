require 'helper'
require 'lolsoap/callbacks.rb'

module LolSoap
  describe Callbacks do
    before do
      @lol_callbacks = Callbacks.new.tap do |lc|
        lc.for('a.b') << ->(name, mutable) { mutable << "Lol #{name}" }
      end
    end

    after do
      @lol_callbacks.disable
    end

    it 'can store one callback' do
      @lol_callbacks.callbacks.size.must_equal 1
    end

    it 'can call a callback' do
      ary = []
      Callbacks.in('a.b').expose('lol', ary)
      ary.must_equal ['Lol lol']
    end

    it 'can call multiple callbacks' do
      temp = Callbacks.new
      temp.for('a.b') << ->(name, mutable) { mutable << "#{name} more" }
      temp.for('a.b') << ->(name, mutable) { mutable << "#{name} again" }
      ary = []
      Callbacks.in('a.b').expose('lol', ary)
      ary.must_equal ['Lol lol', 'lol more', 'lol again']
      temp.disable
    end

    it 'can be disabled' do
      @lol_callbacks.disable
      temp = Callbacks.new
      temp.for('a.b') << ->(name, mutable) { mutable << "any #{name} ?" }
      ary = []
      Callbacks.in('a.b').expose('lol', ary)
      ary.must_equal ['any lol ?']
      temp.disable
    end

    it 'can be enabled' do
      @lol_callbacks.disable
      @lol_callbacks.enable
      temp = Callbacks.new
      temp.for('a.b') << ->(name, mutable) { mutable << "any #{name} ?" }
      ary = []
      Callbacks.in('a.b').expose('lol', ary)
      ary.must_equal ['Lol lol', 'any lol ?']
      temp.disable
    end
  end
end