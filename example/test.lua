package.path = "./?.lua" .. "protobuf/?.lua;" .. package.path
package.cpath = "protobuf/?.so;" .. package.cpath
local common_pb2 = require "common_pb2"
local person_pb2 = require "person_pb2"

-- Serialize Example
local msg = person_pb2.Person()
msg.header.cmd = 1
msg.header.seq = 12
msg.id = 100
msg.name = "foo"
msg.email = "bar"

print(person_pb2.Phone)
print(person_pb2.Phone.PHONE_TYPE)
msg.phone.num = "188188188"
msg.phone.type = person_pb2.Phone.PHONE_TYPE.HOME
local pb_data = msg:SerializeToString()

-- -- Parse Example
local msg2 = person_pb2.Person()
msg2:ParseFromString(pb_data)
-- print(msg.id, msg.name, msg.email, msg.te)
print(msg2)
