require 'csv'
require 'pdf-reader'

class Opinion
  def initialize(file)
    @reader = PDF::Reader.new(file)
    @text = self.text
  end

  def text
    text = @reader.pages.map {|page| page.text}
    text = text.join
    text = text.gsub(/[,]/ ,"")
    text
  end

  def citation
    @text.match('^([^\s]+)').to_s.strip
  end

  def forum
    @text.match('(?:\r\n?|\n){2}(.+)').to_s.strip
  end

  def case_number
    @text.match('^(?=.*(No\.|Nos\.) ).*$').to_s.strip
  end

  def appellants
    text_between('Appellants:', 'Vs.').split.join(" ")
  end

  def date_decided
    text_between('Decided On:', 'Appellants:')
  end

  def respondents
    text_between('Respondent:', "Hon\'ble Judges/Coram:\n").split.join(" ")
  end

  def casenote
    if self.has_casenote?
        casenote = text_between("Case Note:\n", "ORDER\n") if self.is_order?
        casenote = text_between("Case Note:\n", "JUDGMENT\n") if self.is_judgment?
    else
      casenote = 'COULD NOT FIND CASE NOTE'
    end

    casenote
  end

  def is_order?
    @text.include?("ORDER\n")
  end

  def is_judgment?
    @text.include?("JUDGMENT\n")
  end
  
  def has_casenote?
    @text.include?("Case Note:\n")
  end

  private 

  def text_between(phrase1, phrase2)
    @text.split(phrase1).last.split(phrase2).first
  end

end
