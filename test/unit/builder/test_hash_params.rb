require 'helper'
require 'lolsoap/builder/hash_params'
require 'pp'

module LolSoap
  describe Builder::HashParams do
    let(:doc) { MiniTest::Mock.new }

    let(:node) do
      n = OpenStruct.new(
        :document         => doc,
        :namespace_scopes => [OpenStruct.new(:prefix => 'b'), OpenStruct.new(:prefix => 'a')],
        :children         => MiniTest::Mock.new
      )
      def n.<<(child); children << child; end
      n
    end

    let(:type) do
      t = OpenStruct.new(:prefix => 'a')
      def t.element_prefix(name)
        @element_prefixes = { 'bar' => 'b' }
        @element_prefixes.fetch(name) { 'a' }
      end
      def t.has_attribute?(*); false; end
      def t.sub_type(name)
        @sub_types ||= { 'foo' => Object.new, 'bar' => Object.new, 'clone' => Object.new }
        @sub_types[name]
      end
      t
    end

    subject { Builder::HashParams.new(node, type) }

    def expect_node_added(namespace, args)
      sub_node = MiniTest::Mock.new

      doc.expect(:create_element, sub_node, args)
      sub_node.expect(:namespace=, nil, [namespace])
      node.children.expect(:<<, nil, [sub_node])

      yield sub_node

      [doc, sub_node, node].each(&:verify)
    end

    describe '#parse' do
      it 'adds an element to the node, using the correct namespace' do
        expect_node_added(node.namespace_scopes[1], %w[foo bar]) do
          subject.parse(foo: 'bar')
        end
      end
    end

    describe '#extract_params!' do
      it 'extracts' do
        subject.class.send(:public, :extract_params!)
        subject.extract_params!(
          type, {
            ns: node.namespace_scopes[1],
            tag: 'foo'
          }, 'bar'
        ).must_equal(
          name: 'foo', prefix: node.namespace_scopes[1], attributes: {},
          sub_hash: nil, content: 'bar', sub_type: type.sub_type('foo')
        )
      end
    end

    # hash.replace(
    #   hash.sort_by do |key, _|
    #     el = key.is_a?(Hash) ? key[:tag].to_s : key.to_s
    #     type.elements_names.index(el) || 1 / 0.0
    #   end.to_h
    # )
    # TODO Extract and move
    describe '::before_parse' do
      # callbacks are cleared only upon request instanciation
      def with_callback
        callback = MiniTest::Mock.new
        subject.class.before_parse do |hash, node, type|
          callback.expect(:call, nil, [hash, node, type])
        end
        yield
        callback.verify
        subject.class.clear_callbacks
      end

      it 'stores a callback' do
        with_callback do
          subject.before_parse.size.must_equal 1
        end
      end

      it 'calls a callback' do
        skip 'need to dig'
        with_callback do
          subject.parse(foo: 'bar', node: node, type: type)
        end
      end
    end
  end
end
