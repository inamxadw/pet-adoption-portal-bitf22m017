module ApplicationHelper
  include Pagy::Frontend
  
  def format_phone_number(phone)
    return phone if phone.blank?
    
    # Remove any non-digit characters
    digits = phone.gsub(/\D/, '')
    
    case digits.length
    when 10
      "(#{digits[0,3]}) #{digits[3,3]}-#{digits[6,4]}"
    when 11
      if digits.start_with?('1')
        "+1 (#{digits[1,3]}) #{digits[4,3]}-#{digits[7,4]}"
      else
        digits
      end
    else
      phone
    end
  end
end
