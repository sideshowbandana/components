class CreateComponentVersions < ActiveRecord::Migration
  def change
    create_table "component_version", :id => false, :force => true do |t|
      t.string  "component",    :limit => 64, :null => false
      t.string  "version",      :limit => 64, :null => false
      t.integer "version_code",               :null => false
    end
  end
end
