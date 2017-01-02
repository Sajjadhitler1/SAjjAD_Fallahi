local function run(msg, matches)
    if is_momod(msg) then
        return msg
    end
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings'] then
            if data[tostring(msg.to.id)]['settings']['lock_emoji'] then
                lock_audio = data[tostring(msg.to.id)]['settings']['lock_emoji']
            end
        end
    end
    local chat = get_receiver(msg)
    local user = "user#id"..msg.from.id
    if lock_emoji == "yes" then
        send_large_msg(get_receiver(msg), "Sending Emoji Is Forbidden\n\nCreated By @To_My_Amigos\nOur Channel @AntiSpam_TM")
        chat_del_user(chat, user, ok_cb, false)
		delete_msg(msg.id, ok_cb, true)
    end
end

return {patterns = {
"😞(.+)",
 "😞",
 "😐(.+)",
 "😐",
 "🙁(.+)",
 "🙁",
 "🌝(.+)",
 "🌝",
 "🤖(.+)",
 "🤖",
 "😲(.+)",
 "😲",
 "💋(.+)",
 "💋",
 "🙄(.+)",
 "🙄",
 "🤗(.+)",
 "🤗",
 "😱(.+)",
 "😱",
 "🤐(.+)",
 "🤐",
 "💩(.+)",
 "💩",
 "🌹(.+)",
 "🌹",
 "🖐(.+)",
 "🖐",
 "❤️(.+)",
 "❤️",
 "💗(.+)",
 "💗",
 "🤔(.+)",
 "🤔",
 "😖(.+)",
 "😖",
 "☹️(.+)",
 "☹️",
 "😔(.+)",
 "😔",
 "👾(.+)",
 "👾",
 "🚀(.+)",
 "🚀",
 "🌎🌍(.+)",
 "🌍",
 "🍦",
 "😸(.+)",
 "😺",
 "😯(.+)",
 "😯",
 "🤒(.+)",
 "🤒",
 "😷(.+)",
 "😷",
 "🙀(.+)",
 "🙀",
 "🎪(.+)",
 "🌚",
 "🌚(.+)",
 "😂",
 "😂(.+)",
 "😳",
 "😳(.+)",
 "😛",
 "😛(.+)",
 "😢",
 "😢(.+)",
 "😓",
 "😓(.+)",
 "😾",
 "😾(.+)",
 "👊🏻",
 "👊🏻(.+)",
 "✊🏻",
 "✊🏻(.+)",
 "👿",
 "👿(.+)",
 "👅",
 "👅(.+)",
 "🖕🏿",
 "🖕🏿(.+)",
 "😲",
 "😲(.+)",
 "👹",
 "👹(.+)",
 "😴",
 "😴(.+)",
 "☂",
 "☂(.+)",
 "🗣",
 "🗣(.+)",
 "⛄️",
 "⛄️(.+)",
 "😻",
 "😻(.+)",
"😀(.+)",
 "😀",
 "😬(.+)",
 "😬",
 "😁(.+)",
 "😁",
 "😂(.+)",
 "😂",
 "😃(.+)",
 "😃",
 "😄(.+)",
 "😄",
 "😅",
 "😆(.+)",
 "😆",
 "😇(.+)",
 "😇",
 "😉(.+)",
 "😉",
 "😊(.+)",
 "😊",
 "🙂(.+)",
 "🙂",
 "🙃(.+)",
 "🙃",
 "☺️(.+)",
 "☺️",
 "😋(.+)",
 "😋",
 "😌",
 "😍(.+)",
 "😍",
 "😘(.+)",
 "😘",
 "😗(.+)",
 "😗",
 "😙(.+)",
 "😙",
 "😚(.+)",
 "😚",
 "😜(.+)",
 "😜",
 "😝(.+)",
 "😝",
 "🤑(.+)",
 "🤑",
 "🤓(.+)",
 "🤓",
 "😎(.+)",
 "😎",
 "🤗(.+)",
 "🤗",
 "😏(.+)",
 "😏",
 "😶(.+)",
 "😶",
 "😺(.+)",
 "😺",
 "😰(.+)",
 "😹(.+)",
 "😼",
 "😿(.+)",
 "😰",
 "🌝(.+)",
 "🌚(.+)",
 "🌶(.+)",
 "🖐🏼(.+)",
  "^[😀😬😁😂😃😄😅☺️🙃🙂😊😉😆😋😌😍😘😗😚🤗😎🤓🤑😛😝😜😏😐😑😒🙄🤔😕😔😡😠😟😞😳🙁☹️😣😖😫😩😤😧😦😯😰😨😱😮😢😥😪😓😭😵😲💩💤😴🤕🤒😷🤐😈👿👹👺💀👻👽😽😼😻😹😸😺🤖🙀😿😾🙌👏👋👍👐✋👌✌✊👊👎🙏☝️👆👇👈👉👄💅✍🖖🤘🖐🖕👅👂👃👁👀👤👥👱👩👩👨👧👦👶🗣👴🕵🎅👰🚶🏃👼💁🙇👭👬👫👯💃🙅🙆🙋🙎🙍💇💆👪👨‍❤️‍💋‍👨👩‍❤️‍💋‍👩💏👨‍❤️‍👨👩‍❤️‍👩💑👨‍👩‍👧👨‍👩‍👧‍👦👨‍👩‍👦‍👦👨‍👩‍👧‍👧👩‍👩‍👦👩‍👩‍👧👩‍👩‍👧‍👦👨‍👨‍👧‍👧👨‍👨‍👦‍👦👨‍👨‍👧‍👦👨‍👨‍👧👨‍👨‍👦👩‍👩‍👧‍👧👩‍👩‍👦‍👦👚👕👖👔👗👙👘👞👢👡👠👣💋💄👟👒🎩🎓👑⛑🎒💍🕶👓💼👜👛👝🌂❤️💛💚💙💜💔💘💖💗💓💞💕❣💝🐼🐻🐰🐹🐭🐱🐶🦁🐮🐷🐽🐸🐔🐒🙊🙉🙈🐵🐙🐤🐣🐥🐺🐗🐜🐞🐌🐛🐝🦄🦄🕷🦂🦀🐍🐢🐠🐟🐅🐆🐊🐋🐳🐬🐡🐃🐂🐄🐪🐫🐘🐐🐓🐁🐀🐖🐎🐑🐏🦃🕊🐕🐩🐈🐇🐿🌳🌲🎄🌵🐲🐉🐾🌴🌱🌿☘🍀🎍🎋🌹🌻🌺🍁🍂🍃🌷🌼🌸🍄🌰🎃🌕🌏🌍🌎🕸🐚🌗🌘🌑🌒🌓🌔🌚🌟⭐️🌙🌞🌜🌛🌝💫✨☄☀️🌤⛅️🌥🔥⚡️🌩⛈🌧☁️🌦💥❄️🌨☃⛄️🌬💨🌊💦💧☔️☂🌫🌪🍉🍌🍋🍊🍐🍎🍏🍇🍓🍈🍒🍑🍍🍅🧀🍞🍯🍠🌽🌶🍆🍗🍖🍤🍳🍔🍟🌭🍥🍲🍜🌯🌮🍝🍕🍣🍱🍛🍙🍚🍘🍢🍮🎂🍰🍦🍨🍧🍡🍬🍭🍫🍿🍩🍪🍺🍵🍶🍾🍹🍹🍸🍷🍻☕️🍼🍴🍽⚽️🏀🏈🏌⛳️🎱🏉🏐🎾⚾️🏓🏸🏒🏑🏏🎿⛷🏄🏊🚣🎣🏹⛸🏂🛀⛹🏋🚴🚵🏇🕴🎫🏵🎗🎖🏅🎽🏆🎟🎭🎨🎪🎤🎧🎼🎮🎬🎻🎸🎺🎷🎹👾🎯🎲🎰🎳⌚️📱🖲🖱🖨🖥⌨💻📲🕹🗜💽💾💿📀📼📞🎞📽🎥📹📸📷☎️📟🎛⏱⏲⏰🕰🔦💡🔌🔋📡⌛️⏳💶💴💵💸🛢🗑🕯💷💰💳💎⚖🔧🔨🔫⛓⚙🔩⛏🛠⚒💣🗡⚔🛡🚬☠⚗💈📿🔮🏺⚱⚰🏷🌡💉💊🕳🔬🔭🔖🚽🚿🛁🔑🗝🛋⛱🗺🖼🛎🚪🛏🛌🗿🛍🎈🎏🎀🎁🎊📩✉️🏮🎌🎐🎎🎉📨📧💌📮📪📫📬📃📜📤📥📯📦📭📑📊📈📉📄📅📆🗒📋🗄🗳🗃📇🗓📁📂🗂🗞📰📓📕📖📚📒📔📙📘📗🔗📎🖇✂️📐📏📌🔓🔒🔐🏴🏳🚩📍🔏🖊🖋✒️📝✏️🖍🔎🔍🖌🚓🏎🚎🚌🚙🚕🚗🚒🚐🚚🚛🚜🏍🚡🚖🚘🚍🚔🚨🚲🚠🚟🚃🚋🚝🚄🚅🚉🚊🚇🚆🚂🚞🚈🚁🛩✈️🛫🛬⛵️🛥⚓️💺🛰🚀🛳⛴🚤🚧⛽️🚏🚦🚥🏁🚢🏭🗼🌁🏗🎠🎢🎡⛲️🎑⛰🏔🗻🌋🗾🌄🌅🛤🛣🏞⛺️🏕🏜🏖🏝🌇🌆🏙🌃🏘🌈🎆🎇🌠🌌🌉🏰🏯🏟🗽🏠🏡🏚🏨🏦🏥🏤🏣🏬🏢🏪🏫🏩💒🏛⛪️🕌🇦🇿🇦🇹🇦🇺🇮🇷⛩🕋🕍🇦🇽🇦🇱🇩🇿🇦🇸🇦🇮🇦🇴🇦🇩🇧🇸🇦🇫🇦🇼🇦🇲🇦🇷🇦🇬🇦🇶🇧🇩🇧🇧🇧🇭🇧🇾🇧🇿🇧🇪🇧🇯🇧🇷🇧🇼🇧🇦🇧🇶🇧🇴🇧🇬🇧🇲🇮🇴🇧🇳🇧🇫🇧🇮🇧🇹🇻🇺🇻🇦🇻🇳🇹🇱🇻🇮🇻🇬🇻🇪🇭🇺🇬🇧🇬🇦🇭🇹🇬🇾🇬🇲🇬🇭🇬🇵🇬🇹🇭🇰🇭🇳🇬🇮🇬🇬🇩🇪🇬🇼🇬🇳🇬🇩🇬🇱🇬🇷🇬🇪🇬🇺🇩🇰🇯🇪🇪🇭🇿🇲🇪🇬🇪🇺🇩🇴🇩🇲🇩🇯🇿🇼🇮🇱🇮🇳🇮🇩🇯🇴🇮🇶🇮🇷🇰🇿🇨🇻🇾🇪🇮🇹🇪🇸🇮🇸🇮🇪🇰🇾🇰🇭🇨🇲🇨🇦🇮🇨🇶🇦🇰🇪🇨🇴🇨🇨🇰🇵🇨🇳🇰🇮🇰🇬🇨🇾🇰🇲🇨🇬🇨🇩🇽🇰🇨🇷🇨🇺🇱🇧🇱🇷🇱🇸🇱🇻🇱🇦🇨🇼🇰🇼🇱🇾🇱🇹🇱🇮🇱🇺🇲🇺🇲🇷🇲🇬🇲🇻🇲🇱🇲🇾🇲🇼🇲🇰🇲🇴🇾🇹🇲🇹🇲🇦🇲🇶🇲🇭🇲🇽🇫🇲🇲🇿🇳🇷🇳🇦🇲🇲🇲🇸🇲🇳🇲🇨🇲🇩🇳🇵🇳🇪🇳🇬🇳🇱🇳🇮🇳🇺🇳🇿🇨🇰🇸🇭🇨🇽🇮🇲🇳🇴🇳🇨🇹🇨🇦🇪🇴🇲🇵🇰🇵🇼🇵🇸🇵🇦🇵🇷🇵🇹🇵🇱🇵🇳🇵🇪🇵🇾🇵🇬🇰🇷🇷🇪🇷🇺🇷🇼🇷🇴🇸🇻🇼🇸🇧🇱🇸🇬🇸🇴🇹🇿🇹🇲🇫🇴🇺🇾🇹🇳🇹🇼🇸🇧🇷🇸🇸🇨🇲🇵🇱🇨🇺🇸🇹🇭🇹🇻🇼🇫🇺🇦🇹🇹🇹🇯🇸🇮🇰🇳🇸🇿🇸🇦🇻🇨🇸🇰🇸🇱🇹🇴🇺🇿🇺🇬🇹🇰🇸🇷🇸🇾🇸🇳🇸🇹🇸🇲🇵🇲🇸🇽🇸🇩🇹🇬🇹🇷🇫🇯🇵🇭🇫🇮🇫🇰🇫🇷🇬🇫🇵🇫🇨🇱🇨🇿🇲🇪🇹🇩🇨🇫🇭🇷🇹🇫🇨🇭🇸🇪🇱🇰🇪🇨🇬🇶🇪🇷🇪🇪🇮🇷🇯🇵🇯🇲🇸🇸🇬🇸🇿🇦🇪🇹🕧🕦🕥🕤🕝🕞🕟🕠🕡🕢🕡🕢🕣🕜🕛🕚🕙🕘🕗🕖💬🕐🕑🕒🕓🕔🕕🗯💭👁‍🗨🎴♦️♥️♣️📣📢🔔🔕🃏🀄️♠️🔇◾️▪️🔴🔛💲✖️🔙⚫️🔺◻️🔊🔉🔷🔷⚪️🔚➗➖™🔘🔶🔻🔈🔳⬜️🔹☑️®➕🔃©🔜🔸⬛️🔲◽️▫️🔵🔝💱✔️➰🔤↪️↗️🔽⏩⏮🔼⬇️🔄ℹ️〰🎶*⃣↔️⬆️◀️⏭⏺🔂⬅️↕️🎵🔣⤵️↖️➡️🔁⏹⏯🔀⏬↙️⤴️🔠🔡↩️↘️⏫⏪⏸▶️5⃣🆕🎦🅿️🛂🈂🚾🚮🆒4⃣🔢🔟3⃣🆙🚻🚭🏧Ⓜ️♿️🚼🆗2⃣9⃣8⃣1⃣🆖🚺🛅🌐➿🛄🚹🈁0⃣7⃣6⃣📶🚰🛃🛃🌀💠♻️🔆❕🚷⛔️🆘♨️❗️🔅🔰✅❎🚸💯📵💢🅾🆑⭕️🔞⁉️⚠️✳️❇️〽️‼️🚱❌🆎🅱🚫🚳❔⚜💹🈯️🔱❓📛📛🅰🈲🉑🈶☫♏️♈️⛎♎️⚛📳🆚🈵🈴✴️📴🆔♍️🛐☦♌️♓️☣🈷㊗️㊙️🈺☢♒️♋️☯🕎♊️♑️🈹🈸🉐💮🈚️🈳♐️♉️🔯💟☮✝☪🕉☸✡](.+)$",
  },run = run}
