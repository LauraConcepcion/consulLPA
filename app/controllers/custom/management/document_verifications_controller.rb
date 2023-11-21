require_dependency Rails.root.join("app", "controllers", "management", "document_verifications_controller").to_s

class Management::DocumentVerificationsController

  def check
    @document_verification = Verification::Management::Document.new(document_verification_params)
    @document_verification.user.verify_residence_verified_at
    if @document_verification.valid?
      if !@document_verification.residence_verified_at? && @document_verification.in_census?
        redirect_to new_management_email_verification_path(email_verification: document_verification_params.to_h)
      elsif @document_verification.residence_verified_at || @document_verification.verified?
        render :verified
      elsif @document_verification.user?
        render :new
      else
        render :invalid_document
      end
    else
      render :index
    end
  end
end
