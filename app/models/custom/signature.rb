require_dependency Rails.root.join("app", "models", "signature").to_s
class Signature
  def in_census?
    document_types.find do |document_type|
      response = CensusCaller.new.call(document_type, document_number, date_of_birth)
      if response.valid?
        @census_api_response = response
        true
      else
        false
      end
    end

    @census_api_response.present?
  end
end
