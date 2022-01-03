# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class IdfToOsm < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'IdfToOsm'
  end

  # human readable description
  def description
    return 'Translate IDF to OSM'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'Translates an IDF to OSM'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    # path to the IDF
    idf_path = OpenStudio::Measure::OSArgument.makeStringArgument('idf_path', true)
    idf_path.setDisplayName('IDF Path')
    idf_path.setDescription('Path to IDF file.')
    args << idf_path

    # save imported OSM
    save_osm = OpenStudio::Measure::OSArgument.makeBoolArgument('save_osm', false)
    save_osm.setDisplayName('Save OSM')
    save_osm.setDefaultValue(false)
    save_osm.setDescription('Save OSM.')
    args << save_osm

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    idf_path = runner.getStringArgumentValue('idf_path', user_arguments)
    save_osm = runner.getBoolArgumentValue('save_osm', user_arguments)

    idf_path = runner.workflow.findFile(idf_path)
    if idf_path.is_initialized
      idf_path = idf_path.get.to_s
    else
      runner.registerError("Did not find #{idf_path} in paths described in OSW file.")
      return false
    end

    # convert output requests to OSM for testing, OS App and PAT will add these to the E+ Idf
    workspace = OpenStudio::Workspace.load(idf_path)

    if workspace.empty?
      runner.registerError("Could not load IDF from path '#{idf_path}'")
      return false
    end
    workspace = workspace.get

    handles = []
    model.objects.each {|obj| handles << obj.handle}
    model.removeObjects(handles)

    rt = OpenStudio::EnergyPlus::ReverseTranslator.new
    new_model = rt.translateWorkspace(workspace)

    # output meter names can cause issues when adding to a model
    new_model.getOutputMeters.each {|meter| meter.remove}

    result = model.addObjects(new_model.toIdfFile.objects)
    runner.registerInfo("Imported '#{result.size}' objects from IDF")

    if save_osm
      model.save('imported.osm', true)
    end

    return true
  end
end

# register the measure to be used by the application
IdfToOsm.new.registerWithApplication
