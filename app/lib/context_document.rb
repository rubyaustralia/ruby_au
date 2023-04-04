class ContextDocument
  MARKER = /---\s*/

  def self.all_within(directory)
    Dir["#{directory}/*"].collect { |path| new(path) }
  end

  def initialize(path)
    @path = path
  end

  def context
    @context ||= YAML.safe_load input.split(MARKER).first.strip
  end

  def document
    @document ||= input.split(MARKER).last.strip
  end

  private

  attr_reader :path

  def input
    @input ||= File.read path
  end
end
