--Begin supergrpup.lua
--Check members #Add supergroup
local function check_member_super(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  if success == 0 then
	send_large_msg(receiver, "Promote Me To Admin First !")
  end
  for k,v in pairs(result) do
    local member_id = v.peer_id
    if member_id ~= our_id then
      -- SuperGroup configuration
      data[tostring(msg.to.id)] = {
        group_type = 'SuperGroup',
		long_id = msg.to.peer_id,
		moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.title, '_', ' '),
		  lock_arabic = 'no',
		  lock_english = 'no',
		  lock_links = "yes",
          flood = 'yes',
		  lock_spam = 'yes',
		  lock_media = 'no',
		  lock_fwd = 'no',
		  lock_reply = 'no',
		  lock_share = 'no',
		  lock_tag = 'no',
		  lock_bots = 'no',
		  lock_number = 'no',
		  username = 'no',
		  lock_emoji = 'no',
		  lock_poker = 'no',
		  lock_audio = 'no',
		  lock_badwords = 'no',
		  lock_photo = 'no',
		  lock_video = 'no',
		  lock_documents = 'no',
		  lock_text = 'no',
		  lock_all = 'no',
		  lock_gifs = 'no',
		  lock_inline = 'no',
		  lock_cmd = 'no',
		  lock_sticker = 'no',
		  member = 'no',
		  public = 'no',
		  lock_rtl = 'no',
		  lock_tgservice = 'no',
		  lock_contacts = 'no',
		  strict = 'no'
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
	  local text = 'SuperGroup Has Been Added\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Check Members #rem supergroup
local function check_member_superrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result) do
    local member_id = v.id
    if member_id ~= our_id then
	  -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
	  local text = 'SuperGroup Has Been Removed\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
      return reply_msg(msg.id, text, ok_cb, false)
    end
  end
end

--Function to Add supergroup
local function superadd(msg)
	local data = load_data(_config.moderation.data)
	local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_super,{receiver = receiver, data = data, msg = msg})
end

--Function to remove supergroup
local function superrem(msg)
	local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    channel_get_users(receiver, check_member_superrem,{receiver = receiver, data = data, msg = msg})
end

--Get and output admins and bots in supergroup
local function callback(cb_extra, success, result)
local i = 1
local chat_name = string.gsub(cb_extra.msg.to.print_name, "_", " ")
local member_type = cb_extra.member_type
local text = member_type.." for "..chat_name..":\n"
for k,v in pairsByKeys(result) do
if not v.first_name then
	name = " "
else
	vname = v.first_name:gsub("‮", "")
	name = vname:gsub("_", " ")
	end
		text = text.."\n"..i.." - "..name.."["..v.peer_id.."]"
		i = i + 1
	end
    send_large_msg(cb_extra.receiver, text)
end

local function callback_clean_bots (extra, success, result)
	local msg = extra.msg
	local receiver = 'channel#id'..msg.to.id
	local channel_id = msg.to.id
	for k,v in pairs(result) do
		local bot_id = v.peer_id
		kick_user(bot_id,channel_id)
	end
end

--Get and output info about supergroup
local function callback_info(cb_extra, success, result)
local title ="Info For SuperGroup: ["..result.title.."]\n\n"
local admin_num = "Admin Count: "..result.admins_count.."\n"
local user_num = "User Count: "..result.participants_count.."\n"
local kicked_num = "Kicked User Count: "..result.kicked_count.."\n"
local channel_id = "ID: "..result.peer_id.."\n"
if result.username then
	channel_username = "Username: @"..result.username
else
	channel_username = ""
end
local text = title..admin_num..user_num..kicked_num..channel_id..channel_username
    send_large_msg(cb_extra.receiver, text)
end

--Get and output members of supergroup
local function callback_who(cb_extra, success, result)
local text = "Members for "..cb_extra.receiver
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		username = " @"..v.username
	else
		username = ""
	end
	text = text.."\n"..i.." - "..name.." "..username.." [ "..v.peer_id.." ]\n"
	--text = text.."\n"..username
	i = i + 1
end
    local file = io.open("./system/chats/lists/supergroups/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./system/chats/lists/supergroups/"..cb_extra.receiver..".txt", ok_cb, false)
	post_msg(cb_extra.receiver, text, ok_cb, false)
end

--Get and output list of kicked users for supergroup
local function callback_kicked(cb_extra, success, result)
--vardump(result)
local text = "Kicked Members for SuperGroup "..cb_extra.receiver.."\n\n"
local i = 1
for k,v in pairsByKeys(result) do
if not v.print_name then
	name = " "
else
	vname = v.print_name:gsub("‮", "")
	name = vname:gsub("_", " ")
end
	if v.username then
		name = name.." @"..v.username
	end
	text = text.."\n"..i.." - "..name.." [ "..v.peer_id.." ]\n"
	i = i + 1
end
    local file = io.open("./system/chats/lists/supergroups/kicked/"..cb_extra.receiver..".txt", "w")
    file:write(text)
    file:flush()
    file:close()
    send_document(cb_extra.receiver,"./system/chats/lists/supergroups/kicked/"..cb_extra.receiver..".txt", ok_cb, false)
	--send_large_msg(cb_extra.receiver, text)
end

--Begin supergroup locks
local function lock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_links_lock = data[tostring(target)]['settings']['lock_links']
  if group_links_lock == 'yes' then
    return '🔐 Link Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_links'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Link Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_links(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_links_lock = data[tostring(target)]['settings']['lock_links']
  if group_links_lock == 'no' then
    return '🔓 Link Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_links'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Link Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  if not is_owner(msg) then
    return "Owners only!"
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'yes' then
    return '🔐 Spam Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Spam Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_spam(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_spam_lock = data[tostring(target)]['settings']['lock_spam']
  if group_spam_lock == 'no' then
    return '🔓 Spam Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_spam'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Emoji Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return '🔐 Flood Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Flood Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_flood(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return '🔓 Flood Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Flood Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return '🔐 Arabic/Persain Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Arabic/Persain Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return '🔓 Arabic/Persain Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Arabic/Persain Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return '🔐 SuperGroup Members Are Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return '🔐 SuperGroup Members Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return '🔓 SuperGroup Members Are Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 SuperGroup Members Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'yes' then
    return '🔐 RTL Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 RTL Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_rtl(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_rtl_lock = data[tostring(target)]['settings']['lock_rtl']
  if group_rtl_lock == 'no' then
    return '🔓 RTL Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_rtl'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 RTL Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'yes' then
    return '🔐 Tgservice Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Tgservice Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_tgservice(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tgservice_lock = data[tostring(target)]['settings']['lock_tgservice']
  if group_tgservice_lock == 'no' then
    return '🔓 Tgservice Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_tgservice'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Tgservice Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'yes' then
    return '🔐 Sticker Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Sticker Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_sticker_lock = data[tostring(target)]['settings']['lock_sticker']
  if group_sticker_lock == 'no' then
    return '🔓 Sticker Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Sticker Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'yes' then
    return '🔐 Contact Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Contact Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_contacts(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_contacts_lock = data[tostring(target)]['settings']['lock_contacts']
  if group_contacts_lock == 'no' then
    return '🔓 Contact Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_contacts'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Contact Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == 'yes' then
    return '🔐 Media Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_media'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Media Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_media(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_media_lock = data[tostring(target)]['settings']['lock_media']
  if group_media_lock == 'no' then
    return '🔓 Media Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_media'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Media Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end
    
	local function lock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'yes' then
    return '🔐 Forward Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_fwd'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'fwd:'..msg.to.id
    redis:set(hash, true)
    return '🔐 Forward Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_fwd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_fwd_lock = data[tostring(target)]['settings']['lock_fwd']
  if group_fwd_lock == 'no' then
    return '🔓 Forward Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_fwd'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'fwd:'..msg.to.id
    redis:del(hash)
    return '🔓 Forward Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['lock_reply']
  if group_reply_lock == 'yes' then
    return '🔐 Reply Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_reply'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash2 = 'reply:'..msg.to.id
    redis:set(hash2, true)
    return '🔐 Reply Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_reply(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_reply_lock = data[tostring(target)]['settings']['lock_reply']
  if group_reply_lock == 'no' then
    return '🔓 Reply Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_reply'] = 'no'
    save_data(_config.moderation.data, data)
    local hash2 = 'reply:'..msg.to.id
    redis:del(hash2)
    return '🔓 Reply Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_share(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_share_lock = data[tostring(target)]['settings']['lock_share']
  if group_share_lock == 'yes' then
    return '🔐 Share Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_share'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Share Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_share(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_share_lock = data[tostring(target)]['settings']['lock_share']
  if group_share_lock == 'no' then
    return '🔓 Share Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_share'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Share Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'yes' then
    return '🔐 #HashTag Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 #HashTag Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM '
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'no' then
    return '🔓 #HashTag Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 #HashTag Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    return '🔐 Bots Are Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Bots Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    return '🔓 Bots Are Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Bots Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_number(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_number_lock = data[tostring(target)]['settings']['lock_number']
  if group_number_lock == 'yes' then
    return '🔐 Number Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_number'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Number Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_number(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_number_lock = data[tostring(target)]['settings']['lock_number']
  if group_number_lock == 'no' then
    return '🔓 Number Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_number'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Number Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_poker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_poker_lock = data[tostring(target)]['settings']['lock_poker']
  if group_poker_lock == 'yes' then
    return '🔐 Poker Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_poker'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Poker Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_poker(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_poker_lock = data[tostring(target)]['settings']['lock_poker']
  if group_poker_lock == 'no' then
    return '🔓 Poker Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_poker'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Poker Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

	local function lock_group_audio(msg, data, target)
		local msg_type = 'Audio'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Audio Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Audio Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_audio(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Audio'
  if not is_momod(msg) then
    return
  end
  local group_audio_lock = data[tostring(target)]['settings']['lock_audio']
  if group_audio_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Audio Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_audio'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Audio Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_photo(msg, data, target)
		local msg_type = 'Photo'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Photo Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Photo Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_photo(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Photo'
  if not is_momod(msg) then
    return
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Photo Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Photo Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_video(msg, data, target)
		local msg_type = 'Video'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Video Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Video Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_video(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Video'
  if not is_momod(msg) then
    return
  end
  local group_video_lock = data[tostring(target)]['settings']['lock_video']
  if group_video_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Video Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_video'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Video Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_documents(msg, data, target)
		local msg_type = 'Documents'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Documents Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Documents Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_documents(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Documents'
  if not is_momod(msg) then
    return
  end
  local group_documents_lock = data[tostring(target)]['settings']['lock_documents']
  if group_documents_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Documents Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_documents'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Documents Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_text(msg, data, target)
		local msg_type = 'Text'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Text Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Text Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_text(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Text'
  if not is_momod(msg) then
    return
  end
  local group_text_lock = data[tostring(target)]['settings']['lock_text']
  if group_text_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Text Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_text'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Text Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_all(msg, data, target)
		local msg_type = 'All'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 All Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 All Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_all(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'All'
  if not is_momod(msg) then
    return
  end
  local group_all_lock = data[tostring(target)]['settings']['lock_all']
  if group_all_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 All Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_all'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 All Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

	local function lock_group_gifs(msg, data, target)
		local msg_type = 'Gifs'
		local chat_id = msg.to.id
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == 'yes' and is_muted(chat_id, msg_type..': yes') then
    return '🔐 Gifs Posting Are Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    if not is_muted(chat_id, msg_type..': yes') then
		mute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Gifs Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
    end
  end
end

local function unlock_group_gifs(msg, data, target)
	local chat_id = msg.to.id
	local msg_type = 'Gifs'
  if not is_momod(msg) then
    return
  end
  local group_gifs_lock = data[tostring(target)]['settings']['lock_gifs']
  if group_gifs_lock == 'no' and not is_muted(chat_id, msg_type..': yes') then
    return '🔓 Gifs Posting Are Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
  	if is_muted(chat_id, msg_type..': yes') then
		unmute(chat_id, msg_type)
    data[tostring(target)]['settings']['lock_gifs'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Gifs Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
    end
  end
end

local function lock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == 'yes' then
    return '🔐 Inline Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_inline'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Inline Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_inline(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_inline_lock = data[tostring(target)]['settings']['lock_inline']
  if group_inline_lock == 'no' then
    return '🔓 Inline Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_inline'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Inline Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'yes' then
    return '🔐 Cmd Posting Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Cmd Posting Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_cmd(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_cmd_lock = data[tostring(target)]['settings']['lock_cmd']
  if group_cmd_lock == 'no' then
    return '🔓 Cmd Posting Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['lock_cmd'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Cmd Posting Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function enable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'yes' then
    return '🔐 Settings Are Already Strictly Enforced\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  else
    data[tostring(target)]['settings']['strict'] = 'yes'
    save_data(_config.moderation.data, data)
    return '🔐 Settings Will Be Strictly Enforced\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function disable_strict_rules(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_strict_lock = data[tostring(target)]['settings']['strict']
  if group_strict_lock == 'no' then
    return '🔓 Settings Are Not Strictly Enforced\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  else
    data[tostring(target)]['settings']['strict'] = 'no'
    save_data(_config.moderation.data, data)
    return '🔓 Settings Will Not Be Strictly Enforced\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'yes' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔐 Username Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
  end
    data[tostring(target)]['settings']['username'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔐 Username Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_username(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_username_lock = data[tostring(target)]['settings']['username']
  if group_username_lock == 'no' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔓 Username Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
  end
    data[tostring(target)]['settings']['username'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔓 Username Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == 'yes' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
  else
  return '🔐 Emoji Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
  end
    data[tostring(target)]['settings']['lock_emoji'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
    else 
    return '🔐 Emoji Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_emoji(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_emoji_lock = data[tostring(target)]['settings']['lock_emoji']
  if group_emoji_lock == 'no' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
  else
  return '🔓 Emoji Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
  end
    data[tostring(target)]['settings']['lock_emoji'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
    else
    return '🔓 Emoji Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_badwords(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_badwords_lock = data[tostring(target)]['settings']['badwords']
  if group_badwords_lock == 'yes' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
    else
    return '🔐 Bad Words Are Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
  end
    data[tostring(target)]['settings']['badwords'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
    else
    return '🔐 Bad Words Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_badwords(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_badwords_lock = data[tostring(target)]['settings']['badwords']
  if group_badwords_lock == 'no' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
  else
  return '🔓 Bad Words Are Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
  end
    data[tostring(target)]['settings']['badwords'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
    return ''
    else
    return '🔓 Bad Words Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

local function lock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'yes' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔐 English Is Already Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
  end
    data[tostring(target)]['settings']['english'] = 'yes'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
   return ''
   else
    return '🔐 English Has Been Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔐'
  end
end

local function unlock_group_english(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_english_lock = data[tostring(target)]['settings']['english']
  if group_english_lock == 'no' then
  local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔓 English Is Not Locked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
  end
    data[tostring(target)]['settings']['english'] = 'no'
    save_data(_config.moderation.data, data)
    local hash = 'group:'..msg.to.id
  local group_lang = redis:hget(hash,'lang')
  if group_lang then
  return ''
  else
    return '🔓 English Has Been UnLocked\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM 🔓'
  end
end

--End supergroup locks

--'Set supergroup rules' function
local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'SuperGroup Rules Set\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
end

--'Get supergroup rules' function
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'No Rules Available\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local group_name = data[tostring(msg.to.id)]['settings']['set_name']
  local rules = group_name..' rules:\n\n'..rules:gsub("/n", " ")
  return rules
end

--Set supergroup to public or not public function
local function set_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return "For Moderators Only\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM"
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'yes' then
    return 'Group Is Already Public\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
  else
    data[tostring(target)]['settings']['public'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'SuperGroup Is Now : Public\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
end

local function unset_public_membermod(msg, data, target)
  if not is_momod(msg) then
    return
  end
  local group_public_lock = data[tostring(target)]['settings']['public']
  local long_id = data[tostring(target)]['long_id']
  if not long_id then
	data[tostring(target)]['long_id'] = msg.to.peer_id
	save_data(_config.moderation.data, data)
  end
  if group_public_lock == 'no' then
    return 'SuperGroup Is Not Public\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
  else
    data[tostring(target)]['settings']['public'] = 'no'
	data[tostring(target)]['long_id'] = msg.to.long_id
    save_data(_config.moderation.data, data)
    return 'SuperGroup Is Now : Not Public\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
  end
end

--Show supergroup settings; function
function show_supergroup_settingsmod(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 2
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
    	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_links'] then
			data[tostring(target)]['settings']['lock_links'] = 'no'
		end
	end
    	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_arabic'] then
			data[tostring(target)]['settings']['lock_arabic'] = 'no'
		end
	end
  local settings = data[tostring(target)]['settings']
   local text = "SuperGroup Settings For ["..msg.to.print_name.."]:\n\n[🔐] Default locks :\nLock Links 👉 "..settings.lock_links.."\nLock Flood 👉 "..settings.flood.."\nLock Spam 👉 "..settings.lock_spam.."\nLock Arabic/Persian 👉 "..settings.lock_arabic.."\nLock English 👉 "..settings.lock_english.."\nLock Member 👉 "..settings.lock_member.."\nLock RTL 👉 "..settings.lock_rtl.."\nLock Tgservice  👉 "..settings.lock_tgservice.."\nLock Sticker 👉 "..settings.lock_sticker.."\n\n[🔏] New Locks :\nLock Forward 👉 "..settings.lock_fwd.."\nLock Reply 👉 "..settings.lock_reply.."\nLock Bots 👉 "..settings.lock_bots.."\nLock Share 👉 "..settings.lock_share.."\nLock Tag 👉 "..settings.lock_tag.."\nLock Username 👉 "..settings.username.."\nLock Number 👉 "..settings.lock_number.."\nLock Emoji 👉 "..settings.lock_emoji.."\nLock Poker 👉 "..settings.lock_poker.."\nLock Media 👉 "..settings.lock_media.."\nLock Documents 👉 "..settings.lock_documents.."\nLock Audio 👉 "..settings.lock_audio.."\nLock Photo 👉 "..settings.lock_photo.."\nLock Video 👉 "..settings.lock_video.."\nLock Gifs 👉 "..settings.lock_gifs.."\nLock Inline 👉 "..settings.lock_inline.."\nLock Cmd 👉 "..settings.lock_cmd.."\nLock Text 👉 "..settings.lock_text.."\nLock Badwords 👉 "..settings.lock_badwords.."\nLock All 👉 "..settings.lock_all.."\n\n[🔧] OTHER:\n[👥] Public 👉 "..settings.public.."\n[📛] Strict Settings 👉 "..settings.strict.."\n[👀]Flood Sensitivity 👉 "..NUM_MSG_MAX.."|20"
  return text
end

--Show supergroup settings all; function
function show_supergroup_settingsall(msg, target)
 	if not is_momod(msg) then
    	return
  	end
	local data = load_data(_config.moderation.data)
    if data[tostring(target)] then
     	if data[tostring(target)]['settings']['flood_msg_max'] then
        	NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
        	print('custom'..NUM_MSG_MAX)
      	else
        	NUM_MSG_MAX = 2
      	end
    end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['public'] then
			data[tostring(target)]['settings']['public'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_rtl'] then
			data[tostring(target)]['settings']['lock_rtl'] = 'no'
		end
end
      if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_tgservice'] then
			data[tostring(target)]['settings']['lock_tgservice'] = 'no'
		end
	end
	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_member'] then
			data[tostring(target)]['settings']['lock_member'] = 'no'
		end
	end
        	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_arabic'] then
			data[tostring(target)]['settings']['lock_arabic'] = 'no'
		end
	end
        	if data[tostring(target)]['settings'] then
		if not data[tostring(target)]['settings']['lock_links'] then
			data[tostring(target)]['settings']['lock_links'] = 'no'
		end
	end
  local settings = data[tostring(target)]['settings']
 local text = "SuperGroup Settings For ["..msg.to.print_name.."]:\n\n[🔐] Default locks :\nLock Links 👉 "..settings.lock_links.."\nLock Flood 👉 "..settings.flood.."\nLock Spam 👉 "..settings.lock_spam.."\nLock Arabic/Persian 👉 "..settings.lock_arabic.."\nLock English 👉 "..settings.lock_english.."\nLock Member 👉 "..settings.lock_member.."\nLock RTL 👉 "..settings.lock_rtl.."\nLock Tgservice  👉 "..settings.lock_tgservice.."\nLock Sticker 👉 "..settings.lock_sticker.."\n\n[🔏] New Locks :\nLock Forward 👉 "..settings.lock_fwd.."\nLock Reply 👉 "..settings.lock_reply.."\nLock Bots 👉 "..settings.lock_bots.."\nLock Share 👉 "..settings.lock_share.."\nLock Tag 👉 "..settings.lock_tag.."\nLock Username 👉 "..settings.username.."\nLock Number 👉 "..settings.lock_number.."\nLock Emoji 👉 "..settings.lock_emoji.."\nLock Poker 👉 "..settings.lock_poker.."\nLock Media 👉 "..settings.lock_media.."\nLock Documents 👉 "..settings.lock_documents.."\nLock Audio 👉 "..settings.lock_audio.."\nLock Photo 👉 "..settings.lock_photo.."\nLock Video 👉 "..settings.lock_video.."\nLock Gifs 👉 "..settings.lock_gifs.."\nLock Inline 👉 "..settings.lock_inline.."\nLock Cmd 👉 "..settings.lock_cmd.."\nLock Text 👉 "..settings.lock_text.."\nLock Badwords 👉 "..settings.lock_badwords.."\nLock All 👉 "..settings.lock_all.."\n\n[🔧] OTHER:\n[👥] Public 👉 "..settings.public.."\n[📛] Strict Settings 👉 "..settings.strict.."\n[👀]Flood Sensitivity 👉 "..NUM_MSG_MAX.."|20\n\n[👥] About SuperGroup :\nName: "..msg.to.print_name.."\nID: "..msg.to.id.."\n\n[😶] "..muted_user_list(msg.to.id)
 return text
end

local function promote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' Is Already A Moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
end

local function demote_admin(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' Is Not A Moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
end

local function promote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  local member_tag_username = string.gsub(member_username, '@', '(at)')
  if not data[group] then
    return send_large_msg(receiver, 'SuperGroup Is Not Added\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM')
  end
  if data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_username..' Is Already A Moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = member_tag_username
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' Has Been Promoted.')
end

local function demote2(receiver, member_username, user_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'channel#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'Group Is Not Added.')
  end
  if not data[group]['moderators'][tostring(user_id)] then
    return send_large_msg(receiver, member_tag_username..' Is Not A Moderator.')
  end
  data[group]['moderators'][tostring(user_id)] = nil
  save_data(_config.moderation.data, data)
  send_large_msg(receiver, member_username..' Has Been Demoted.')
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'SuperGroup is not added.'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then
    return 'No Moderator In This Group\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
  end
  local i = 1
  local message = '\nList of moderators for ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

-- Start by reply actions
function get_message_callback(extra, success, result)
	local get_cmd = extra.get_cmd
	local msg = extra.msg
	local data = load_data(_config.moderation.data)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
    if get_cmd == "id" and not result.action then
		local channel = 'channel#id'..result.to.peer_id
		id1 = send_large_msg(channel, result.from.peer_id)
	elseif get_cmd == 'id' and result.action then
		local action = result.action.type
		if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
			if result.action.user then
				user_id = result.action.user.peer_id
			else
				user_id = result.peer_id
			end
			local channel = 'channel#id'..result.to.peer_id
			id1 = send_large_msg(channel, user_id)
		end
    elseif get_cmd == "idfrom" then
		local channel = 'channel#id'..result.to.peer_id
		id2 = send_large_msg(channel, result.fwd_from.peer_id)
    elseif get_cmd == 'channel_block' and not result.action then
		local member_id = result.from.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave Using Kickme Command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You Can't Kick Other Admins")
    end
		kick_user(member_id, channel_id)
	elseif get_cmd == 'channel_block' and result.action and result.action.type == 'chat_add_user' then
		local user_id = result.action.user.peer_id
		local channel_id = result.to.peer_id
    if member_id == msg.from.id then
      return send_large_msg("channel#id"..channel_id, "Leave Using Kickme Command")
    end
    if is_momod2(member_id, channel_id) and not is_admin2(msg.from.id) then
			   return send_large_msg("channel#id"..channel_id, "You Can't Kick Mods/Owner/Admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You Can't Kick Other Admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "del" then
		delete_msg(result.id, ok_cb, false)
	elseif get_cmd == "setadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		channel_set_admin(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." Set As An Admin"
		else
			text = "[ "..user_id.." ]Set As An Admin"
		end
		send_large_msg(channel_id, text)
	elseif get_cmd == "demoteadmin" then
		local user_id = result.from.peer_id
		local channel_id = "channel#id"..result.to.peer_id
		if is_admin2(result.from.peer_id) then
			return send_large_msg(channel_id, "You Can't Demote Global Admins!")
		end
		channel_demote(channel_id, "user#id"..user_id, ok_cb, false)
		if result.from.username then
			text = "@"..result.from.username.." Has Been Demoted From Admin"
		else
			text = "[ "..user_id.." ] Has Been Demoted From Admin"
		end
		send_large_msg(channel_id, text)
	elseif get_cmd == "setowner" then
		local group_owner = data[tostring(result.to.peer_id)]['set_owner']
		if group_owner then
		local channel_id = 'channel#id'..result.to.peer_id
			if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
				local user = "user#id"..group_owner
				channel_demote(channel_id, user, ok_cb, false)
			end
			local user_id = "user#id"..result.from.peer_id
			channel_set_admin(channel_id, user_id, ok_cb, false)
			data[tostring(result.to.peer_id)]['set_owner'] = tostring(result.from.peer_id)
			save_data(_config.moderation.data, data)
			if result.from.username then
				text = "@"..result.from.username.." [ "..result.from.peer_id.." ] Added As Owner"
			else
				text = "[ "..result.from.peer_id.." ] Added As Owner"
			end
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "promote" then
		local receiver = result.to.peer_id
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
		if result.from.username then
			member_username = '@'.. result.from.username
		end
		local member_id = result.from.peer_id
		if result.to.peer_type == 'channel' then
		promote2("channel#id"..result.to.peer_id, member_username, member_id)
	    --channel_set_mod(channel_id, user, ok_cb, false)
		end
	elseif get_cmd == "demote" then
		local full_name = (result.from.first_name or '')..' '..(result.from.last_name or '')
		local member_name = full_name:gsub("‮", "")
		local member_username = member_name:gsub("_", " ")
    if result.from.username then
		member_username = '@'.. result.from.username
    end
		local member_id = result.from.peer_id
		--local user = "user#id"..result.peer_id
		demote2("channel#id"..result.to.peer_id, member_username, member_id)
		--channel_demote(channel_id, user, ok_cb, false)
	elseif get_cmd == 'mute_user' then
		if result.service then
			local action = result.action.type
			if action == 'chat_add_user' or action == 'chat_del_user' or action == 'chat_rename' or action == 'chat_change_photo' then
				if result.action.user then
					user_id = result.action.user.peer_id
				end
			end
			if action == 'chat_add_user_link' then
				if result.from then
					user_id = result.from.peer_id
				end
			end
		else
			user_id = result.from.peer_id
		end
		local receiver = extra.receiver
		local chat_id = msg.to.id
		print(user_id)
		print(chat_id)
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, "["..user_id.."] Removed From The Muted User List")
		elseif is_admin1(msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] Added To The Muted User List")
		end
	end
end
-- End by reply actions

--By ID actions
local function cb_user_info(extra, success, result)
	local receiver = extra.receiver
	local user_id = result.peer_id
	local get_cmd = extra.get_cmd
	local data = load_data(_config.moderation.data)
	--[[if get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		channel_set_admin(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
		else
			text = "[ "..result.peer_id.." ] has been set as an admin"
		end
			send_large_msg(receiver, text)]]
	if get_cmd == "demoteadmin" then
		if is_admin2(result.peer_id) then
			return send_large_msg(receiver, "You can't demote global admins!")
		end
		local user_id = "user#id"..result.peer_id
		channel_demote(receiver, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." Has Been Demoted From Admin"
			send_large_msg(receiver, text)
		else
			text = "[ "..result.peer_id.." ] Has Been Demoted From Admin"
			send_large_msg(receiver, text)
		end
	elseif get_cmd == "promote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		promote2(receiver, member_username, user_id)
	elseif get_cmd == "demote" then
		if result.username then
			member_username = "@"..result.username
		else
			member_username = string.gsub(result.print_name, '_', ' ')
		end
		demote2(receiver, member_username, user_id)
	end
end

-- Begin resolve username actions
local function callbackres(extra, success, result)
  local member_id = result.peer_id
  local member_username = "@"..result.username
  local get_cmd = extra.get_cmd
	if get_cmd == "res" then
		local user = result.peer_id
		local name = string.gsub(result.print_name, "_", " ")
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user..'\n'..name)
		return user
	elseif get_cmd == "id" then
		local user = result.peer_id
		local channel = 'channel#id'..extra.channelid
		send_large_msg(channel, user)
		return user
  elseif get_cmd == "invite" then
    local receiver = extra.channel
    local user_id = "user#id"..result.peer_id
    channel_invite(receiver, user_id, ok_cb, false)
	--[[elseif get_cmd == "channel_block" then
		local user_id = result.peer_id
		local channel_id = extra.channelid
    local sender = extra.sender
    if member_id == sender then
      return send_large_msg("channel#id"..channel_id, "Leave using kickme command")
    end
		if is_momod2(member_id, channel_id) and not is_admin2(sender) then
			   return send_large_msg("channel#id"..channel_id, "You can't kick mods/owner/admins")
    end
    if is_admin2(member_id) then
         return send_large_msg("channel#id"..channel_id, "You can't kick other admins")
    end
		kick_user(user_id, channel_id)
	elseif get_cmd == "setadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		channel_set_admin(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." has been set as an admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." has been set as an admin"
			send_large_msg(channel_id, text)
		end
	elseif get_cmd == "setowner" then
		local receiver = extra.channel
		local channel = string.gsub(receiver, 'channel#id', '')
		local from_id = extra.from_id
		local group_owner = data[tostring(channel)]['set_owner']
		if group_owner then
			local user = "user#id"..group_owner
			if not is_admin2(group_owner) and not is_support(group_owner) then
				channel_demote(receiver, user, ok_cb, false)
			end
			local user_id = "user#id"..result.peer_id
			channel_set_admin(receiver, user_id, ok_cb, false)
			data[tostring(channel)]['set_owner'] = tostring(result.peer_id)
			save_data(_config.moderation.data, data)
		if result.username then
			text = member_username.." [ "..result.peer_id.." ] added as owner"
		else
			text = "[ "..result.peer_id.." ] added as owner"
		end
		send_large_msg(receiver, text)
  end]]
	elseif get_cmd == "promote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		--local user = "user#id"..result.peer_id
		promote2(receiver, member_username, user_id)
		--channel_set_mod(receiver, user, ok_cb, false)
	elseif get_cmd == "demote" then
		local receiver = extra.channel
		local user_id = result.peer_id
		local user = "user#id"..result.peer_id
		demote2(receiver, member_username, user_id)
	elseif get_cmd == "demoteadmin" then
		local user_id = "user#id"..result.peer_id
		local channel_id = extra.channel
		if is_admin2(result.peer_id) then
			return send_large_msg(channel_id, "You Can't Demote Global Admins!")
		end
		channel_demote(channel_id, user_id, ok_cb, false)
		if result.username then
			text = "@"..result.username.." Has Been Demoted From Admin"
			send_large_msg(channel_id, text)
		else
			text = "@"..result.peer_id.." Has Been Demoted From Admin"
			send_large_msg(channel_id, text)
		end
		local receiver = extra.channel
		local user_id = result.peer_id
		demote_admin(receiver, member_username, user_id)
	elseif get_cmd == 'mute_user' then
		local user_id = result.peer_id
		local receiver = extra.receiver
		local chat_id = string.gsub(receiver, 'channel#id', '')
		if is_muted_user(chat_id, user_id) then
			unmute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] Removed From Muted User List")
		elseif is_owner(extra.msg) then
			mute_user(chat_id, user_id)
			send_large_msg(receiver, " ["..user_id.."] Added To Muted User List")
		end
	end
end
--End resolve username actions

--Begin non-channel_invite username actions
local function in_channel_cb(cb_extra, success, result)
  local get_cmd = cb_extra.get_cmd
  local receiver = cb_extra.receiver
  local msg = cb_extra.msg
  local data = load_data(_config.moderation.data)
  local print_name = user_print_name(cb_extra.msg.from):gsub("‮", "")
  local name_log = print_name:gsub("_", " ")
  local member = cb_extra.username
  local memberid = cb_extra.user_id
  if member then
    text = 'No User @'..member..' In This SuperGroup.'
  else
    text = 'No User ['..memberid..'] In This SuperGroup.'
  end
if get_cmd == "channel_block" then
  for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
     local user_id = v.peer_id
     local channel_id = cb_extra.msg.to.id
     local sender = cb_extra.msg.from.id
      if user_id == sender then
        return send_large_msg("channel#id"..channel_id, "Leave Using Kickme Command")
      end
      if is_momod2(user_id, channel_id) and not is_admin2(sender) then
        return send_large_msg("channel#id"..channel_id, "You Can't Kick Mods/Owner/Admins")
      end
      if is_admin2(user_id) then
        return send_large_msg("channel#id"..channel_id, "You Can't Kick Other Admins")
      end
      if v.username then
        text = ""
      else
        text = ""
      end
      kick_user(user_id, channel_id)
      return
    end
  end
elseif get_cmd == "setadmin" then
   for k,v in pairs(result) do
    vusername = v.username
    vpeer_id = tostring(v.peer_id)
    if vusername == member or vpeer_id == memberid then
      local user_id = "user#id"..v.peer_id
      local channel_id = "channel#id"..cb_extra.msg.to.id
      channel_set_admin(channel_id, user_id, ok_cb, false)
      if v.username then
        text = "@"..v.username.." ["..v.peer_id.."] Has Been Set As An Admin"
      else
        text = "["..v.peer_id.."] Has Been Set As An Admin"
      end
	  if v.username then
		member_username = "@"..v.username
	  else
		member_username = string.gsub(v.print_name, '_', ' ')
	  end
		local receiver = channel_id
		local user_id = v.peer_id
		promote_admin(receiver, member_username, user_id)

    end
    send_large_msg(channel_id, text)
    return
 end
elseif get_cmd == 'setowner' then
	for k,v in pairs(result) do
		vusername = v.username
		vpeer_id = tostring(v.peer_id)
		if vusername == member or vpeer_id == memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
					local user_id = "user#id"..v.peer_id
					channel_set_admin(receiver, user_id, ok_cb, false)
					data[tostring(channel)]['set_owner'] = tostring(v.peer_id)
					save_data(_config.moderation.data, data)
				if result.username then
					text = member_username.." ["..v.peer_id.."] Added As Owner"
				else
					text = "["..v.peer_id.."] Added As Owner"
				end
			end
		elseif memberid and vusername ~= member and vpeer_id ~= memberid then
			local channel = string.gsub(receiver, 'channel#id', '')
			local from_id = cb_extra.msg.from.id
			local group_owner = data[tostring(channel)]['set_owner']
			if group_owner then
				if not is_admin2(tonumber(group_owner)) and not is_support(tonumber(group_owner)) then
					local user = "user#id"..group_owner
					channel_demote(receiver, user, ok_cb, false)
				end
				data[tostring(channel)]['set_owner'] = tostring(memberid)
				save_data(_config.moderation.data, data)
				text = "["..memberid.."] Added As Owner"
			end
		end
	end
 end
send_large_msg(receiver, text)
end
--End non-channel_invite username actions

--'Set supergroup photo' function
local function set_supergroup_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
      return
  end
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/tmp/channel_photo_'..msg.to.id..'.jpg'
    print('File downloaded to:', result)
    os.rename(result, file)
    print('File moved to:', file)
    channel_set_photo(receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'Photo saved!', ok_cb, false)
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'Failed, Please Try Again!', ok_cb, false)
  end
end

--Run function
local function run(msg, matches)
	if msg.to.type == 'chat' then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			local receiver = get_receiver(msg)
			chat_upgrade(receiver, ok_cb, false)
		end
	elseif msg.to.type == 'channel'then
		if matches[1] == 'tosuper' then
			if not is_admin1(msg) then
				return
			end
			return "Already a SuperGroup"
		end
	end
	if msg.to.type == 'channel' then
	local support_id = msg.from.id
	local receiver = get_receiver(msg)
	local print_name = user_print_name(msg.from):gsub("‮", "")
	local name_log = print_name:gsub("_", " ")
	local data = load_data(_config.moderation.data)
		if matches[1] == 'add' and not matches[2] then
			if not is_admin1(msg) and not is_support(support_id) then
				return
			end
			if is_super_group(msg) then
				return reply_msg(msg.id, 'SuperGroup Is Already Added.', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") Added\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM")
			superadd(msg)
			set_mutes(msg.to.id)
			channel_set_admin(receiver, 'user#id'..msg.from.id, ok_cb, false)
		end

		if matches[1] == 'rem' and is_admin1(msg) and not matches[2] then
			if not is_super_group(msg) then
				return reply_msg(msg.id, 'SuperGroup Is Not Added\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM', ok_cb, false)
			end
			print("SuperGroup "..msg.to.print_name.."("..msg.to.id..") removed")
			superrem(msg)
			rem_mutes(msg.to.id)
		end

		if not data[tostring(msg.to.id)] then
			return
		end
		if matches[1] == "gap" then
			if not is_owner(msg) then
				return
			end
			channel_info(receiver, callback_info, {receiver = receiver, msg = msg})
		end

		if matches[1] == "admins" then
			if not is_owner(msg) and not is_support(msg.from.id) then
				return
			end
			member_type = 'Admins'
			admins = channel_get_admins(receiver,callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "owner" then
			local group_owner = data[tostring(msg.to.id)]['set_owner']
			if not group_owner then
				return "No Owner,Ask Admins In Support Groups To Set Owner For Your SuperGroup\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM"
			end
			return "SuperGroup Owner Is ["..group_owner..']'
		end

		if matches[1] == "modlist" then
			return modlist(msg)
			-- channel_get_admins(receiver,callback, {receiver = receiver})
		end

		if matches[1] == "bots" and is_momod(msg) then
			member_type = 'Bots'
			channel_get_bots(receiver, callback, {receiver = receiver, msg = msg, member_type = member_type})
		end

		if matches[1] == "who" and not matches[2] and is_momod(msg) then
			local user_id = msg.from.peer_id
			channel_get_users(receiver, callback_who, {receiver = receiver})
		end

		if matches[1] == "kicked" and is_momod(msg) then
			channel_get_kicked(receiver, callback_kicked, {receiver = receiver})
		end

		if matches[1] == 'del' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'del',
					msg = msg
				}
				delete_msg(msg.id, ok_cb, false)
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			end
		end

		if matches[1] == 'block' and is_momod(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'channel_block',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'block' and matches[2] and string.match(matches[2], '^%d+$') then
				--[[local user_id = matches[2]
				local channel_id = msg.to.id
				if is_momod2(user_id, channel_id) and not is_admin2(user_id) then
					return send_large_msg(receiver, "You can't kick mods/owner/admins")
				end
				kick_user(user_id, channel_id)]]
				local get_cmd = 'channel_block'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == "block" and matches[2] and not string.match(matches[2], '^%d+$') then
			--[[local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'channel_block',
					sender = msg.from.id
				}
			    local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)]]
			local get_cmd = 'channel_block'
			local msg = msg
			local username = matches[2]
			local username = string.gsub(matches[2], '@', '')
			channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'id' then
			if type(msg.reply_id) ~= "nil" and is_momod(msg) and not matches[2] then
				local cbreply_extra = {
					get_cmd = 'id',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif type(msg.reply_id) ~= "nil" and matches[2] == "from" and is_momod(msg) then
				local cbreply_extra = {
					get_cmd = 'idfrom',
					msg = msg
				}
				get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif msg.text:match("@[%a%d]") then
				local cbres_extra = {
					channelid = msg.to.id,
					get_cmd = 'id'
				}
				local username = matches[2]
				local username = username:gsub("@","")
				resolve_username(username,  callbackres, cbres_extra)
			else
			
				return "SuperGroup ID for " ..string.gsub(msg.to.print_name, "_", " ").. ":\n\n"..msg.to.id
			end
		end

		if matches[1] == 'kickme' then
			if msg.to.type == 'channel' then
				channel_kick("channel#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
			end
		end

		if matches[1] == 'newlink' and is_momod(msg)then
			local function callback_link (extra , success, result)
			local receiver = get_receiver(msg)
				if success == 0 then
					send_large_msg(receiver, '*Error: Failed To Retrieve link* \nReason: Not Creator.\n\nIf You Have The Link, Please Use /setlink To Set It\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM')
					data[tostring(msg.to.id)]['settings']['set_link'] = nil
					save_data(_config.moderation.data, data)
				else
					send_large_msg(receiver, "Created a new link")
					data[tostring(msg.to.id)]['settings']['set_link'] = result
					save_data(_config.moderation.data, data)
				end
			end
			export_channel_link(receiver, callback_link, false)
		end

		if matches[1] == 'setlink' and is_owner(msg) then
			data[tostring(msg.to.id)]['settings']['set_link'] = 'waiting'
			save_data(_config.moderation.data, data)
			return 'Please Send The New Group Link Now\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
		end
		
		one = io.open("./system/team", "r")
        two = io.open("./system/channel", "r")
        local team = one:read("*all")
        local channel = two:read("*all")

		if msg.text then
			if msg.text:match("^(https://telegram.me/joinchat/%S+)$") and data[tostring(msg.to.id)]['settings']['set_link'] == 'waiting' and is_owner(msg) then
				data[tostring(msg.to.id)]['settings']['set_link'] = msg.text
				save_data(_config.moderation.data, data)
				return 'New link set \nPowered by '..team..'\n<a href="'..channel..'">JOIN TO CHANNEL!</a>'
			end
		end

		if matches[1] == 'link' then
			if not is_momod(msg) then
				return
			end
			local group_link = data[tostring(msg.to.id)]['settings']['set_link']
			if not group_link then
				return "Create A Link Using /newlink First!\n\nOr If I Am Not The Creator use /setlink To Set Your Link\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM"
			end
			return 'Group Link:\n'..group_link..'\nPowered by '..team..'\n"'..channel..'">JOIN TO CHANNEL'
		end

		if matches[1] == "invite" and is_sudo(msg) then
			local cbres_extra = {
				channel = get_receiver(msg),
				get_cmd = "invite"
			}
			local username = matches[2]
			local username = username:gsub("@","")
			resolve_username(username,  callbackres, cbres_extra)
		end

		if matches[1] == 'res' and is_owner(msg) then
			local cbres_extra = {
				channelid = msg.to.id,
				get_cmd = 'res'
			}
			local username = matches[2]
			local username = username:gsub("@","")
			resolve_username(username,  callbackres, cbres_extra)
		end

		--[[if matches[1] == 'kick' and is_momod(msg) then
			local receiver = channel..matches[3]
			local user = "user#id"..matches[2]
			chaannel_kick(receiver, user, ok_cb, false)
		end]]

			if matches[1] == 'setadmin' then
				if not is_support(msg.from.id) and not is_owner(msg) then
					return
				end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setadmin',
					msg = msg
				}
				setadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setadmin' and matches[2] and string.match(matches[2], '^%d+$') then
			--[[]	local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'setadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})]]
				local get_cmd = 'setadmin'
				local msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
				--[[local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'setadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)]]
				local get_cmd = 'setadmin'
				local msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'demoteadmin' then
			if not is_support(msg.from.id) and not is_owner(msg) then
				return
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demoteadmin',
					msg = msg
				}
				demoteadmin = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demoteadmin' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demoteadmin'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demoteadmin' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demoteadmin'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'setowner' and is_owner(msg) then
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'setowner',
					msg = msg
				}
				setowner = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'setowner' and string.match(matches[2], '^%d+$') then
		--[[	local group_owner = data[tostring(msg.to.id)]['set_owner']
				if group_owner then
					local receiver = get_receiver(msg)
					local user_id = "user#id"..group_owner
					if not is_admin2(group_owner) and not is_support(group_owner) then
						channel_demote(receiver, user_id, ok_cb, false)
					end
					local user = "user#id"..matches[2]
					channel_set_admin(receiver, user, ok_cb, false)
					data[tostring(msg.to.id)]['set_owner'] = tostring(matches[2])
					save_data(_config.moderation.data, data)
					local text = "[ "..matches[2].." ] added as owner"
					return text
				end]]
				local	get_cmd = 'setowner'
				local	msg = msg
				local user_id = matches[2]
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, user_id=user_id})
			elseif matches[1] == 'setowner' and not string.match(matches[2], '^%d+$') then
				local	get_cmd = 'setowner'
				local	msg = msg
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				channel_get_users (receiver, in_channel_cb, {get_cmd=get_cmd, receiver=receiver, msg=msg, username=username})
			end
		end

		if matches[1] == 'promote' then
		  if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "Only owner/admin can promote"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'promote',
					msg = msg
				}
				promote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'promote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'promote'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'promote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'promote',
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == 'mp' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_set_mod(channel, user_id, ok_cb, false)
			return "ok"
		end
		if matches[1] == 'md' and is_sudo(msg) then
			channel = get_receiver(msg)
			user_id = 'user#id'..matches[2]
			channel_demote(channel, user_id, ok_cb, false)
			return "ok"
		end

		if matches[1] == 'demote' then
			if not is_momod(msg) then
				return
			end
			if not is_owner(msg) then
				return "Only Owner/Support/Admin Can Promote"
			end
			if type(msg.reply_id) ~= "nil" then
				local cbreply_extra = {
					get_cmd = 'demote',
					msg = msg
				}
				demote = get_message(msg.reply_id, get_message_callback, cbreply_extra)
			elseif matches[1] == 'demote' and matches[2] and string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local user_id = "user#id"..matches[2]
				local get_cmd = 'demote'
				user_info(user_id, cb_user_info, {receiver = receiver, get_cmd = get_cmd})
			elseif matches[1] == 'demote' and matches[2] and not string.match(matches[2], '^%d+$') then
				local cbres_extra = {
					channel = get_receiver(msg),
					get_cmd = 'demote'
				}
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				return resolve_username(username, callbackres, cbres_extra)
			end
		end

		if matches[1] == "setname" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local set_name = string.gsub(matches[2], '_', '')
			rename_channel(receiver, set_name, ok_cb, false)
		end

		if msg.service and msg.action.type == 'chat_rename' then
			data[tostring(msg.to.id)]['settings']['set_name'] = msg.to.title
			save_data(_config.moderation.data, data)
		end

		if matches[1] == "setabout" and is_momod(msg) then
			local receiver = get_receiver(msg)
			local about_text = matches[2]
			local data_cat = 'description'
			local target = msg.to.id
			data[tostring(target)][data_cat] = about_text
			save_data(_config.moderation.data, data)
			channel_set_about(receiver, about_text, ok_cb, false)
			return "Description Has been Set.\n\nSelect The Chat Again To See The Changes."
		end

		if matches[1] == "setusername" and is_admin1(msg) then
			local function ok_username_cb (extra, success, result)
				local receiver = extra.receiver
				if success == 1 then
					send_large_msg(receiver, "SuperGroup Username Set.\n\nSelect The Chat Again To See The Changes.")
				elseif success == 0 then
					send_large_msg(receiver, "Failed To Set SuperGroup Username.\nUsername May Already Be Taken.\n\nNote: Username Can Use a-z, 0-9 And Underscores.\nMinimum Length Is 5 Characters\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM")
				end
			end
			local username = string.gsub(matches[2], '@', '')
			channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
		end

		if matches[1] == 'setrules' and is_momod(msg) then
			rules = matches[2]
			local target = msg.to.id
			return set_rulesmod(msg, data, target)
		end

		if msg.media then
			if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_momod(msg) then
				load_photo(msg.id, set_supergroup_photo, msg)
				return
			end
		end
		if matches[1] == 'setphoto' and is_momod(msg) then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return 'Please Send The New Group Photo Now\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
		end

		if matches[1] == 'clean' then
			if not is_momod(msg) then
				return
			end
			if not is_momod(msg) then
				return "Only Owner Can Clean"
			end
			if matches[2] == 'modlist' then
				if next(data[tostring(msg.to.id)]['moderators']) == nil then
					return 'No moderator(s) in this SuperGroup.'
				end
				for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
					data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return 'Modlist Has Been Cleaned'
			end
			if matches[2] == 'rules' then
				local data_cat = 'rules'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return "Rules Have Not Been Set\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM"
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				return 'Rules Have Been Cleaned\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
			end
			if matches[2] == 'about' then
				local receiver = get_receiver(msg)
				local about_text = ' '
				local data_cat = 'description'
				if data[tostring(msg.to.id)][data_cat] == nil then
					return 'About Is Not Set\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM'
				end
				data[tostring(msg.to.id)][data_cat] = nil
				save_data(_config.moderation.data, data)
				channel_set_about(receiver, about_text, ok_cb, false)
				return "About has been cleaned"
			end
			if matches[2] == 'mutelist' then
				chat_id = msg.to.id
				local hash =  'mute_user:'..chat_id
					redis:del(hash)
				return "Mutelist Cleaned\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM"
			end
			if matches[2] == 'username' and is_admin1(msg) then
				local function ok_username_cb (extra, success, result)
					local receiver = extra.receiver
					if success == 1 then
						send_large_msg(receiver, "SuperGroup username cleaned.")
					elseif success == 0 then
						send_large_msg(receiver, "Failed to clean SuperGroup username.")
					end
				end
				local username = ""
				channel_set_username(receiver, username, ok_username_cb, {receiver=receiver})
			end
			if matches[2] == "bots" and is_momod(msg) then
				channel_get_bots(receiver, callback_clean_bots, {msg = msg})
			end
		end

		if matches[1] == 'lock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links' then
				return lock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				return lock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				return lock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				return lock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				return lock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				return lock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				return lock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				return lock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				return lock_group_contacts(msg, data, target)
			end
			if matches[2] == 'media' then
				return lock_group_media(msg, data, target)
			end
			if matches[2] == 'fwd' then
				return lock_group_fwd(msg, data, target)
			end
			if matches[2] == 'reply' then
				return lock_group_reply(msg, data, target)
			end
			if matches[2] == 'share' then
				return lock_group_share(msg, data, target)
			end
			if matches[2] == 'tag' then
				return lock_group_tag(msg, data, target)
			end
			if matches[2] == 'bots' then
				return lock_group_bots(msg, data, target)
			end
			if matches[2] == 'number' then
				return lock_group_number(msg, data, target)
			end
			if matches[2] == 'poker' then
				return lock_group_poker(msg, data, target)
			end
			if matches[2] == 'audio' then
				return lock_group_audio(msg, data, target)
			end
			if matches[2] == 'photo' then
				return lock_group_photo(msg, data, target)
			end
			if matches[2] == 'video' then
				return lock_group_video(msg, data, target)
			end
			if matches[2] == 'documents' then
				return lock_group_documents(msg, data, target)
			end
			if matches[2] == 'text' then
				return lock_group_text(msg, data, target)
			end
			if matches[2] == 'all' then
				return lock_group_all(msg, data, target)
			end
			if matches[2] == 'gifs' then
				return lock_group_gifs(msg, data, target)
			end
			if matches[2] == 'inline' then
				return lock_group_inline(msg, data, target)
			end
			if matches[2] == 'cmd' then
				return lock_group_cmd(msg, data, target)
			end
			if matches[2] == 'emoji' then
				return lock_group_emoji(msg, data, target)
			end
			if matches[2] == 'username' then
				return lock_group_username(msg, data, target)
			end
			if matches[2] == 'badwords' then
				return lock_group_badwords(msg, data, target)
			end
			if matches[2] == 'english' then
				return lock_group_english(msg, data, target)
			end
			if matches[2] == 'strict' then
				return enable_strict_rules(msg, data, target)
			end
		end

		if matches[1] == 'unlock' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'links' then
				return unlock_group_links(msg, data, target)
			end
			if matches[2] == 'spam' then
				return unlock_group_spam(msg, data, target)
			end
			if matches[2] == 'flood' then
				return unlock_group_flood(msg, data, target)
			end
			if matches[2] == 'arabic' then
				return unlock_group_arabic(msg, data, target)
			end
			if matches[2] == 'member' then
				return unlock_group_membermod(msg, data, target)
			end
			if matches[2]:lower() == 'rtl' then
				return unlock_group_rtl(msg, data, target)
			end
			if matches[2] == 'tgservice' then
				return unlock_group_tgservice(msg, data, target)
			end
			if matches[2] == 'sticker' then
				return unlock_group_sticker(msg, data, target)
			end
			if matches[2] == 'contacts' then
				return unlock_group_contacts(msg, data, target)
			end
			if matches[2] == 'media' then
				return unlock_group_media(msg, data, target)
			end
			if matches[2] == 'fwd' then
				return unlock_group_fwd(msg, data, target)
			end
			if matches[2] == 'reply' then
				return unlock_group_reply(msg, data, target)
			end
			if matches[2] == 'share' then
				return unlock_group_share(msg, data, target)
			end
			if matches[2] == 'tag' then
				return unlock_group_tag(msg, data, target)
			end
			if matches[2] == 'bots' then
				return unlock_group_bots(msg, data, target)
			end
			if matches[2] == 'number' then
				return unlock_group_number(msg, data, target)
			end
			if matches[2] == 'poker' then
				return unlock_group_poker(msg, data, target)
			end
			if matches[2] == 'audio' then
				return unlock_group_audio(msg, data, target)
			end
			if matches[2] == 'photo' then
				return unlock_group_photo(msg, data, target)
			end
			if matches[2] == 'video' then
				return unlock_group_video(msg, data, target)
			end
			if matches[2] == 'documents' then
				return unlock_group_documents(msg, data, target)
			end
			if matches[2] == 'text' then
				return unlock_group_text(msg, data, target)
			end
			if matches[2] == 'all' then
				return unlock_group_all(msg, data, target)
			end
			if matches[2] == 'gifs' then
				return unlock_group_gifs(msg, data, target)
			end
			if matches[2] == 'inline' then
				return unlock_group_inline(msg, data, target)
			end
			if matches[2] == 'cmd' then
				return unlock_group_cmd(msg, data, target)
			end
			if matches[2] == 'emoji' then
				return unlock_group_emoji(msg, data, target)
			end
			if matches[2] == 'username' then
				return unlock_group_username(msg, data, target)
			end
			if matches[2] == 'badwords' then
				return unlock_group_badwords(msg, data, target)
			end
			if matches[2] == 'english' then
				return unlock_group_english(msg, data, target)
			end
			if matches[2] == 'strict' then
				return disable_strict_rules(msg, data, target)
			end
		end

		if matches[1] == 'setflood' then
			if not is_momod(msg) then
				return
			end
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 20 then
				return "Wrong number,range is [5-20]"
			end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
			return 'Flood has been set to: '..matches[2]
		end
		if matches[1] == 'public' and is_momod(msg) then
			local target = msg.to.id
			if matches[2] == 'yes' then
				return set_public_membermod(msg, data, target)
			end
			if matches[2] == 'no' then
				return unset_public_membermod(msg, data, target)
			end
		end

		if matches[1] == "muteuser" and is_momod(msg) then
			local chat_id = msg.to.id
			local hash = "mute_user"..chat_id
			local user_id = ""
			if type(msg.reply_id) ~= "nil" then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				muteuser = get_message(msg.reply_id, get_message_callback, {receiver = receiver, get_cmd = get_cmd, msg = msg})
			elseif matches[1] == "muteuser" and matches[2] and string.match(matches[2], '^%d+$') then
				local user_id = matches[2]
				if is_muted_user(chat_id, user_id) then
					unmute_user(chat_id, user_id)
					return "["..user_id.."] Removed From The Muted Users List"
				elseif is_owner(msg) then
					mute_user(chat_id, user_id)
					return "["..user_id.."] Added To The Muted User List"
				end
			elseif matches[1] == "muteuser" and matches[2] and not string.match(matches[2], '^%d+$') then
				local receiver = get_receiver(msg)
				local get_cmd = "mute_user"
				local username = matches[2]
				local username = string.gsub(matches[2], '@', '')
				resolve_username(username, callbackres, {receiver = receiver, get_cmd = get_cmd, msg=msg})
			end
		end

		if matches[1] == "mutelist" and is_momod(msg) then
			local chat_id = msg.to.id
			return muted_user_list(chat_id)
		end

		if matches[1] == 'settings' and is_momod(msg) then
			local target = msg.to.id
			return show_supergroup_settingsmod(msg, target)
		end
		
		if matches[1] == 'settingsall' and is_momod(msg) then
			local target = msg.to.id
			return show_supergroup_settingsall(msg, target)
		end

		if matches[1] == 'rules' then
			return get_rules(msg, data)
		end


		if matches[1] == 'peer_id' and is_admin1(msg)then
			text = msg.to.peer_id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		if matches[1] == 'msg.to.id' and is_admin1(msg) then
			text = msg.to.id
			reply_msg(msg.id, text, ok_cb, false)
			post_large_msg(receiver, text)
		end

		--Admin Join Service Message
		if msg.service then
		local action = msg.action.type
			if action == 'chat_add_user_link' then
				if is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.from.id) and not is_owner2(msg.from.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.from.id
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
			if action == 'chat_add_user' then
				if is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					channel_set_admin(receiver, user, ok_cb, false)
				end
				if is_support(msg.action.user.id) and not is_owner2(msg.action.user.id) then
					local receiver = get_receiver(msg)
					local user = "user#id"..msg.action.user.id
					channel_set_mod(receiver, user, ok_cb, false)
				end
			end
		end
		if matches[1] == 'msg.to.peer_id' then
			post_large_msg(receiver, msg.to.peer_id)
		end
	end
end

local function pre_process(msg)
  if not msg.text and msg.media then
    msg.text = '['..msg.media.type..']'
  end
  return msg
end

return {
  patterns = {
	"^[#!/]([Aa]dd)$",
	"^[#!/]([Rr]em)$",
	"^[#!/]([Mm]ove) (.*)$",
	"^[#!/]([Gg]ap)$",
	"^[#!/]([Aa]dmins)$",
	"^[#!/]([Oo]wner)$",
	"^[#!/]([Mm]odlist)$",
	"^[#!/]([Bb]ots)$",
	"^[#!/]([Ww]ho)$",
	"^[#!/]([Kk]icked)$",
    "^[#!/]([Bb]lock) (.*)",
	"^[#!/]([Bb]lock)",
	"^[#!/]([Tt]osuper)$",
	"^[#!/]([Ii][Dd])$",
	"^[#!/]([Ii][Dd]) (.*)$",
	"^[#!/]([Kk]ickme)$",
	"^[#!/]([Kk]ick) (.*)$",
	"^[#!/]([Nn]ewlink)$",
	"^[#!/]([Ss]etlink)$",
	"^[#!/]([Ll]ink)$",
	"^[#!/]([Rr]es) (.*)$",
	"^[#!/]([Ss]etadmin) (.*)$",
	"^[#!/]([Ss]etadmin)",
	"^[#!/]([Dd]emoteadmin) (.*)$",
	"^[#!/]([Dd]emoteadmin)",
	"^[#!/]([Ss]etowner) (.*)$",
	"^[#!/]([Ss]etowner)$",
	"^[#!/]([Pp]romote) (.*)$",
	"^[#!/]([Pp]romote)",
	"^[#!/]([Dd]emote) (.*)$",
	"^[#!/]([Dd]emote)",
	"^[#!/]([Ss]etname) (.*)$",
	"^[#!/]([Ss]etabout) (.*)$",
	"^[#!/]([Ss]etrules) (.*)$",
	"^[#!/]([Ss]etphoto)$",
	"^[#!/]([Ss]etusername) (.*)$",
	"^[#!/]([Dd]el)$",
	"^[#!/]([Ll]ock) (.*)$",
	"^[#!/]([Uu]nlock) (.*)$",
	"^[#!/]([Mm]uteuser)$",
	"^[#!/]([Mm]uteuser) (.*)$",
	"^[#!/]([Pp]ublic) (.*)$",
	"^[#!/]([Ss]ettings)$",
	"^[#!/]([Ss]ettingsall)$",
	"^[#!/]([Rr]ules)$",
	"^[#!/]([Ss]etflood) (%d+)$",
	"^[#!/]([Cc]lean) (.*)$",
	"^[#!/]([Mm]utelist)$",
    "[#!/](mp) (.*)",
	"[#!/](md) (.*)",
    "^(https://telegram.me/joinchat/%S+)$",
	"msg.to.peer_id",
	"%[(document)%]",
	"%[(photo)%]",
	"%[(video)%]",
	"%[(audio)%]",
	"%[(contact)%]",
	"^!!tgservice (.+)$",
  },
  run = run,
  pre_process = pre_process
}
--End supergrpup.lua
--By @To_My_Amigos
