module Signaling::Base::Persistence
  extend ActiveSupport::Concern

  module ClassMethods
    def create(params)
      from_response(request(:create, scope_params(params)))
    rescue Signaling::Error::UnprocessableEntity => e
      from_response(e.response[:body])
    end

    def destroy(id)
      from_response(request(:destroy, id: id))
    end

    def scope_params(params)
      key = params.is_a?(Array) ? param_key.pluralize : param_key

      { key => to_params(params, true) }
    end

    def param_key
      ActiveModel::Naming.param_key(self)
    end
  end

  def new?
    self.id.blank?
  end

  def persisted?
    !new?
  end

  def save
    new? ? create : update
    true
  rescue Signaling::Error::UnprocessableEntity => e
    self.errors = e.response[:body][:errors]
    false
  end

  def save!
    save || raise(ResourceInvalid.new(self))
  end

  def update_attributes(params)
    update(params)
  rescue Signaling::Error::UnprocessableEntity => e
    self.attributes = e.response[:body]
    false
  end


  private

  def update(params = attributes)
    params = self.class.scope_params(params).merge(id: self.id)
    self.class.request(:update, params) do |response|
      self.attributes = response
    end
  end

  def create
    params = self.class.scope_params(attributes.except(:id))
    self.class.request(:create, params) do |response|
      self.attributes = response
    end
  end

end
