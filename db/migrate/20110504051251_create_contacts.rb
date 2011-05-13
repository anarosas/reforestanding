class CreateContacts < ActiveRecord::Migration
  def self.up
		create_table :contacts do |t|
      t.string :nombre
      t.string :email
      t.string :twitter
    end
  end

  def self.down
		drop_table :contacts
  end
end
