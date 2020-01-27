module Mixins
  module StateMachine
    STATE_TRACING = false

    def run_machine(start_state:, end_states:, input:, output: [], args:)
      state_input = input
      state_output = output
      state = start_state
      state_args = args

      until end_states.include?(state)
        if STATE_TRACING
          warn "**** #{name} state #{state} BEGIN: " \
               "input = #{state_input}, output = #{state_output}"
        end

        result = send(state,
                      input: state_input,
                      output: state_output,
                      args: state_args)

        if STATE_TRACING
          warn "**** #{name} state #{state} END: " \
               "input = #{result[:input]}, output = #{result[:output]}, " \
               "new state = #{result[:state]}"
        end

        state = result[:state]
        state_input = result[:input]
        state_output = result[:output]
        state_args.merge(result[:args]) if result.key?(:args)
      end

      {
        state: state,
        input: state_input,
        output: state_output,
        args: state_args
      }
    end
  end
end
