# frozen_string_literal: true

module FactoryGirlHelpers
  def build_attributes_for(model, *without)
    build(model).attributes.except('id', 'created_at', 'updated_at', *without)
  end

  def build_attributes_list_for(model, n, *without)
    [].tap do |attributes_list|
      n.times do |_i|
        attributes_list << build_attributes_for(model, *without)
      end
    end
  end

  def build_nested_attributes_for(nested_attributes)
    nested_attributes.each_with_index.each_with_object({}) do |(attributes, index), result|
      result[index] = attributes
    end
  end
end

FactoryGirl::Syntax::Methods.send(:include, FactoryGirlHelpers)
