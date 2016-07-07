require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe "regexp quirks" do
  describe "(that stupid thing with /[\\W]/i)" do
    it "treats some letter-like characters as non-word characters" do
      (/\W/ =~ "\u00DF").should == 0  # eszett -> SS/ss
      (/\W/ =~ "\uFB00").should == 0  # ff-lig -> FF/ff
      (/\W/ =~ "\u212A").should == 0  # Kelvin -> K/k

      (/\W/ =~ "\u0132").should == 0  # IJ
      (/\W/ =~ "\u0133").should == 0  # ij
      (/\W/ =~ "\u0152").should == 0  # OE
      (/\W/ =~ "\u0153").should == 0  # oe
      (/\W/ =~ "\uFB01").should == 0  # fi
      (/\W/ =~ "\uFB02").should == 0  # fl
      (/\W/ =~ "\uFB06").should == 0  # st
      (/\W/ =~ "\u2133").should == 0  # script capital 'M'
    end

    it "doesn't match without a character class" do
      (/\W/i =~ 'SS').should == nil # ß (no cases, no decomposition, ~ 'SS'|'ss')
      (/\W/i =~ 'FF').should == nil # ﬀ (no cases, decomposition = 'f'+'f', ~ 'FF'|'ff')
      (/\W/i =~ 'k').should == nil  # K (lc = 'k', decomposition = 'K', ~ 'K'|'k')
    end

    if RUBY_VERSION < '2' || RUBY_VERSION >= '2.4'
      it "doesn't match with a character class" do
        (/[\W]/i =~ 'SS').should == nil # ß (Ll, no Lu, no decomposition, ~ 'SS'|'ss')
        (/[\W]/i =~ 'FF').should == nil # ﬀ (Ll, no Lu, decomposition = 'f'+'f', ~ 'FF'|'ff')
        (/[\W]/i =~ 'k').should == nil  # K (Lu, Ll = 'k', decomposition = 'K', ~ 'K'|'k')
      end
      it "doesn't make sense with a negated character class" do
        (/[^\W]/i =~ 'SS').should == 0
        (/[^\W]/i =~ 'FF').should == 0
        (/[^\W]/i =~ 'k').should == 0
      end
    elsif RUBY_VERSION < '2.2'
      it "matches with a character class" do
        (/[\W]/i =~ 'SS').should == 0   # ß (Ll, no Lu, no decomposition, ~ 'SS'|'ss')
        (/[\W]/i =~ 'FF').should == 0   # ﬀ (Ll, no Lu, decomposition = 'f'+'f', ~ 'FF'|'ff')
        (/[\W]/i =~ 'k').should == 0    # K (Lu, Ll = 'k', decomposition = 'K', ~ 'K'|'k')
      end
      it "sometimes doesn't make sense with a negated character class" do
        (/[^\W]/i =~ 'SS').should == nil
        (/[^\W]/i =~ 'FF').should == 0
        (/[^\W]/i =~ 'k').should == nil
      end
    else
      it "sommetimes matches with a character class" do
        (/[\W]/i =~ 'SS').should == 0   # ß (Ll, no Lu, no decomposition, ~ 'SS'|'ss')
        (/[\W]/i =~ 'FF').should == 0   # ﬀ (Ll, no Lu, decomposition = 'f'+'f', ~ 'FF'|'ff')
        (/[\W]/i =~ 'k').should == nil  # K (Lu, Ll = 'k', decomposition = 'K', ~ 'K'|'k')
      end
      it "doesn't make sense with a negated character class" do
        (/[^\W]/i =~ 'SS').should == 0
        (/[^\W]/i =~ 'FF').should == 0
        (/[^\W]/i =~ 'k').should == 0
      end
    end

    # 'fL' =~ U+FB02 LATIN SMALL LIGATURE FL
    # 'Ff' =~ U+FB00 LATIN SMALL LIGATURE FF
    # 'G'  is a word character
    # 'Ss' =~ U+00DF LATIN SMALL LETTER SHARP S
    # 's'  is a word character
    # '.'  is a non-word character

#    it "can match 'a non-word character' without character classes irrespective of case" do
#      "fLFfGSss.".scan(/\W/).should == ["."]
#      "fLFfGSss.".scan(/\W/i).should == ["."]
#    end

#    it "can match 'not a word character' with character classes irrespective of case" do
#      "fLFfGSss.".scan(/[^\w]+/).should == ["."]
#      "fLFfGSss.".scan(/[^\w]+/i).should == ["."]
#    end

#    it "only triggers with [\W] and the //i flag" do
#      "fLFfGSss.".scan(/[\W]/).should == ["."]  # case-sensitive
#      "fLFfGSss.".scan(/[\W]/i).should == ["fL", "Ff", "Ss", "."]
#    end

    # ???
#    it "does this other weird thing properly" do
#      "fLFfGSss.".scan(/[^\W]+/).should == ["fLFfGSss"]
#      "fLFfGSss.".scan(/[^\W]+/i).should == ["fLFfGSss"]
#    end
  end
end

