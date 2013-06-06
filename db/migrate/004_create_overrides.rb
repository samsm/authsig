migration 4, :create_overrides do
  up do
    create_table :overrides do
      column :id, Integer, :serial => true
      column :slug, String, :length => 255
      column :params, DataMapper::Property::Text
      column :compromised, DataMapper::Property::Boolean
    end
  end

  down do
    drop_table :overrides
  end
end
