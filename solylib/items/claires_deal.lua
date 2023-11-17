-- index table by [weapon id][untekked][weapon special]
local claires_deal_weapons = {
	[0x000100] = {
		[true] = {
			[27] = true, -- Shock Saber
	 		[28] = true, -- Thunder Saber
		},
		[false] = {
			[27] = true, -- Shock Saber
		},
	},
	[0x000401] = {
		[true] = {
			[35] = true,	-- Panic Halbert
	 		[36] = true,	-- Riot Halbert
	 		[37] = true,	-- Havoc Halbert
		},
		[false] = {
			[36] = true,	-- Riot Halbert
		},
	},
	[0x000502] = {
		[true] = {
			[24] = true, -- Fire Cutter
			[25] = true, -- Flame Cutter
			[26] = true, -- Burning Cutter
		},
		[false] = {
			[25] = true, -- Flame Cutter
		},
	},
	[0x000C00] = {
		[true] = {
			[5] = true, -- Heart Wand
	 		[6] = true, -- Mind Wand
		},
		[false] = {
			[5] = true, -- Heart Wand
		},
	},
	[0x000A02] = {
		[true] = {
			[1] = true, -- Draw Mace
	 		[2] = true, -- Drain Mace
		},
		[false] = {
			[1] = true, -- Draw Mace
		},
	},
	[0x000601] = {
		[true] = {
			[9] = true, -- Master's Autogun
	 		[10] = true, -- Lord's Autogun
		},
		[false] = {
			[9] = true, -- Master's Autogun
		},
	},
	[0x000701] = {
		[true] = {
			[31] = true, -- Dim Sniper
	 		[32] = true, -- Shadow Sniper
	 		[33] = true, -- Dark Sniper
		},
		[false] = {
			[32] = true, -- Shadow Sniper
		},
	},
	[0x000804] = {
		[true] = {
			[12] = true, -- Charge Vulcan
		},
		[false] = {
			[12] = true, -- Charge Vulcan
		},
	},
	[0x000903] = {
		[true] = {
			[20] = true, -- Hold Launcher
	 		[21] = true, -- Seize Launcher
	 		[22] = true, -- Arrest Launcher
		},
		[false] = {
			[21] = true, -- Seize Launcher
		},
	},
	[0x000200] = {
		[true] = {
			[15] = true, -- Ice Sword
	 		[16] = true, -- Frost Sword
		},
	},
	[0x000303] = {
		[true] = {
			[6] = true, -- Mind Edge
	 		[7] = true, -- Soul Edge
	 		[8] = true, -- Geist Edge
		},
		[false] = {
			[7] = true, -- Soul Edge
		},
	},
	[0x000703] = {
		[true] = {
			[39] = true, -- Devil's Beam
	 		[40] = true, -- Demon's Beam
		},
	},
	[0x001005] = {
		[true] = {
			[31] = true, -- Agito (1977)
		},
		[false] = {
			[31] = true, -- Agito (1977)
		},
	} ,
	[0x001006] = {
		[true] = {
			[31] = true, -- Agito (1980)
		},
		[false] = {
			[31] = true, -- Agito (1980)
		},
	},
	[0x001002] = {
		[true] = {
			[31] = true, -- Agito (1983)
		},
		[false] = {
			[31] = true, -- Agito (1983)
		},
	},
	[0x001004] = {
		[true] = {
			[31] = true, -- Agito (1991)
		},
		[false] = {
			[31] = true, -- Agito (1991)
		},
	},
	[0x001003] = {
		[true] = {
			[31] = true, -- Agito (2001)
		},
		[false] = {
			[31] = true, -- Agito (2001)
		},
	},
	[0x008900] = {
		[true] = {
			[14] = true, -- Musashi
		},
		[false] = {
			[14] = true, -- Musashi
		},
	},
	[0x008901] = {
		[true] = {
			[18] = true, -- Yamato
		},
		[false] = {
			[18] = true, -- Yamato
		},
	},
	[0x008902] = {
		[true] = {
			[26] = true, -- Asuka
		},
		[false] = {
			[26] = true, -- Asuka
		},
	},
	[0x008A00] = {
		[true] = {
			[3] = true, -- Sange
		},
		[false] = {
			[3] = true, -- Sange
		},
	},
	[0x00C600] = {
		[true] = {
			[31] = true, -- Shichishito
		},
		[false] = {
			[31] = true, -- Shichishito
		},
	},
	[0x00B400] = {
		[true] = {
			[40] = true, -- Kusanagi
		},
		[false] = {
			[40] = true, -- Kusanagi
		},
	},
	[0x000309] = {
		[true] = {
			[33] = true, -- Kamui
		},
		[false] = {
			[33] = true, -- Kamui
		},
	},
	[0x002200] = {
		[true] = {
			[0] = true, -- Caduceus
		},
		[false] = {
			[0] = true, -- Caduceus
		},
	},
	[0x000B05] = {
		[true] = {
			[13] = true, -- Brave Hammer
		},
		[false] = {
			[13] = true, -- Brave Hammer
		},
	},
	[0x00C500] = {
		[true] = {
			[0] = true, -- Glide Divine
		},
		[false] = {
			[0] = true, -- Glide Divine
		},
	},
	[0x000B03] = {
		[true] = {
			[10] = true, -- Lord's Striker
	 		[11] = true, -- King's Striker
		},
		[false] = {
			[11] = true, -- King's Striker
		},
	}
}
-- index table by [guard id]
local claires_deal_guards = {
	[0x010333] = true, -- HP/Restorate
	[0x010334] = true, -- HP/Generate
	[0x010335] = true, -- HP/Revival
	[0x010336] = true, -- TP/Restorate
	[0x010337] = true, -- TP/Generate
	[0x010338] = true, -- TP/Revival
	[0x010339] = true, -- PB/Amplifier
	[0x01033A] = true, -- PB/Generate
	[0x01033B] = true, -- PB/Create
 	[0x01033C] = true, -- Wizard/Technique
	[0x01033D] = true, -- Devil/Technique
	[0x01033E] = true, -- God/Technique
	[0x01028A] = true, -- Yata Mirror
	[0x010348] = true, -- Yasakani Magatama
	[0x010138] = true, -- Black Odoshi Domaru
	[0x010139] = true, -- Red Odoshi Domaru
	[0x01022E] = true, -- Gods Shield "Byakko"
	[0x01022C] = true, -- Gods Shield "Suzaku"
	[0x01022D] = true, -- Gods Shield "Genbu"
	[0x01022F] = true, -- Gods Shield "Seiryu"
	[0x01021F] = true, -- Secret Gear
	[0x010224] = true, -- Flowen's Shield
	[0x01028F] = true, -- DF Shield
	[0x010291] = true, -- De Rol Le Shield
	[0x010216] = true, -- Sacred Guard
	[0x010219] = true, -- Light Relief
}
-- index table by [tool id]
local claires_deal_tools = {
	[0x031100] = true, -- Book of Katana 1
	[0x031101] = true, -- Book of Katana 2
	[0x031102] = true, -- Book of Katana 3
	[0x030D13] = true, -- Rappy's Wing
	[0x030E08] = true, -- Magic Rock "Moola"
}
local IsClairesDealItem = function (item)
	-- WEAPON
	if item.data[1] == 0 then
		local a = claires_deal_weapons[item.hex]
		if a ~= nil then
			a = a[item.weapon.untekked]
			if a ~= nil then
				return a[item.weapon.special] ~= nil
			end
		end
	-- GUARD
	elseif item.data[1] == 1 or  item.data[2] == 2 or item.data[2] == 3 then
		return claires_deal_guards[item.hex] ~= nil
 	-- TOOL
    elseif item.data[1] == 3 then
       	return claires_deal_tools[item.hex] ~= nil
	end
	return false
end

return {
	IsClairesDealItem = IsClairesDealItem,
}