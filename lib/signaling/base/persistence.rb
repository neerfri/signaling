module Signaling::Base::Persistence
  extend ActiveSupport::Concern

  module ClassMethods
    def create(params)
      from_response(request(:create, params))
    rescue Signaling::Error::UnprocessableEntity => e
      from_response(e.response[:body])
    end

    def destroy(id)
      from_response(request(:destroy, id: id))
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
    self.class.request(:update, params.merge(id: self.id)) do |response|
      self.attributes = response
    end
  end

  def create
    self.class.request(:create, attributes.except(:id)) do |response|
      self.attributes = response
    end
  end

end
