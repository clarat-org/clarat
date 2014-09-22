class ChangeOrganizationsClassificationToUmbrella < ActiveRecord::Migration
  def up
    rename_column :organizations, :classification, :umbrella
    Organization.find_each do |org|
      new_string =  case org.umbrella
                    when 'Caritas'
                      :caritas
                    when 'Diakonie'
                      :diakonie
                    when 'Arbeiterwohlfahrt'
                      :awo
                    when 'Deutscher Paritätischer Wohlfahrtsverband'
                      :dpw
                    when 'Deutsches Rotes Kreuz'
                      :drk
                    when 'Zentralwohlfahrtsstelle der Juden in Deutschland'
                      :zwst
                    else
                      false
                    end
      if new_string
        org.update_column :umbrella, new_string
      end
    end

    change_column :organizations, :umbrella, :string, limit: 8
  end
end
