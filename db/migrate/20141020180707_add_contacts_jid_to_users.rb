class AddContactsJidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contacts_jid, :string
  end
end
