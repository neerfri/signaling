module Signaling
  class Base
    include Virtus.model
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    autoload :Errors,       'signaling/base/errors'
    autoload :Finders,      'signaling/base/finders'
    autoload :Http,         'signaling/base/http'
    autoload :Persistence,  'signaling/base/persistence'
    autoload :UseApi,       'signaling/base/use_api'

    include Base::Errors
    include Base::Finders
    include Base::Http
    include Base::Persistence
    include Base::UseApi

    attribute :id, String

    define_action :index,   method: :get,    path: ":route_key.json"
    define_action :create,  method: :post,   path: ":route_key.json"
    define_action :show,    method: :get,    path: ":route_key/:id.json"
    define_action :update,  method: :put,    path: ":route_key/:id.json"
    define_action :destroy, method: :delete, path: ":route_key/:id.json"

    def to_param
      id
    end

  end
end
