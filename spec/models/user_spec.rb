require 'spec_helper'

describe User do
  before(:each) do
    FactoryGirl.create(:user)
  end
  
  it { should validate_uniqueness_of(:username) }
  it { should validate_presence_of(:username) }
  
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:email) }
  
  describe "validating email" do
    subject { User.new(:username => 'piggy', :password => 'bacon') }

    it "should fail when email empty" do
      subject.valid?.should be_false
      subject.errors[:email].include? "is invalid"
    end

    it "should fail when email is not valid" do
      subject.email = 'joh@doe'
      subject.valid?.should be_false
      subject.errors[:email].include? "is invalid"
    end

    it "should fail when email is valid with information" do
      subject.email = '"John Doe" <john@doe.com>'
      subject.valid?.should be_false
      subject.errors[:email].include? "is invalid"
    end

    it "should pass when email is simple email address" do
      subject.email = 'john@doe.com'
      subject.valid?.should be_true
      subject.errors[:email].should be_empty
    end

    it "should fail when email is simple email address not stripped" do
      subject.email = 'john@doe.com '
      subject.valid?.should be_false
      subject.errors[:email].include? "is invalid"
    end

    it "should fail when passing multiple simple email addresses" do
      subject.email = 'john@doe.com, maria@doe.com'
      subject.valid?.should be_false
      subject.errors[:email].include? "is invalid"
    end
  end
  
  describe "validating username" do
    subject { User.new(:email => 'piggy@pork.com', :password => 'bacon') }
    
    it 'should fail for spaces' do
      subject.username = 'porky pig'
      subject.valid?.should be_false
      subject.errors[:username].include? "Invalid character in username"
    end
    
    it 'should allow numbers' do
      subject.username = 'porkupig007'
      subject.valid?.should be_true
      subject.errors[:username].should be_empty
    end
    
    it 'should allow underscores' do
      subject.username = 'porky_pig007'
      subject.valid?.should be_true
      subject.errors[:username].should be_empty
    end
    
    it 'should allow dashes' do
      subject.username = 'porky-pig007'
      subject.valid?.should be_true
      subject.errors[:username].should be_empty
    end
    
    it 'should fail for slashes' do
      subject.username = 'porky/pig007'
      subject.valid?.should be_false
      subject.errors[:username].include? "Invalid character in username"
    end
    
    it 'should fail for at signs' do
      subject.username = 'porky@pig007'
      subject.valid?.should be_false
      subject.errors[:username].include? "Invalid character in username"
    end
  end

end
