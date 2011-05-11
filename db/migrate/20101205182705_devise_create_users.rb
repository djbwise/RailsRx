class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.token_authenticatable

      t.string :first_name
      t.string :last_name
      t.string :facebook_id
      t.string :facebook_access_token
      t.string :profile_image
      t.boolean :is_active, :default => true
      t.integer :status, :default => 0
      
      t.integer :created_by
      t.integer :sync_token
      t.boolean :deleted
                  
      t.timestamps
    end

    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end
  
  def self.down
    drop_table :users
  end
end