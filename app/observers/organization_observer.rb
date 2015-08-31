class OrganizationObserver < ActiveRecord::Observer
  def before_save orga
    orga.generate_html!
  end

  def before_create orga
    return if orga.created_by
    current_user = ::PaperTrail.whodunnit
    orga.created_by = current_user if current_user.is_a? Integer # so unclean
  end
end
