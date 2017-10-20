require 'helper'
require 'lolsoap/callbacks.rb'

module LolSoap
  describe Callbacks do
    after do
      Callbacks.flush_callbacks
    end

    it 'can store one callback' do
      Callbacks.register(
        {"a.b" => [->(name, mutable) { mutable << "Before #{name}" }]}
      )

      Callbacks.store.size.must_equal 1
    end

    it 'can call a callback normal' do
      ary = []

      Callbacks.register(
        {"a.b" => [->(name, mutable) { mutable << "Normal #{name}" }]}
      )

      Callbacks.in('a.b').expose('newOne', ary)

      ary.must_equal ['Normal newOne']
    end

    it 'can call a callback in a thread' do
      ary = []

      Thread.new do
        Callbacks.register(
          {"a.b" => [->(name, mutable) { mutable << "Thread #{name}" }]}
        )

        Callbacks.in('a.b').expose('TnewOne', ary)
      end.join

      ary.must_equal ['Thread TnewOne']
    end

    it 'can call multiple callbacks' do
      ary = []

      Callbacks.register(
        {"a.b" => [
          ->(name, mutable) { mutable << "Normal #{name}" },
          ->(name, mutable) { mutable << "Second #{name}" },
        ]}
      )

      Callbacks.in('a.b').expose('newOne', ary)

      ary.must_equal ['Normal newOne', 'Second newOne']
    end

    it 'can route callbacks' do
      ary = []
      yra = []

      Callbacks.register(
        {
          "a.b" => [->(name, mutable) { mutable << "Route1 #{name}" }],
          "x.y" => [->(name, mutable) { mutable << "Route2 #{name}" }],
        }
      )

      Callbacks.in('a.b').expose('TnewOne', ary)
      Callbacks.in('x.y').expose('TnewTwo', yra)

      ary.must_equal ['Route1 TnewOne']
      yra.must_equal ['Route2 TnewTwo']
    end

    it 'can be flush' do
      ary = []

      Callbacks.register(
        {"a.b" => [->(name, mutable) { mutable << "Normal Flush #{name}" }]}
      )

      Callbacks.in('a.b').expose('newOne', ary)

      Callbacks.store.size.must_equal 1
      ary.must_equal ['Normal Flush newOne']

      Callbacks.flush_callbacks
      Callbacks.store.size.must_equal 0
    end
  end
end
