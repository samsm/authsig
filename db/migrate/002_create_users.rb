migration 2, :create_users do
  up do
    create_table :users do
      column :id, Integer, :serial => true
      column :service, String, :length => 255
      column :login, String, :length => 255
      column :password, DataMapper::Property::BCryptHash
      column :data, DataMapper::Property::Text
    end
  end

  down do
    drop_table :users
  end
end
