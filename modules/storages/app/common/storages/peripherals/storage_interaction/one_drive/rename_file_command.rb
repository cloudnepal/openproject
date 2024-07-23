# frozen_string_literal: true

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

module Storages
  module Peripherals
    module StorageInteraction
      module OneDrive
        class RenameFileCommand
          def self.call(storage:, auth_strategy:, file_id:, name:)
            new(storage).call(auth_strategy:, file_id:, name:)
          end

          def initialize(storage)
            @storage = storage
          end

          def call(auth_strategy:, file_id:, name:)
            validate_input_data(file_id:, name:).on_failure { |failure| return failure }

            Authentication[auth_strategy].call(storage: @storage, http_options: Util.json_content_type) do |http|
              handle_response http.patch(UrlBuilder.url(Util.drive_base_uri(@storage), "items", file_id),
                                         body: { name: }.to_json)
            end
          end

          private

          def validate_input_data(file_id:, name:)
            if file_id.blank? || name.blank?
              ServiceResult.failure(result: :error,
                                    errors: StorageError.new(code: :error,
                                                             data: StorageErrorData.new(source: self.class),
                                                             log_message: "Invalid input data!"))
            else
              ServiceResult.success
            end
          end

          # rubocop:disable Metrics/AbcSize
          def handle_response(response)
            case response
            in { status: 200..299 }
              ServiceResult.success(result: Util.storage_file_from_json(response.json(symbolize_keys: true)))
            in { status: 401 }
              ServiceResult.failure(result: :unauthorized,
                                    errors: Util.storage_error(response:, code: :unauthorized, source: self.class))
            in { status: 403 }
              ServiceResult.failure(result: :forbidden,
                                    errors: Util.storage_error(response:, code: :forbidden, source: self.class))
            in { status: 404 }
              ServiceResult.failure(result: :not_found,
                                    errors: Util.storage_error(response:, code: :not_found, source: self.class))
            in { status: 409 }
              ServiceResult.failure(result: :conflict,
                                    errors: Util.storage_error(response:, code: :conflict, source: self.class))
            else
              ServiceResult.failure(result: :error,
                                    errors: Util.storage_error(response:, code: :error, source: self.class))
            end
          end

          # rubocop:enable Metrics/AbcSize
        end
      end
    end
  end
end
