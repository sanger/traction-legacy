# frozen_string_literal: true

# lib/tasks/export_data.rake
namespace :export do
  desc 'Export data from all tables to text files'
  task data: :environment do
    ignored = %w[schema_migrations ar_internal_metadata]
    (ActiveRecord::Base.connection.tables - ignored).each do |table|
      klass = table.singularize.camelize.constantize
      File.open("public/data/#{table}.csv", 'w+') do |f|
        attributes = klass.new.attributes.keys
        f.puts attributes.join(',')
        klass.all.each do |result|
          line = [].tap do |l|
            attributes.each do |attribute|
              l << result[attribute]
            end
          end
          f.puts line.join(',')
        end
      end
    end
  end
end
