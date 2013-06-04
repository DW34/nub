class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    oauthorize "facebook"
  end

  def twitter
    oauthorize "twitter"
  end

  def passthru
    render template: 'pages/error_404', status: 404
  end

  def failure
    flash[:error] = "Sorry, authentication failed."
    redirect_to root_url
  end

  private

  def oauthorize(provider)
    auth = env['omniauth.auth']
    identity = Identity.find_by_uid_and_provider(auth['uid'], provider)
    auth_attr = Identity.build_profile(auth, provider)

    if identity.update_attributes(auth_attr)
      if identity.person.nil?
        @person = Person.new(name: identity.name, nickname: identity.nickname)
        @person.identities << identity # can we make this prettier?
        if @person.save
          @person_meta = PersonMeta.create_for_person(@person, session[:referrer], session[:landing_page])
        else
          redirect_to root_url # will this blow up?
        end
      else
        @person = identity.person
      end
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", :kind => provider)
      sign_in_and_redirect(@person, :event => :authentication)
    else
      redirect_to root_url
    end
  end
end