class OrganizationObserver < ActiveRecord::Observer
  def before_save orga
    orga.add_approved_info
  end

  def before_create orga
    current_user = ::PaperTrail.whodunnit
    orga.created_by = current_user.id if current_user # so unclean ...
  end
end
