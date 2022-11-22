require_dependency Rails.root.join("app", "controllers", "management", "users_controller").to_s

class Management::UsersController
  def create
    @user = User.new(user_params)

    if @user.email.blank?
      user_without_email
    else
      user_with_email
    end
    @user.errors.add(:date_of_birth, t("errors.messages.invalid")) if @user.date_of_birth.blank?
    @user.terms_of_service = "1"
    @user.residence_verified_at = Time.current
    @user.verified_at = Time.current
    if @user.errors.size.zero?
      if @user.save
        render :show
      else
        render :new
      end
    else
      render :new
    end
  end
end
