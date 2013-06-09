migration 4, :create_defaults do
  up do
    create_table :defaults do
      column :id, Integer, :serial => true
      column :slug, String, :length => 255
      column :params, DataMapper::Property::Text
      column :compromised, DataMapper::Property::Boolean
    end
  end

  down do
    drop_table :defaults
  end
end
