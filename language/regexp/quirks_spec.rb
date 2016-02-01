require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "regexp quirks" do
  describe "(that stupid thing with /[\\W]/i)" do
    # 'fL' =~ U+FB02 LATIN SMALL LIGATURE FL
    # 'Ff' =~ U+FB00 LATIN SMALL LIGATURE FF
    # 'G'  is a word character
    # 'Ss' =~ U+00DF LATIN SMALL LETTER SHARP S
    # 's'  is a word character
    # '.'  is a non-word character

    it "can match 'a non-word character' without character classes irrespective of case" do
      "fLFfGSss.".scan(/\W/).should == ["."]
      "fLFfGSss.".scan(/\W/i).should == ["."]
    end

    it "can match 'not a word character' with character classes irrespective of case" do
      "fLFfGSss.".scan(/[^\w]+/).should == ["."]
      "fLFfGSss.".scan(/[^\w]+/i).should == ["."]
    end

    it "only triggers with [\W] and the //i flag" do
      "fLFfGSss.".scan(/[\W]/).should == ["."]  # case-sensitive
      "fLFfGSss.".scan(/[\W]/i).should == ["fL", "Ff", "Ss", "."]
    end

    # ???
    it "does this other weird thing properly" do
      "fLFfGSss.".scan(/[^\W]+/).should == ["fLFfGSss"]
      "fLFfGSss.".scan(/[^\W]+/i).should == ["fLFfGSss"]
    end
  end
end

