require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "The Regexp engine" do
  it "does that stupid thing with /[\\W]/i" do
    # 'fL' =~ U+FB02 LATIN SMALL LIGATURE FL
    # 'Ff' =~ U+FB00 LATIN SMALL LIGATURE FF
    # 'Ss' =~ U+00DF LATIN SMALL LETTER SHARP S
    "fLFfGSs".scan(/\W/).should == []
    "fLFfGSs".scan(/\W/i).should == []

    "fLFfGSs".scan(/[\W]/).should == []
    "fLFfGSs".scan(/[\W]/i).should == ["fL", "Ff", "Ss"]

    "fLFfGSs".scan(/[^\w]+/).should == []
    "fLFfGSs".scan(/[^\w]+/i).should == []

    "fLFfGSs".scan(/[^\W]+/).should == ["fLFfGSs"]
    "fLFfGSs".scan(/[^\W]+/i).should == ["fLFfGSs"]
  end
end

