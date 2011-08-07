require "prevent_destroy_if_any/version"

class ActiveRecord::Base
  def self.prevent_destroy_if_any(*association_names)
    before_destroy do |model|
      associations_present = []

      association_names.each do |association_name|
        association = model.send association_name
        if association.class == Array
          associations_present << association_name if association.any?
        else
          associations_present << association_name if association
        end
      end

      if associations_present.any?
        errors.add :base, "Cannot delete #{model.class.model_name.human.downcase} while #{associations_present.join ', '} exist"
        return false
      end

    end
  end
end
