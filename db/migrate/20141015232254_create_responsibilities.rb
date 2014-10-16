class CreateResponsibilities < ActiveRecord::Migration
  def change
    create_table :responsibilities do |t|
      t.integer :actionable_id
      t.integer :user_id

      t.timestamps
    end
  end
end
