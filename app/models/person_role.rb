class PersonRole < ActiveRecord::Base
  col :person_id, :type => :integer, :null => false
  col :role_id, :type => :integer, :null => false
end
PersonRole.auto_upgrade!
PersonRole.all