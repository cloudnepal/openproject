#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2023 the OpenProject GmbH
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

module Storages::Admin
  class ProviderTypeSelectForm < ApplicationForm
    form do |select_form|
      select_form.select_list(
        name: :provider_type,
        label: I18n.t('activerecord.attributes.storages/storage.provider_type'),
        caption: I18n.t('storages.forms.general_information.provider_type_select_form.nextcloud_caption'),
        include_blank: false,
        required: true
      ) do |storage_provider_list|
        ::Storages::Storage::PROVIDER_TYPES.each do |provider_type|
          storage_provider_list.option(
            label: I18n.t("storages.provider_types.#{::Storages::Storage.shorten_provider_type(provider_type)}.name"),
            value: provider_type
          )
        end
      end
    end
  end
end
