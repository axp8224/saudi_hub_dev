class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      user = User.from_google(**from_google_params)
    
      if user.present?
        if user.sign_in_count == 0
          UserMailer.virtual_welcome(user).deliver_now
          sign_out_all_scopes
          session[:temp_user_id] = user.id # Store user ID temporarily
          redirect_to privacy_policy_modal_path # Redirect to modal page
        else
          sign_out_all_scopes
          flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
          sign_in_and_redirect user, event: :authentication
        end
      else
        flash[:alert] = t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
        redirect_to new_user_session_path
      end
    end

    def show_privacy_policy
      @user = User.find(session[:temp_user_id])
      render :show_privacy_policy
    end
    
    def accept_privacy_policy
      @user = User.find(params[:user_id])
      
      if params[:accept] == 'true'
        sign_in @user
        session.delete(:temp_user_id) # Remove temporary user ID
        flash[:success] = "Thank you for accepting the privacy policy."
        redirect_to edit_user_profile_path
      else
        session.delete(:temp_user_id) # Remove temporary user ID
        flash[:alert] = "You need to accept the privacy policy to continue."
        redirect_to root_path
      end
    end    
  
    protected
  
    def after_omniauth_failure_path_for(_scope)
      new_user_session_path
    end
  
    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || (resource_or_scope.sign_in_count == 1 ? edit_user_profile_path : root_path)    
    end
  
    private
  
    def from_google_params
      @from_google_params ||= {
      uid: auth.uid,
      email: auth.info.email,
      full_name: auth.info.name,
      avatar_url: auth.info.image,
    }
    end
  
    def auth
      @auth ||= request.env['omniauth.auth']
    end
end