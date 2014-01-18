module Signaling::Base::Errors
  extend ActiveSupport::Concern

  included do
    attr_reader :errors
  end

  def initialize(*args)
    self.errors = {}
    super
  end

  def errors=(error_hash)
    @errors = ActiveModel::Errors.new(self)
    error_hash.each do |attr, errors|
      errors.each {|error| self.errors.add(attr, error) }
    end if error_hash
  end
end
