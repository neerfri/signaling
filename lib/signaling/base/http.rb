module Signaling::Base::Http
  extend ActiveSupport::Concern

  class UndefinedAction < StandardError
    def initialize(action)
      super("Undefined action: #{action.inspect}")
    end
  end

  included do
    class_attribute :_defined_actions
  end

  module ClassMethods
    def request(action, params = {}, &block)
      http_method = http_method_for(action)
      path = path_for(action, id: params[:id])
      scoped_params = scope_params(params.except(:id))

      response = connection.send(http_method, path, scoped_params)

      block ? block.call(response.body) : response.body
    end

    def define_action(action_name, options)
      self._defined_actions ||= {}
      unless options[:method] && options[:path]
        raise ArgumentError, ':method and :path options are required'
      end
      self._defined_actions[action_name.to_sym] = options
    end

    # convert value to params-friendly hash/array
    # this also sets parameter names for Signaling models
    def to_params(value, set_param_names_first = false)
      case value
      when Signaling::Base
        value.class.set_param_names(value.to_params)
      when Array
        value.map {|e| to_params(e, set_param_names_first) }
      when Hash
        value = set_param_names(value) if set_param_names_first
        Hash[value.map {|k,v| [k, to_params(v)]}]
      else
        value
      end
    end

    protected

    def path_for(action, options = nil)
      path = _defined_actions.try(:[], action).try(:[], :path)

      raise(UndefinedAction, action) unless path

      path.gsub(":route_key", route_key)
        .gsub(":id") { options[:id] || raise('missing :id parameter for route') }
    end

    def http_method_for(action)
      method = _defined_actions.try(:[], action).try(:[], :method)

      method || raise(UndefinedAction, action)
    end

    def scope_params(params)
      key = params.is_a?(Array) ? param_key.pluralize : param_key

      { key => to_params(params, true) }
    end

    def route_key
      ActiveModel::Naming.route_key(self).pluralize
    end

    def param_key
      ActiveModel::Naming.param_key(self)
    end

    # changes attribtue names to param names (defined by ":param_name")
    def set_param_names(params)
      HashWithIndifferentAccess.new.tap do |result|
        params.each do |k, v|
          attribute = attribute_set[k.to_sym]
          name = attribute.try(:options).try(:[], :param_name) || k
          result[name] = v
        end
      end
    end
  end

  def to_params
    clean_attributes = persisted? ? attributes : attributes.except(:id)
    self.class.to_params(clean_attributes, true)
  end

end
