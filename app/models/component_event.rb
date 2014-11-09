class ComponentEvent < ActiveRecord::Base
  self.table_name = "component_event"

  belongs_to :component_version_info, :class_name => ComponentVersion, :foreign_key => ["component", "component_version"]

  def self.inheritance_column
    "sti_type"
  end

  scope :by_component, ->(component, version, type){
    where(component: component, component_version: version, type: type)
  }

  scope :count_by_version, ->{
    select("date(recorded_timestamp) as recorded_date, component_version as version, count(*) as total")
  }

  scope :count_by_recorded, ->{
    select("date(recorded_timestamp) as recorded_date, count(*) as total").
    group("date(recorded_timestamp)").
    order("recorded_date DESC")
  }

  scope :count_a, ->(component, version, type) {
    by_component(component, version, type).
    count_by_recorded
  }

  scope :count_b, ->(component, version, type, min_date) {
    by_component(component, version, type).
    count_by_recorded.
    min_recorded(min_date)
  }

  scope :min_recorded, ->(min){
    where("recorded_timestamp >= ?", min)
  }

  scope :between_versions, ->(min_ver, max_ver){
    where("component_version between ? AND ?", min_ver, max_ver)
  }

  scope :exclude_zero, ->{
    where("total > 0")
  }

  scope :count_c, ->(component, min_ver, max_ver, type, min_date){
    count_by_version.
    where(component: component, type: type).
    between_versions(min_ver, max_ver).
    min_recorded(min_date).
    group("date(recorded_timestamp), component_version").
    order("recorded_date DESC")
  }

  scope :get_e, ->(component, version, type){
    select("date(recorded_timestamp) as recorded_date, data, received_timestamp").
    order("received_timestamp DESC").
    limit(25)
  }
end
