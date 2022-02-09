class NoLinksValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && value.downcase.split(/(?=[.])/).any? { |x| [".com", ".org", ".dev", ".co", ".net", ".ly"].include?(x).present? }
      record.errors.add(attribute, "profile bio cannot contain any links")
    end
  end
end
