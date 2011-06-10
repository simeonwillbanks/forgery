# A BIG BIG thanks to @GunGeekATX for creating http://baconipsum.com/
class Forgery::BaconIpsum < Forgery

  def self.text(what=:sentence, quantity=2, options={})
    case what
    when :character
      character(options)
    when :characters
      characters(quantity, options)
    when :word
      word(options)
    when :words
      words(quantity, options)
    when :sentence
      sentence(options)
    when :sentences
      sentences(quantity, options)
    when :paragraph
      paragraph(options)
    when :paragraphs
      paragraphs(quantity, options)
    when :title
      title(options)
    end
  end

  def self.character(options={})
    characters(1, options)
  end

  def self.characters(quantity=10, options={})
    options.merge!(:random_limit => bacon_ipsum_characters.length-quantity) if quantity.is_a?(Fixnum)

    bacon_ipsum_characters[range_from_quantity(quantity, options)]
  end

  def self.word(options={})
    words(1, options)
  end

  def self.words(quantity=10, options={})
    options.merge!(:random_limit => bacon_ipsum_words.length-quantity) if quantity.is_a?(Fixnum)

    bacon_ipsum_words[range_from_quantity(quantity, options)].join(" ")
  end

  def self.sentence(options={})
    sentences(1, options)
  end

  def self.sentences(quantity=2, options={})
    options.merge!(:random_limit => (dictionaries[:bacon_ipsum].length-quantity)) if quantity.is_a?(Fixnum)

    dictionaries[:bacon_ipsum][range_from_quantity(quantity, options)].join(" ")
  end

  def self.paragraph(options={})
    paragraphs(1, options)
  end

  def self.paragraphs(quantity=2, options={})
    options.reverse_merge!(:separator => "\n\n",
                           :wrap => {
                             :start => "",
                             :end => "" },
                           :html => false,
                           :sentences => 3)
    options.merge!(:random_limit => (dictionaries[:bacon_ipsum].length/options[:sentences])-quantity) if quantity.is_a?(Fixnum)

    if options[:html]
      options[:wrap] = { :start => "<p>",
                         :end => "</p>" }
    end

    range = range_from_quantity(quantity, options)
    start = range.first * options[:sentences]

    paragraphs = []

    range.to_a.length.times do |i|
      paragraphs << (
        options[:wrap][:start] +
        dictionaries[:bacon_ipsum][start..(start+options[:sentences]-1)].join(" ") +
        options[:wrap][:end]
      )
      start += options[:sentences]
    end

    paragraphs.join(options[:separator])
  end

  def self.title(options={})
    sentence(options).chop.gsub(/\b./){$&.upcase}
  end

protected

  def self.range_from_quantity(quantity, options={})
    return quantity if quantity.is_a?(Range)

    if options[:random]
      start = (0..options[:random_limit]).random
      start..(start+quantity-1)
    else
      0..(quantity-1)
    end
  end

  def self.bacon_ipsum_words
    @@bacon_ipsum_words ||= dictionaries[:bacon_ipsum].join(" ").downcase.gsub(/\.|,|;/, '').split(" ")
  end

  def self.bacon_ipsum_characters
    @@bacon_ipsum_characters ||= dictionaries[:bacon_ipsum].join("").downcase.gsub(/[^a-z\s]/,'')
  end

end
