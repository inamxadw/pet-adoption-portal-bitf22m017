class CreateAdoptionApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :adoption_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.integer :status
      t.text :notes

      t.timestamps
    end
  end
end
