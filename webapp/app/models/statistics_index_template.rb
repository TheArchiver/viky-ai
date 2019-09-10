class StatisticsIndexTemplate

  attr_reader :configuration, :state

  def initialize(state = 'active')
    @configuration = read_template_configuration
    @state = state
    @configuration['index_patterns'] = "#{index_full_name}-#{@state}-*"
    if @state == 'inactive'
      @configuration[:settings] = {
        number_of_shards: 1,
        number_of_replicas: 0,
        codec: 'best_compression'
      }
    end
  end

  def name
    "template-#{index_full_name}"
  end

  def version
    @configuration['version']
  end

  def index_patterns
    @configuration['index_patterns']
  end

  def index_name
    index_patterns.split('-')[1]
  end

  private
    def index_full_name
      index_patterns[0..-3]
    end

    def read_template_configuration
      template_config_dir = "#{Rails.root}/config/statistics"
      filename = 'template-stats-interpret_request_log.json'
      JSON.parse(ERB.new(File.read("#{template_config_dir}/#{filename}")).result)
    end
end
