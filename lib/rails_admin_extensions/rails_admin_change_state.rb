require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminChangeState
end

module RailsAdmin
  module Config
    module Actions
      class ChangeState < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        # There are several options that you can set here.
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.

        register_instance_option :visible? do
          false
        end

        register_instance_option :member? do
          true
        end

        register_instance_option :controller do
          proc do
            unless @object.valid?
              error_message = t('.invalid', obj: @object.class.to_s)
              @object.errors.full_messages.each do |message|
                error_message += '<br/>' + message
              end
              flash[:error] = error_message.html_safe
              redirect_to :back
              next
            end

            @object.send("#{params[:event]}!")
            # errors if unsuccessful

            flash[:success] = t('.success')

            redirect_to :back
          end
        end
      end
    end
  end
end
