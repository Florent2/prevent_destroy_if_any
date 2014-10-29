$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require "rubygems"
require "bundler"
require "rspec"
require "active_record"
require "database_cleaner"

require "prevent_destroy_if_any"

ActiveRecord::Base.configurations = { 'test' => { :adapter => 'sqlite3', :database => ':memory:' } }
ActiveRecord::Base.establish_connection(:test)

class Person < ActiveRecord::Base
  belongs_to :user
  has_many   :projects
  has_one    :public_profile
  has_many   :logs

  prevent_destroy_if_any :user, :projects, :public_profile
end

class User < ActiveRecord::Base
  has_one :person
end

class Project < ActiveRecord::Base
  belongs_to :person
end

class PublicProfile < ActiveRecord::Base
  belongs_to :person
end

class Log < ActiveRecord::Base
  belongs_to :person
end

ActiveRecord::Base.silence(:stdout) do
  ActiveRecord::Migration.verbose = false
  ActiveRecord::Schema.define :version => 0 do
    create_table(:people)          { |t| t.string :name; t.integer :user_id }
    create_table(:users)           { |t| t.string :uid }
    create_table(:projects)        { |t| t.string :name; t.integer :person_id }
    create_table(:public_profiles) { |t| t.string :name; t.integer :person_id }
    create_table(:logs)            { |t| t.string :message; t.integer :person_id }
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
