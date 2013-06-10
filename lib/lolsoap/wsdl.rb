require 'lolsoap/wsdl_parser'

module LolSoap
  class WSDL
    require 'lolsoap/wsdl/operation'
    require 'lolsoap/wsdl/type'
    require 'lolsoap/wsdl/null_type'
    require 'lolsoap/wsdl/element'
    require 'lolsoap/wsdl/null_element'

    # Create a new instance by parsing a raw string of XML
    def self.parse(raw)
      new(WSDLParser.parse(raw))
    end

    # The SOAP endpoint URL
    attr_reader :endpoint

    # Hash of namespaces used in the WSDL document (keys are prefixes)
    attr_reader :namespaces

    # Namespaces used by the types (a subset of #namespaces)
    attr_reader :type_namespaces

    # Hash of namespace prefixes used in the WSDL document (keys are namespace URIs)
    attr_reader :prefixes

    # The version of SOAP detected.
    attr_reader :soap_version

    def initialize(parser)
      @parser          = parser
      @types           = load_types(parser)
      @operations      = load_operations(parser)
      @endpoint        = parser.endpoint
      @namespaces      = parser.namespaces
      @type_namespaces = load_type_namespaces(parser)
      @prefixes        = parser.prefixes
      @soap_version    = parser.soap_version
    end

    # Hash of operations that are supports by the SOAP service
    def operations
      @operations.dup
    end

    # Get a single operation
    def operation(name)
      @operations.fetch(name)
    end

    # Hash of types declared by the service
    def types
      @types.dup
    end

    # Get a single type, or a NullType if the type doesn't exist
    def type(name)
      @types.fetch(name) { NullType.new }
    end

    def inspect
      "<#{self.class} " \
      "namespaces=#{@namespaces.inspect} " \
      "operations=#{@operations.keys.inspect} " \
      "types=#{@types.keys.inspect}>"
    end

    private

    # @private
    def load_operations(parser)
      Hash[
        parser.operations.map do |k, op|
          [k, Operation.new(self, op[:action], operation_type(op[:input]), operation_type(op[:output]))]
        end
      ]
    end

    # @private
    def load_types(parser)
      Hash[
        parser.types.map do |prefixed_name, type|
          [prefixed_name, build_type(type)]
        end
      ]
    end

    # @private
    def load_type_namespaces(parser)
      Hash[
        parser.types.merge(parser.elements).values.map do |el|
          [el[:prefix], namespaces[el[:prefix]]]
        end
      ]
    end

    # @private
    def operation_type(name)
      if @types[name]
        @types[name]
      elsif el = @parser.elements[name]
        build_element(el)
      else
        NullType.new
      end
    end

    # @private
    def build_type(params)
      Type.new(
        params[:name],
        params[:prefix],
        build_elements(params[:elements]),
        params[:attributes]
      )
    end

    # @private
    def build_elements(elements)
      Hash[
        elements.map do |name, el|
          [name, build_element(el)]
        end
      ]
    end

    # @private
    def build_element(params)
      Element.new(
        self,
        params[:name],
        params[:prefix],
        element_type(params[:type]),
        params[:singular]
      )
    end

    # @private
    def element_type(data)
      if data.is_a?(String)
        data
      else
        build_type(data)
      end
    end
  end
end
