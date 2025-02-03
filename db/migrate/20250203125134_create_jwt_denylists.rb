class CreateJwtDenylists < ActiveRecord::Migration[7.2]
  def change
    create_table :jwt_denylists do |t|
      t.string :jti
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :jwt_denylists, :jti
  end
end
