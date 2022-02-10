# frozen_string_literal: true

class NoLinksValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && %r{(https?://)?\w*\.\w+(\.\w+)*(/\w+)*(\.\w*)?}.match(value).to_s.present?
      record.errors.add(attribute, "profile bio cannot contain any links")
    end
  end
end
