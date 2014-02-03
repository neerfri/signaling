# Signaling

Signaling is a Ruby library that provides a 
[simple](http://www.infoq.com/presentations/Simple-Made-Easy)
API to work with remote objects exposed through HTTP services.

Main goals for this project are:

1. expose a simple API that will feel native in rails controllers (read
   ActiveRecord like)
1. have as least lines of code as possible
1. To **NEVER** implement auto-loading associations

## Installation

Add this line to your application's Gemfile:

    gem 'signaling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install signaling

## Usage

1. Define a namespace and remote API:
    ```ruby
    # app/models/example_com.rb
    module ExampleCom
      Api = Signaling::Api.new(url: "http://example.com/api")

      def self.use_relative_model_naming?
        true
      end
    end
    ```

    The `use_relative_model_naming?` tells `ActiveModel::Naming` to build the
    names of classes without the namespace.
    [read more](https://coderwall.com/p/heed_q)

1. Define a model:
    ```ruby
    # app/models/example_com/item_list.rb
    class ExampleCom::ItemList < Signaling::Base
      use_api ExampleCom::Api

      attribute :name, String
    end
    ```

## Features

### Attributes

Attribute definition is implemented by [virtus](https://github.com/solnic/virtus).

To change the key used to send the attribute to the remote server use the
`:param_name` option.

    attribute :name, String, param_name: :title

  This will send the attribute to the server as `:title`. this will **not**
  parse it as `:title` from the remote response.


### Nested models

Virtus provides an API for typed arrays, these can contain other Signaling models.

```ruby
# app/models/example_com/item.rb
module ExampleCom
  class Item < Signaling::Base
    attribtue :name, String
  end
end
```

```
# app/models/example_com/item_list.rb
module ExampleCom
  class ItemList < Signaling::Base
    use_api ExampleCom::Api

    attribute :name
    attribute :items, Array[ExampleCom::Item]
  end
end
```

**Tip!**&trade; Use this in combination with `:param_name` when using rails's
`accepts_nested_attributes_for`.

    module ExampleCom
      class ItemList < Signaling::Base
        use_api ExampleCom::Api

        attribute :items, Array[ExampleCom::Item], param_name: :items_attributes
      end
    end


### Api Setup

`Signaling::Api.new` accepts the following options:

  * `:url` - The base URL for the remote API
  * `:logger` - A `Logger`-compatible object to use for logging

It also accepts a block that yields with the faraday connection to allow adding
custom middleware.

    Api = Signaling::Api.new(url: api_base_url) do |faraday|
      faraday.use SomeCustomFaradayMiddleware
    end


### Errors

Signaling handles errors returned from the remote service in the `errors` json
field. It uses `ActiveModel::Errors` for this so all the rails tricks should
work here.

    > list = ExampleCom::ItemList.new(name: 'My list')
    > list.save

If the remote service will respond with HTTP status code 422 (Unprocessable Entity)
and the following json body:

    {
      "name": "My list",
      "errors": {
        "items": ["can not be empty"]
      }
    }

Then signaling will load these errors to the `ItemList` models

    > list.errors.full_messages
    => ["Items can not be empty"]

### Usage in controllers

[Here's a typical rails controller for a Signaling model](spec/support/integration/item_lists_controller.rb)

This file serves as a reference implementation for a controller and as a guide
to make sure Signaling follows it's main goal.


### Custom action paths

To change the URL of a specific action:

    module ExampleCom
      class ItemList < Signaling::Base
        use_api ExampleCom::Api

        define_action :index, method: :get, path: 'accounts/:account_id/item_lists.json'
      end
    end

Then you can use:

    > lists = ExampleCom::ItemList.all(account_id: '123')
    # GET /accounts/123/item_lists.json


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
