--[[
    Copyright 2011 Iordan Iordanov <iiordanov (AT) gmail.com>
    Copyright 2022 Alchemilla Private Limited <hayzam@alchemilla.io>

    This file is part of luci-app-pbx.

    luci-app-pbx is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    luci-app-pbx is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with luci-app-pbx.  If not, see <http://www.gnu.org/licenses/>.
]]--

module("luci.controller.pbx", package.seeall)

function index()
        entry({"admin", "telephony"},                 cbi("pbx"),          "Telephony",        80)
        entry({"admin", "telephony", "pbx-overview"}, cbi("pbx"),          "Overview",          1)
        entry({"admin", "telephony", "pbx-voip"},     cbi("pbx-voip"),     "SIP Trunks",        2)
        entry({"admin", "telephony", "pbx-users"},    cbi("pbx-users"),    "Extensions",        3)
        entry({"admin", "telephony", "pbx-calls"},    cbi("pbx-calls"),    "Call Routing",      4)
        entry({"admin", "telephony", "pbx-advanced"}, cbi("pbx-advanced"), "Advanced Settings", 6)
end