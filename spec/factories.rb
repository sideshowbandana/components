# This will guess the User class
FactoryGirl.define do
  3.times do |n|
    factory "component_event_#{n}", :class => :component_event do
      component "foo#{n}"
      component_version "1.0.#{n}"
      recorded_timestamp n.seconds.from_now
      received_timestamp n.seconds.from_now + 10
      type "ERROR_FATAL#{n}"
      data "A" * 50
    end
    factory "component_version_#{n}", :class => :component_version do
      component "foo#{n}"
      version "1.0.#{n}"
      version_code "10#{n}".to_i
    end
  end
end
