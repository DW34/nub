require "securerandom"

class Person < ActiveRecord::Base
  col :email, :type => :string, :default => "", :null => false
  col :encrypted_password, :type => :string, :default => ""
  col :reset_password_token, :type => :string
  col :sign_in_count, :type => :integer, :default => 0
  col :current_sign_in_ip, :type => :string
  col :last_sign_in_ip, :type => :string
  col :name, :type => :string
  col :avatar, :type => :string
  col :nickname, :type => :string
  col :confirmation_token, :type => :string
  col :unconfirmed_email, :type => :string
  col :invitation_token, :type => :string, :limit => 60
  col :invitation_limit, :type => :integer
  col :invited_by_id, :type => :integer
  col :invited_by_type, :type => :string
  col :reset_password_sent_at, :type => :datetime, :null => true
  col :remember_created_at, :type => :datetime, :null => true
  col :current_sign_in_at, :type => :datetime, :null => true
  col :last_sign_in_at, :type => :datetime, :null => true
  col :invitation_sent_at, :type => :datetime, :null => true
  col :invitation_accepted_at, :type => :datetime, :null => true
  col :confirmed_at, :type => :datetime, :null => true
  col :confirmation_sent_at, :type => :datetime, :null => true
  col :created_at, :type => :datetime, :null => false
  col :updated_at, :type => :datetime, :null => false
  col :slug, :type => :string, :null => false
  col :identities_count, :type => :integer

  #todo make these
  # add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  # add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token", :unique => true
  # add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  # add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  rolify
  devise :omniauthable, :invitable, :validatable, :database_authenticatable, :async, :rememberable, :trackable
  # Add :registerable for password login

  attr_accessible :email, :password, :password_confirmation, :name, :uid, :nickname
  attr_accessible :role_ids, :as => :admin

  validates_presence_of :nickname
  is_sluggable :nickname, :history => false, :slug_column => :slug

  has_many :identities, :dependent => :destroy
  has_one :person_meta
  has_and_belongs_to_many :roles, :join_table => :person_roles

  accepts_nested_attributes_for :identities

  before_save :lowercase_nickname

  after_save :schedule_update_intercom

  def self.find_by_slug slug
    where(:slug => slug.downcase).first
  end

  def lowercase_nickname
    self.nickname.downcase!
  end

  # and this makes sure that when users edit their details they don't have to provide a password
  # if they've signed up with omniauth provider
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def intercom_hash
    {
      user_id: id,
      name: name,
      email: email,
      created_at: created_at.to_i,
      user_hash: OpenSSL::HMAC.hexdigest("sha256", ENV["INTERCOM_SHA_KEY"], self.id.to_s)
    }
  end

  def intercom_custom_data
    {
      twitter: nickname
    }
  end

  def update_intercom
    begin
      if user = Intercom::User.find_by_user_id("#{id}")
        user.custom_data = self.intercom_custom_data
        user.save
      end
    rescue Intercom::ResourceNotFound
      puts "User #{id} #{nickname} not found on Intercom. Creating"
      user = Intercom::User.create(intercom_hash)
      user.custom_data = intercom_custom_data
      user.save
    rescue Intercom::ServiceUnavailableError
      puts "Service unavailable. Waiting"
      sleep 5
      retry
    end
  end

  def schedule_update_intercom
    Resque.enqueue(IntercomUpdater, self.id)
  end

  def self.bulk_update_intercom
    Person.all.each do |person|
      person.update_intercom
      sleep 0.3
    end
    "done"
  end

  def cache_avatar
    return if self.identities.blank?
    self.avatar = self.identities.first.avatar
    self.save
  end

  protected

  def confirmation_required?
    false
  end

end
Person.auto_upgrade!
