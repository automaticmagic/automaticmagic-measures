# insert your copyright here

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'minitest/autorun'
require_relative '../measure.rb'
require 'fileutils'

class IdfToOsmTest < Minitest::Test
  # def setup
  # end

  # def teardown
  # end

  def test_measure
    # create an instance of the measure
    measure = IdfToOsm.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    osw.addFilePath(File.dirname(__FILE__))

    runner = OpenStudio::Measure::OSRunner.new(osw)

    idf_path = 'EP_9.5_5ZoneAirCooled.idf'

    ep_version = OpenStudio::energyPlusVersion
    if /9.2/.match(ep_version)
      idf_path = 'EP_9.2_5ZoneAirCooled.idf'
    elsif /9.3/.match(ep_version)
      idf_path = 'EP_9.3_5ZoneAirCooled.idf'
    elsif /9.4/.match(ep_version)
      idf_path = 'EP_9.4_5ZoneAirCooled.idf'
    end

    # create test model
    model = OpenStudio::Model::Model.new

    assert_equal(0, model.getSpaces.size)

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    args_hash = {}
    args_hash['idf_path'] = idf_path

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal(6, model.getSpaces.size)
    assert(result.warnings.empty?)

    # save the model to test output directory
    output_file_path = "#{File.dirname(__FILE__)}//output/test_output.osm"
    model.save(output_file_path, true)
  end
end
