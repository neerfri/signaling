require_relative '../example_com'
require_relative 'item'

class ExampleCom::ItemList < Signaling::Base
  use_api ExampleCom::Api

  attribute :name, String
  attribute :items, Array[ExampleCom::Item]
  attribute :tags, Array, param_name: :list_tags
end
