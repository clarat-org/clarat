class ExtractEmailsFromContactPeople < ActiveRecord::Migration

  class ContactPerson < ActiveRecord::Base
  end
  class Email < ActiveRecord::Base
  end

  def up
    create_table :emails do |t|
      t.string :address, null: false, unique: true, limit: 64
      t.string :aasm_state, null: false, default: 'uninformed', limit: 32
      t.string :security_code, limit: 36
      t.text :log, null: false, default: ''

      t.timestamps
    end

    add_column :contact_people, :email_id, :integer
    add_index :contact_people, :email_id

    ContactPerson.where(
      'contact_people.email != ? AND contact_people.email IS NOT NULL', ''
    ).find_each do |cp|
      email = Email.find_by_address(cp['email']) ||
              Email.create!(address: cp['email'])

      cp.update_column :email_id, email.id
    end

    remove_column :contact_people, :email
  end

  def down
    add_column :contact_people, :email

    ContactPerson.where.not(email_id: nil).includes(:email).find_each do |cp|
      cp.update_column :email, cp.email.address
    end

    remove_column :contact_people, :email_id
    drop_table :emails
  end
end
