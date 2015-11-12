module PaperTrail
  def self.whodunnit
    User.last.try(:id) || FactoryGirl.create(:researcher).id
  end
end
