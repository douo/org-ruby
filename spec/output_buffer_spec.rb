require 'spec_helper'

describe Orgmode::OutputBuffer do

  it "computes outline level numbering" do
    output_buffer = Orgmode::OutputBuffer.new ""
    expect(output_buffer.get_next_headline_number(1)).to eql("1")
    expect(output_buffer.get_next_headline_number(1)).to eql("2")
    expect(output_buffer.get_next_headline_number(1)).to eql("3")
    expect(output_buffer.get_next_headline_number(1)).to eql("4")
    expect(output_buffer.get_next_headline_number(2)).to eql("4.1")
    expect(output_buffer.get_next_headline_number(2)).to eql("4.2")
    expect(output_buffer.get_next_headline_number(1)).to eql("5")
    expect(output_buffer.get_next_headline_number(2)).to eql("5.1")
    expect(output_buffer.get_next_headline_number(2)).to eql("5.2")
    expect(output_buffer.get_next_headline_number(4)).to eql("5.2.0.1")
  end

  it "property drawer inheritance" do
    parser = Orgmode::Parser.load(InheritedPropertiesFile)
    parser.headlines.each do |h|
      puts h.body_lines
      puts
    end
    def translate(lines, output_buffer)
      output_buffer.output_type = :start
      lines.each { |line| output_buffer.insert(line) }
      output_buffer.pop_mode while output_buffer.current_mode
    end
    output_buffer = Orgmode::OutputBuffer.new ""

    translate(parser.headlines[0].body_lines, output_buffer)
    expect(output_buffer.get_current_headline_property("ID")).to eql("1")
    expect(output_buffer.get_current_headline_property("SLUG")).to eql("H1")

    translate(parser.headlines[1].body_lines, output_buffer)
    expect(output_buffer.get_current_headline_property("ID")).to eql("11")
    expect(output_buffer.get_current_headline_property("SLUG")).to eql("H1")

    translate(parser.headlines[2].body_lines, output_buffer)
    expect(output_buffer.get_current_headline_property("ID")).to eql("111")
    expect(output_buffer.get_current_headline_property("SLUG")).to eql("H111")

    translate(parser.headlines[3].body_lines, output_buffer)
    expect(output_buffer.get_current_headline_property("ID")).to eql("1")
    expect(output_buffer.get_current_headline_property("SLUG")).to eql("H1")

    translate(parser.headlines[4].body_lines, output_buffer)
    expect(output_buffer.get_current_headline_property("ID")).to eql("2")
    expect(output_buffer.get_current_headline_property("SLUG")).to eql(nil)
  end
end
