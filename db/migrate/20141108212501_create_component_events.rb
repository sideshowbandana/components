class CreateComponentEvents < ActiveRecord::Migration
  def change
    create_table "component_event", :force => true do |t|
      t.string    "component",          :limit => 64,  :null => false
      t.string    "component_version",  :limit => 64,  :null => false
      t.timestamp "recorded_timestamp",                :null => false
      t.timestamp "received_timestamp",                :null => false
      t.string    "type",               :limit => 128, :null => false
      t.binary    "data",               :limit => 65535
    end

    add_index "component_event", ["component", "component_version", "type", "recorded_timestamp"], :name => "component"
  end
end
