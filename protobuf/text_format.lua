--
--------------------------------------------------------------------------------
--  FILE:  text_format.lua
--  DESCRIPTION:  protoc-gen-lua
--      Google's Protocol Buffers project, ported to lua.
--      https://code.google.com/p/protoc-gen-lua/
--
--      Copyright (c) 2010 , 林卓毅 (Zhuoyi Lin) netsnail@gmail.com
--      All rights reserved.
--
--      Use, modification and distribution are subject to the "New BSD License"
--      as listed at <url: http://www.opensource.org/licenses/bsd-license.php >.
--  COMPANY:  NetEase
--  CREATED:  2010年08月05日 15时14分13秒 CST
--------------------------------------------------------------------------------
--
local string = string
local math = math
local print = print
local getmetatable = getmetatable
local table = table
local ipairs = ipairs
local tostring = tostring

local descriptor = require "protobuf.descriptor"

-- module "text_format"
local text_format = {}

function text_format.format(buffer)
    local len = string.len( buffer )	
    for i = 1, len, 16 do		
        local text = ""	
        for j = i, math.min( i + 16 - 1, len ) do	
            text = string.format( "%s  %02x", text, string.byte( buffer, j ) )			
        end			
        print( text )	
    end
end

local _FieldDescriptor = descriptor.FieldDescriptor

text_format.msg_format_indent = function(write, msg, indent)
    for field, value in msg:ListFields() do
        local print_field = function(field_value)
            local name = field.name
            write(string.rep(" ", indent))
            if field.type == _FieldDescriptor.TYPE_MESSAGE then
                local extensions = getmetatable(msg)._extensions_by_name
                if extensions[field.full_name] then
                    write("[" .. name .. "] {\n")
                else
                    write(name .. " {\n")
                end
                text_format.msg_format_indent(write, field_value, indent + 4)
                write(string.rep(" ", indent))
                write("}\n")
            else
                write(string.format("%s: %s\n", name, tostring(field_value)))
            end
        end
        if field.label == _FieldDescriptor.LABEL_REPEATED then
            for _, k in ipairs(value) do
                print_field(k)
            end
        else
            print_field(value)
        end
    end
end

function text_format.msg_format(msg)
    local out = {}
    local write = function(value)
        out[#out + 1] = value
    end
    text_format.msg_format_indent(write, msg, 0)
    return table.concat(out)
end

return text_format