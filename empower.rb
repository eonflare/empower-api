require 'active_record'
require 'grape'
require 'grape/activerecord'
require 'json'
require 'hashie_rails'

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

      desc 'Update a tip already in the database.'
      params do
        requires :id, type: Integer, desc: 'Id of the tip to update.'
        optional :name, type: String, desc: 'A short name for the tip.'
        optional :content, type: String, desc: 'The text for the tip itself.'
        optional :category, type: String, desc: 'The category the tip belongs to.'
      end
      put ':id' do
        tip = Tip.find(params[:id])
        status 404 if tip.nil?

        sanitized_params = {}
        [:name, :content, :category].each do |i|
          sanitized_params[i] = params[i] unless params[i].to_s.empty?
        end

        tip.update!(sanitized_params)
        tip
      end

      desc 'Delete a tip from the database.'
      params do
        requires :id, type: Integer, desc: 'Id of the tip to delete.'
      end
      delete ':id' do
        Tip.destroy(params[:id]) if Tip.exists?(params[:id])
        status 200
      end
    end
  end
end
