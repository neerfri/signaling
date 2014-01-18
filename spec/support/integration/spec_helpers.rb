module IntegrationSpecHelpers
  extend ActiveSupport::Concern

  included do
    let(:item_lists_path) { example_com_build_url("item_lists.json") }
    let(:item_list_path)  { example_com_build_url("item_lists/1.json") }

    let(:index_item_list_request)   { [:get,    item_lists_path] }
    let(:create_item_list_request)  { [:post,   item_lists_path] }
    let(:get_item_list_request)     { [:get,    item_list_path ] }
    let(:update_item_list_request)  { [:put,    item_list_path ] }
    let(:destroy_item_list_request) { [:delete, item_list_path ] }
  end

  class BodyPattern < Struct.new(:expected)
    def ===(body)
      normalize!(expected) == Rack::Utils.parse_nested_query(body)
    end

    def normalize!(hash)
      Hash[stringify!(hash).sort]
    end

    def stringify!(hash)
      WebMock::Util::HashKeysStringifier.stringify_keys!(hash)
    end

    def inspect
      expected.inspect
    end
  end

  def expect_request(method, options)
    matcher = have_requested(method, options[:path])
    if options[:body]
      matcher.with(body: body_matcher(options[:body]))
    end

    to_or_to_not = options[:not] ? :to_not : :to
    expect(WebMock).send(to_or_to_not, matcher)
  end

  def expect_no_request(method, options)
    expect_request(method, options.merge(not: true))
  end

  def body_matcher(expected)
    BodyPattern.new(expected)
  end

  def example_com_build_url(path = '')
    ExampleCom::Api.connection.build_url(path).to_s
  end

  RSpec.configure do |config|
    config.include self, type: :integration,
                         example_group: { :file_path => %r(spec/integration) }
  end
end
