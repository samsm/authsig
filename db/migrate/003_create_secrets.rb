migration 3, :create_secrets do
  up do
    create_table :secrets do
      column :id, Integer, :serial => true
      column :random, String, :length => 255
      column :valid_start, DateTime
      column :valid_end, DateTime
      column :created_at, DateTime
      column :login, String
      column :service, String
    end
  end

  down do
    drop_table :secrets
  end
end
