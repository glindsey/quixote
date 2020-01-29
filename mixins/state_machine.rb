module Mixins
  module StateMachine
    STATE_TRACING = true

    # Runs the state machine.
    def run_machine(start_state:, pass_states:, fail_states:, tape:, **args)
      args.delete(:output)

      state_tape = tape.dup
      state = start_state
      state_info = {}

      until pass_states.include?(state) || fail_states.include?(state)
        if STATE_TRACING
          warn "**** #{name} state #{state}: " \
               "tape = #{state_tape}, " \
               "info = #{state_info}"
        end

        result = send(state,
                      tape: state_tape,
                      state_info: state_info,
                      args: args)

        if STATE_TRACING
          warn "**** #{name} state #{state} END: " \
               "result = #{result}"
        end

        state = result[:state]
        state_tape = result[:tape]

        result.delete(:state)
        result.delete(:tape)

        state_info.merge!(result)
      end

      output = state_info[:output]
      state_info.delete(:output)

      if pass_states.include?(state)
        {
          success: true,
          state: state,
          tape: state_tape,
          output: output
        }.merge(state_info).tap { |res| warn "****** PASS: #{res}" }
      else
        {
          success: false,
          state: state,
          tape: tape,
          output: nil
        }.merge(state_info).tap { |res| warn "****** FAIL: #{res}" }
      end
    end
  end
end
