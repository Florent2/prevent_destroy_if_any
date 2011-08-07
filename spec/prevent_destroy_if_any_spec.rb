require "spec_helper"

describe "prevent_destroy_if_any" do

  let(:person) { Person.create! }

  context "when there are associated records" do

    it "destroy preventing works for has_many association" do
      person.projects.create
      person.destroy
      person.destroyed?.should be_false
    end

    it "destroy preventing works for has_one association" do
      person.create_public_profile
      person.destroy
      person.destroyed?.should be_false
    end

    it "destroy preventing works for belongs_ association" do
      person.create_user
      person.destroy
      person.destroyed?.should be_false
    end

    it "adds an error message" do
      person.projects.create
      person.create_public_profile
      person.destroy
      person.errors[:base].first.should == "Cannot delete person while projects, public_profile exist"
    end


    it "does not prevent the destroy if the association is not listed as preventing the destroy" do
      person.logs.create
      person.destroy
      person.destroyed?.should be_true
    end
  end

  context "when there is no associated records" do

    it "does not prevent the destroy" do
      person.destroy
      person.destroyed?.should be_true
    end

  end
end
