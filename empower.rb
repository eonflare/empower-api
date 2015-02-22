require 'active_record'
require 'grape'
require 'grape/activerecord'
require 'json'

require_relative 'models/tip'

module Empower
  class API < Grape::API
    include Grape::ActiveRecord::Extension

    version 'v1', using: :header, vendor: :empower
    format :json
    prefix :api

    resource :tips do
      desc 'Add a quick tip to the tips database.'

      params do
        requires :name, type: String, desc: 'A short name for the tip.'
        requires :content, type: String, desc: 'The text for the tip itself.'
        requires :category, type: String, desc: 'The category the tip belongs to.'
      end
      post do
        params.permit(:name, :content, :category)
        Tip.create!(
          name: params[:name],
          content: params[:content],
          category: params[:category]
        )
      end

      desc 'Retrieve everything in the tips database.'
      get do
        Tip.all
      end
    end
  end
end
