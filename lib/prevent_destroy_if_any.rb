require 'prevent_destroy_if_any/version'
I18n.load_path += Dir[File.expand_path(File.dirname(__FILE__)) + "/../config/locales/*.yml"]

class ActiveRecord::Base
  def self.prevent_destroy_if_any(*association_names)
    before_destroy do |model|
      available_associations = []
      association_names.each do |association_name|
        association = model.send association_name
        unless association.blank?
          available_associations << if association.is_a?(ActiveRecord::Associations::CollectionProxy)
            association.first.class.model_name.human(:count => 2)
          else
            association.class.model_name.human
          end.downcase
        end
      end
      if available_associations.any?
        errors.add(
          :base,
          I18n.t(
            'prevent_destroy_if_any.messages.cannot_delete_parent_object',
            :parent_object => model.class.model_name.human.downcase,
            :associated_objects => available_associations.join(', ')
          )
        )
        throw :abort
      end
    end
  end
end
