class SendGrid::ApiHeader
  attr_reader :data

  def initialize
    @data = Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
  end

  def add_recipients(recipients)
    @data[:to] = [] unless @data[:to].instance_of?(Array)
    @data[:to] |= Array.wrap(recipients)
  end

  def substitute(var, val)
    @data[:sub][var] = Array.wrap(val)
  end

  def uniq_args(val)
    @data[:unique_args] = val if val.instance_of?(Hash)
  end

  def category(cat)
    @data[:category] = cat
  end

  def add_filter_setting(fltr, setting, val)
    @data[:filters][fltr][:settings][setting] = val
  end

  def to_json
    @data.to_json
  end

  def to_folded_json
    json = to_json
    if json.size > 100
      JSON.generate(@data, :indent => ' ') # Spaces allow ActionMailer to split header automatically
    else
      json
    end
  end
end
