require 'addressable/template'

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
      params = params.with_indifferent_access

      http_method = http_method_for(action)
      path_params, body_params = split_params(action, params)
      path = path_for(action, path_params)

      response = connection.send(http_method, path, body_params)

      block ? block.call(response.body) : response.body
    end

    def define_action(action_name, options)
      unless options[:method] && options[:path]
        raise ArgumentError, ':method and :path options are required'
      end

      actions = self._defined_actions || {}
      self._defined_actions = actions.merge(action_name.to_sym => options)
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

    def defined_action(action)
      _defined_actions.try(:[], action) or raise(UndefinedAction, action)
    end

    def split_params(action, params)
      path = defined_action(action)[:path]

      path_params = params.slice(*path_parameters(path))
      body_params = params.except(*path_parameters(path))

      return path_params, body_params
    end

    def path_parameters(path)
      path.scan(/:([^\/.]*)/).flatten
    end

    def path_for(action, parameters = {})
      path = defined_action(action)[:path]

      parameters = parameters.merge(route_key: route_key)

      path_parameters(path).each do |parameter|
        path = path.gsub(":#{parameter}", parameters[parameter].to_s)
      end

      path
    end

    def http_method_for(action)
      method = _defined_actions.try(:[], action).try(:[], :method)

      method || raise(UndefinedAction, action)
    end

    def route_key
      ActiveModel::Naming.route_key(self).pluralize
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
