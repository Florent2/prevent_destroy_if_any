require "spec_helper"

describe "prevent_destroy_if_any" do

  let(:person) { Person.create! }

  context "when there are associated records" do

    it "destroy preventing works for has_many association" do
      person.projects.create
      person.destroy
      expect(person.destroyed?).to be_falsey
    end

    it "destroy preventing works for has_one association" do
      person.create_public_profile
      person.destroy
      expect(person.destroyed?).to be_falsey
    end

    it "destroy preventing works for belongs_ association" do
      person.create_user
      person.destroy
      expect(person.destroyed?).to be_falsey
    end

    it "adds an error message" do
      person.projects.create
      person.create_public_profile
      person.destroy
      expect(person.errors[:base].first).to eq I18n.t('messages.cannot_delete_parent_object',
          :parent_object => 'person',
          :associated_objects => 'projects, public profile'
        )
    end

    it "does not prevent the destroy if the association is not listed as preventing the destroy" do
      person.logs.create
      person.destroy
      expect(person.destroyed?).to be_truthy
    end
  end

  context "when there is no associated records" do

    it "does not prevent the destroy" do
      person.destroy
      expect(person.destroyed?).to be_truthy
    end

  end
end
