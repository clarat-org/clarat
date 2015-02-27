module OffersHelper
  # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
  def tel_format number
    output = number[0..2] # 3 character area code
    number[3..-1].split('').each_with_index do |c, i|
      output += i.even? ? " #{c}" : c
    end
    output
  end
end
