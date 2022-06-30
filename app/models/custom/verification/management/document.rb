require_dependency Rails.root.join("app", "models", "verification", "management", "document").to_s
class Verification::Management::Document
  def in_census?
    response = CensusCaller.new.call(document_type, document_number, date_of_birth)
    response.valid?
  end

  def valid_age?
    return if errors[:date_of_birth].any?

    unless allowed_age?
      errors.add(:date_of_birth, I18n.t("verification.residence.new.error_not_allowed_age"))
    end
  end
end
