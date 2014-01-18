require 'active_support/all'
require 'faraday'
require 'virtus'
require 'active_model'

module Signaling
  autoload :Api,        'signaling/api'
  autoload :Base,       'signaling/base'
  autoload :Error,      'signaling/error'
end
