require 'lolsoap/wsdl'

module LolSoap::Builder
  # Used to build XML, with namespaces automatically added.
  #
  # @example General
  #   builder = HashParams.new(node, type)
  #   builder.parse(someTag: { foo: 'bar' })
  #   # => <ns1:someTag><ns1:foo>bar</ns1:foo></ns1:someTag>
  #
  # @example Explicitly specifying a namespace prefix
  #   builder = HashParams.new(node, type)
  #   builder.parse({ ns: 'ns2', tag: 'someTag'} => nil)
  #   # => <ns2:someTag/>
  class HashParams
    @all_before_parse = []

    class << self
      def clear_callbacks
        @all_before_parse = []
      end

      def all_before_parse
        @all_before_parse
      end

      def before_parse(&block)
        @all_before_parse << block
      end
    end

    def before_parse
      self.class.all_before_parse
    end

    def initialize(node, type = WSDL::NullType.new)
      @node = node
      @type = type || WSDL::NullType.new
    end

    def parse(hash, node: @node, type: @type)
      # TODO : beautifully and DRY
      # callbacks are cleared only on new request
      unless hash.empty?
        before_parse.each { |block| block.call(hash, node, type) }
      end
      # TODO : test in the before_parse callback
      # -> replace tag name by @type.elements_names where identical tr('_', '').downcase

      hash.each do |key, val|
        # TODO : avoid this mess by allowing attributes on root elem
        if type.has_attribute?(key.to_s)
          node[key] = val
        else
          make_tag(
            node,
            extract_params!(type, key, val)
          )
        end
      end
    end

    private

    # @private
    # TODO : smells I'm missing an object
    def extract_params!(type, key, val)
      content = sub_hash = hash = nil

      if key.is_a?(Hash)
        name   = key.delete(:tag).to_s
        prefix = key.delete(:ns) || type.element_prefix(name)
        hash   = key
      else
        name   = key.to_s
        prefix = type.element_prefix(name)
      end

      if val.is_a?(Hash)
        sub_hash = val
      else
        content = val
      end

      sub_type = type.sub_type(name)

      { name: name, prefix: prefix, attributes: hash, sub_hash: sub_hash,
        content: content, sub_type: sub_type }
    end

    # @private
    def make_tag(node, prefix:, name:, sub_type:,
                 sub_hash:, content: [], attributes:)

      # TODO : check if we validate with @type.has_attribute?
      args = content
      args << attributes if attributes
      sub_node = node.document.create_element(name, args)
      sub_node.namespace = node.namespace_scopes.find { |n| n.prefix == prefix }
      node << sub_node
      parse(sub_hash, node: sub_node, type: sub_type) if sub_hash
    end
  end
end
