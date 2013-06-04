class Role < ActiveRecord::Base
  col :name, :type => :string
  col :resource_id, :type => :integer
  col :resource_type, :type => :string
  col :created_at, :type => :datetime, :null => false
  col :updated_at, :type => :datetime, :null => false

  has_and_belongs_to_many :people, :join_table => :person_roles
  belongs_to :resource, :polymorphic => true

  scopify

  #todo make these
  # add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  # add_index "roles", ["name"], :name => "index_roles_on_name"
end
Role.auto_upgrade!