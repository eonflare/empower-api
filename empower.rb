require 'active_record'
require 'grape'
require 'grape/activerecord'
require 'json'

require_relative 'models/tips'

module Empower
  class API < Grape::API
    include Grape::ActiveRecord::Extension

    version 'v1', using: :header, vendor: :empower
    format :json
    prefix :api

    resource :tips do
      desc 'Add a quick tip to the tips database.'
      post do
        puts 'Hello World!'
      end

      desc 'Retrieve everything in the tips database.'
      get do
        Tips.all
      end
    end
  end
end
