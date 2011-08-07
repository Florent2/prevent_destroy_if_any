prevent_destroy_if_any
===

This plugin adds ActiveRecord models a way to prevent destroy if specified `has_many`, `has_one` and/or `belongs_to` associations are present. This is achieved by adding a `before_destroy` callback that aborts the destroy and adds a base error on the instance when detecting associations.

It's inspired from [this stackoverflow answer](http://stackoverflow.com/questions/4054112/how-do-i-prevent-deletion-of-parent-if-it-has-child-records/4054170#4054170) and was created to factorize this solution when you need it for various models in an application.

It has been tested only with ActiveRecord 3.

Installation
---

`gem install prevent_destroy_if_any`

If you use Bundler, edit your `Gemfile` to add `gem 'prevent_destroy_if_any'`.


Example usage
---

A Person model for which you want to prevent destroy when it has an associated user, projects or public profile. Destroy will work if it has associated logs.

    class Person < ActiveRecord::Base
      belongs_to :user
      has_many   :projects
      has_one    :public_profile
      has_many   :logs

      prevent_destroy_if_any :user, :projects, :public_profile
    end

Then in Rails you can write your PeopleController destroy action like this:

    def destroy
      person = Person.find params[:id]
      if person.destroy
        redirect_to people_url, :notice => "Person successfully deleted"
      else
        redirect_to person, :alert => person.errors.full_messages.join
      end
    end

License
---

Copyright © 2011 Florent Guilleux, released under the MIT license.
