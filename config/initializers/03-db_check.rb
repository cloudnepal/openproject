#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) the OpenProject GmbH
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

env = ENV["RAILS_ENV"] || "production"

if (db_config = ActiveRecord::Base.configurations.configs_for(env_name: env)[0]) &&
   db_config.configuration_hash["adapter"]&.start_with?("mysql")
  abort <<~ERROR
    ======= INCOMPATIBLE DATABASE DETECTED =======
    Your database is set up for use with a MySQL or MySQL-compatible variant.
    This installation of OpenProject no longer supports these variants.

    The following guides provide extensive documentation for migrating
    your installation to a PostgreSQL database:

    https://www.openproject.org/migration-guides/

    This process is mostly automated so you can continue using your
    OpenProject installation within a few minutes!

    ==============================================
  ERROR
end
