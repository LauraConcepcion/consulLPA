require_dependency Rails.root.join("app", "models", "verification", "residence").to_s
class Verification::Residence
  def local_residence
    return if errors.any?

    unless residency_valid?
      errors.add(residency_errors, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  private

    def census_data
      @census_data ||= CensusCaller.new.call(document_type, document_number, date_of_birth)
    end

    def residency_valid?
      census_data.valid?
    end

    def gender
      "-"
    end

    def residency_errors
      census_data.errors
    end

    def document_number_uniqueness
      errors.add(:document_number, I18n.t("errors.messages.taken")) if User.active.where(document_number: document_number).where.not(id: user.id).any?
    end
end
