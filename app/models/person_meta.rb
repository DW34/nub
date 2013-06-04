class PersonMeta < ActiveRecord::Base
  col :referrer_url, :type => :string, :limit => 10000
  col :landing_page, :type => :string, :limit => 10000
  col :mixpanel_id, :type => :string, :limit => 10000
  col :person_id, :type => :integer
  col :created_at, :type => :datetime, :null => false
  col :updated_at, :type => :datetime, :null => false

  attr_accessible :landing_page, :mixpanel_id, :referrer_url, :person_id
  belongs_to :person

  def self.create_for_person(person, referrer, landing_page)
    PersonMeta.create!(referrer_url: referrer, landing_page: landing_page, person_id: person.id)
  end

end
PersonMeta.auto_upgrade!