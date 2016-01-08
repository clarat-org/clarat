module OffersHelper
  # put spaces in telephone number: 0303656558 -> 030 36 56 55 8
  def tel_format number
    output = ''
    number.split('').each_with_index do |c, i|
      output += i.even? ? " #{c}" : c
    end
    output
  end

  # Informative classes for category list display: how deep it's nested,
  # whether it's currently selected (active), if there are children below it
  def category_list_classes depth, children
    depth_class = "depth--#{depth}"
    children_class = (children.any? && depth <= 1) ? 'has-children' : ''
    "#{depth_class} #{children_class}"
  end
end
