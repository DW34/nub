class Identity < ActiveRecord::Base
  col :avatar_address
  col :bio, :type => :text
  col :email
  col :name
  col :nickname
  col :provider
  col :uid
  col :person_id, :type => :integer
  col :oauth_token
  col :oauth_secret
  col :created_at, :type => :datetime, :null => false
  col :updated_at, :type => :datetime, :null => false

  attr_accessible :avatar_address, :bio, :email, :name, :nickname, :provider, :uid, :person_id, :oauth_token, :oauth_secret
  belongs_to :person, counter_cache: true, touch: true

  after_save :cache_avatar_on_person

  def cache_avatar_on_person
    person.cache_avatar if person
  end

  def self.find_by_uid_and_provider(uid, provider)
    where(uid: uid, provider: provider).blank? ? Identity.new : Identity.where(uid: uid, provider: provider).first
  end

  def self.build_profile(auth, provider)
    raise ArgumentError, 'Please provide provider as a string' unless provider.is_a?(String)
    raise ArgumentError, 'Please provide auth as a hash' unless auth.is_a?(Hash)
    uid = auth['uid']
    case provider
    when "twitter"
      name = auth['info']['name']
      nickname = auth['info']['nickname']
      bio = auth['info']['description']
      avatar  = auth['info']['image']
      {
        :uid => uid,
        :oauth_token => auth['credentials']['token'],
        :oauth_secret => auth['credentials']['secret'],
        :name => name,
        :nickname => nickname,
        :avatar_address => avatar,
        :provider => 'twitter',
        :bio => bio
      }
    else
      raise "Provider #{provider} not handled"
    end
  end

  def self.obfuscate
    Identity.all.each do |i|
      i.email = "#{SecureRandom.hex(16)}@example.com"
      i.oauth_token = SecureRandom.hex(16)
      i.oauth_secret = SecureRandom.hex(16)
      i.save
    end
  end
end
Identity.auto_upgrade!