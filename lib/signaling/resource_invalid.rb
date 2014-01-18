module Signaling
  class ResourceInvalid < StandardError
    attr_reader :record

    def initialize(record)
      @record = record
      super()
    end
  end
end
