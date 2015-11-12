module PaperTrail
  def self.whodunnit
    User.last || FactoryGirl.create(:researcher)
  end
end
