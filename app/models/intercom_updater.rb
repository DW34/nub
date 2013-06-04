class IntercomUpdater
  @queue = :intercom

  def self.perform(person_id)
    person = Person.find(person_id)
    person.update_intercom
  end
end
