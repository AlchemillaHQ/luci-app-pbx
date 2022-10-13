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
local fs  = require "nixio.fs"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local table = require("table")
local psstring = "ps axfw" --set command we use to get pid

modulename = "pbx"

if     nixio.fs.access("/etc/init.d/asterisk")   then
   server = "asterisk"
else
   server = ""
end

-- Returns formatted output of string containing only the words at the indices
-- specified in the table "indices".
function format_indices(string, indices)
   if indices == nil then
      return "Error: No indices to format specified.\n" 
   end

   -- Split input into separate lines.
   lines = luci.util.split(luci.util.trim(string), "\n")
   
   -- Split lines into separate words.
   splitlines = {}
   for lpos,line in ipairs(lines) do
      splitlines[lpos] = luci.util.split(luci.util.trim(line), "%s+", nil, true)
   end
   
   -- For each split line, if the word at all indices specified
   -- to be formatted are not null, add the formatted line to the
   -- gathered output.
   output = ""
   for lpos,splitline in ipairs(splitlines) do
      loutput = ""
      for ipos,index in ipairs(indices) do
         if splitline[index] ~= nil then
            loutput = loutput .. string.format("%-40s", splitline[index])
         else
            loutput = nil
            break
         end
      end
      
      if loutput ~= nil then
         output = output .. loutput .. "\n"
      end
   end
   return output
end


m = Map (modulename, translate("Overview"), "This page provides an overview of the telephony services. ")

-----------------------------------------------------------------------------------------
overviewSection = m:section(SimpleSection, "Service Status", "All the service statuses for telephony services are shown below.")

local astVerion = overviewSection:option(DummyValue, "astVersion", "Asterisk Version")
astVerion.template = "cbi/value"
astVerion.value = luci.util.trim(luci.sys.exec("asterisk -V | grep 'Asterisk' | cut -d' ' -f2"))
astVerion.readonly = true

local astServiceStatus = overviewSection:option(DummyValue, "astServiceStatus", "Asterisk Service Status")
astServiceStatus.template = "cbi/value"
astServiceStatus.readonly = true

local serviceStatus = luci.util.exec("service asterisk status")

if string.find(serviceStatus, "running") then
   astServiceStatus.value = "✔️ Running"
else
   astServiceStatus.value = "❌ Not Running"
end

local astUptime = overviewSection:option(DummyValue, "astUptime", "Asterisk Uptime")
astUptime.template = "cbi/value"
astUptime.readonly = true
astUptime.value = luci.util.exec("asterisk -rx 'core show uptime' | grep 'System uptime' | awk '{print $3, $4, $5, $6, $7, $8}'")

local astRegistered = overviewSection:option(DummyValue, "astRegistered", "Registered SIP Trunks")
astRegistered.template = "cbi/value"
astRegistered.readonly = true
astRegistered.value = luci.util.exec("asterisk -rx 'sip show registry' | grep 'Registry' | wc -l")

local astActiveCalls = overviewSection:option(DummyValue, "astActiveCalls", "Active Calls")
astActiveCalls.template = "cbi/value"
astActiveCalls.readonly = true
astActiveCalls.value = luci.util.exec("asterisk -rx 'core show channels' | grep 'active call' | awk '{print $1}'")

local astExtensions = overviewSection:option(DummyValue, "astExtensions", "Extensions")
astExtensions.template = "cbi/value"
astExtensions.readonly = true

local tVal = luci.util.exec("asterisk -rx 'sip show peers' | grep '\/' | wc -l")
tVal = tVal - 1

astExtensions.value = tVal

return m