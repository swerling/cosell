#require File.join(File.dirname(__FILE__), '..', 'lib', 'strict_mash')
require File.join(File.dirname(__FILE__),"spec_helper")
require 'yaml'

describe StrictMash do
  before(:each) do
    @writer = StrictMash.new(
            :name, 
            :address,
            :publisher,  [:name, 
                          :phone, 
                          :location, [ :city, 
                                       :planet,
                                     ]
                          ],
            :phone
            )
  end
       
  it "Exception should be thrown when attemptying to access undeclared attributes" do
    lambda {@writer.nam3 = 'should blow up due to nam3'}.should raise_error
    lambda {@writer.publisher.location.zity = 'should blow up due to zity'}.should raise_error
    lambda {@writer.publisher.zlocation.planet = 'should blow up due to zlocation'}.should raise_error
  end

  it "Should not be able to use '!' syntax on StrictMash because all attributes are supposed to be pre-defined" do
    lambda {@writer.brand_new!.thing = 'should blow up'}.should raise_error
  end

  it "Should not be able to use the reserved '_attributes_allowed' key" do
    lambda {@writer.publisher._attributes_allowed = 'should blow up'}.should raise_error
  end

  it "@writer should not have a name, but should have a publisher which does not yet have any attributes" do
    @writer.publisher?.should be_true
    @writer.publisher.location?.should be_true

    @writer.name?.should be_false
    @writer.publisher.name?.should be_false
    @writer.publisher.location.city?.should be_false
    @writer.publisher.location.planet?.should be_false
  end
 
  it "@writer should have a name, and publisher in a location with a city and planet" do
    @writer.publisher.location.city = 'Gotham'
    @writer.publisher.location.city?.should be_true
    @writer.publisher.location.city.should == ('Gotham')
    @writer.publisher.location.planet = 'Earth, presumably'
    @writer.publisher.location.planet?.should be_true
    @writer.publisher.location.planet.should == ('Earth, presumably')
  end

  it "@writer should be the same before and after YAML load, but altered copy should be different" do
    @writer.name = 'Joe'
    @writer.publisher.location.city = 'Gotham'

    # Make a copy of writer joe (joe_jr). Copy should be equal to the original.
    joe_jr = YAML::load(@writer.to_yaml)
    joe_jr.name.should == 'Joe'
    joe_jr.publisher.location.city.should == 'Gotham'
    joe_jr.inspect.should == @writer.inspect

    # Alter joe_jr a bit. It should no longer be equal
    joe_jr.should == @writer
    joe_jr.name = 'The Artist'
    joe_jr.inspect.should_not == @writer.inspect
    joe_jr.should_not == @writer
  end

end


