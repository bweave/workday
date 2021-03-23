require "thor"

module Utils
  # A version of Thor's template that returns the rendered string instead of creating a new file.
  # Copied from https://github.com/erikhuda/thor/blob/011dc48b5ea92767445b062f971664235973c8b4/lib/thor/actions/file_manipulation.rb#L115
  def template_string(source, *args, &block)
    config = args.last.is_a?(Hash) ? args.pop : {}

    source = File.expand_path(File.join(__dir__, source.to_s))
    context = config.delete(:context) || instance_eval("binding") # rubocop: disable Style/EvalWithLocation

    # Assume Ruby 2.6+
    capturable_erb = Thor::Actions::CapturableERB.new(::File.binread(source), trim_mode: "-", eoutvar: "@output_buffer")
    content = capturable_erb.tap do |erb|
      erb.filename = source
    end.result(context)
    content = yield(content) if block
    content
  end
end
