require 'rails_helper'

RSpec.describe ComponentEvent, :type => :model do
  subject!{
    @ver = FactoryGirl.create :component_version_1
    FactoryGirl.create :component_event_1
  }
  context "with a ComponentVersion" do
    its(:component_version_info){
      should == @ver
    }
  end

  before(:each) do
    @component_event = FactoryGirl.create :component_event_1, :recorded_timestamp => 1.month.ago
    FactoryGirl.create :component_event_1, :recorded_timestamp => 1.month.ago
    @ver2 = FactoryGirl.create :component_version_2
  end

  context "a) Given a component (component_version.component), a
 component version (component_version.version), and an event type
 (component_event.type), for each year and month in which the
 component recorded a matching event (an event whose component,
 component version, and type equal those provided), " do

    it "should count the total number of matching events and sort the
 results in reverse chronological order by year and month recorded
 (more recent dates first)." do
      q = ComponentEvent.count_a(@ver.component,
                                 @ver.version,
                                 @component_event.type).to_a
      expected = [[1, Time.now.utc.to_date], [2, 1.month.ago.to_date]]
      expect(q.map{ |a| [a.total, a.recorded_date]}).to eq expected

      expected = []
      q = ComponentEvent.count_a(@ver2.component,
                                 @ver2.version,
                                 @component_event.type).to_a
      expect(q.map{ |a| [a.total, a.recorded_date]}).to eq expected
    end
  end

  context "b) Given a component (component_version.component), a component
version (component_version.version), an event type
(component_event.type), and a minimum recorded date (a year, month,
and day of month), for each date greater than or equal to the minimum
on which the component recorded a matching event (an event whose
component, component version, and type equal those provided)" do
    #I'm assuming that this means count the number of events per day similar to (a)
    it "should count the total number of matching events and sort the
results in reverse chronological order." do
      q = ComponentEvent.count_b(@ver.component,
                                 @ver.version,
                                 @component_event.type,
                                 1.day.ago).to_a
      expected = [[1, Time.now.utc.to_date]]
      expect(q.map{ |a| [a.total, a.recorded_date]}).to eq expected
    end
  end


  context "c) Given a component (component_version.component), a minimum
component version (component_version.version), a maximum component
version, an event type (component_event.type), and a minimum recorded
timestamp (component_event.recorded_timestamp), for each version of
the provided component which is greater than or equal to the minimum
and less than or equal to the maximum (as determined by
component_version.version_code)" do

    it "should count the number of events of the
provided type recorded no earlier than the minimum recorded date,
excluding versions with a count of zero from the result." do
      min_date = 2.days.ago.to_date
      ver_1b = FactoryGirl.create :component_version_1, :version => @ver2.version
      FactoryGirl.create(:component_event_1,
                         :component => ver_1b.component,
                         :component_version => @ver.version,
                         :recorded_timestamp => min_date)

      3.times{
        FactoryGirl.create(:component_event_1,
                           :component => ver_1b.component,
                           :component_version => ver_1b.version,
                           :recorded_timestamp => min_date)
      }

      q = ComponentEvent.count_c(@ver.component,
                                 @ver.version,
                                 @ver2.version,
                                 @component_event.type,
                                 min_date)

      expected = [[1, @ver.version, Time.now.utc.to_date],
                  [1, @ver.version, min_date],
                  [3, ver_1b.version, min_date]]
      expect(q.map{ |a| [a.total, a.version, a.recorded_date]}).to eq expected
    end
  end

  context "d) The same query as (c), but including versions with a
count of zero in the result: Given a component
(component_version.component), a minimum component version
(component_version.version), a maximum component version, an event
type (component_event.type), and a minimum recorded timestamp
(component_event.recorded_timestamp), for each version of the provided
component which is greater than or equal to the minimum and less than
or equal to the maximum (as determined by
component_version.version_code)" do

    it "should count the number of events of the provided type
recorded no earlier than the minimum recorded date, including versions
with a count of zero in the result." do
      # huh?
    end
  end

  context "e) Given a component (component_version.component), a
component version (component_version.version), and an event type
(component_event.type)" do

#     it "should list the recorded timestamp
# (component_event.recorded_timestamp) and data (component_event.data)
# for the most recently received 25 matching events (events whose
# component, component version, and type equal those provided), sorted
# in reverse chronological order by the timestamp of receipt
#   (component_event.received_timestamp)." do
    it "does stuff" do
      FactoryGirl.create(:component_event_1,
                         :data => "BAD",
                         :received_timestamp => 1.second.ago)
      expected_events = (1..25).map{ |n|
        a = FactoryGirl.create(:component_event_1,
                               :data => n,
                               :received_timestamp => n.days.from_now)
        [a.received_timestamp.to_s, a.data.to_s]
      }.reverse
      q = ComponentEvent.get_e(@ver.component,
                               @ver.version,
                               @component_event.type).to_a
      expect(q.map{ |a| [a.received_timestamp.to_s, a.data]}).to eq expected_events
    end
  end
end
