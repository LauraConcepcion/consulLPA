require_dependency Rails.root.join("app", "models", "verification", "management", "document").to_s
class Verification::Management::Document

  def in_census?
    response = CensusCaller.new.call(document_type, document_number, date_of_birth)
    response.valid?
  end

  def residence_verified_at?
    user.residence_verified_at
  end

  def valid_age?(response)
    if under_age?(response)
      errors.add(:date_of_birth, I18n.t("verification.residence.new.error_not_allowed_age"))
      false
    else
      true
    end
  end
end
