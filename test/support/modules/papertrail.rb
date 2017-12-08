module PaperTrail
  def self.whodunnit
    User.last.try(:id) || FactoryBot.create(:researcher).id
  end
end
