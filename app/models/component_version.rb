class ComponentVersion < ActiveRecord::Base
  self.table_name = "component_version"

  self.primary_keys = :component, :version

  has_many :component_events

end
