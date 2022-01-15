dofile( "data/scripts/perks/perk.lua" )
dofile_once("data/scripts/lib/utilities.lua")
function OnWorldPostUpdate() --check whether there are "markable" entity near mouse.
	--if _enemy_information_gui_main then _enemy_information_gui_main() end
	local player_id= EntityGetWithTag("player_unit")[1]
	if player_id == nil then return end

	local ctrl_components = EntityGetComponentIncludingDisabled(player_id, "ControlsComponent")
	local mouse_x,mouse_y
	if(ctrl_components ~= nil) then
		edit_component2(player_id,"ControlsComponent",function (comp,vars)
			--get mouse position
			mouse_x,mouse_y = ComponentGetValue2(comp, "mMousePosition")
		end )
	end

	--get the interact entity. Create one if doesn't exist, in case mod is enabled in a started game.
	local mark_interact = EntityGetWithName("mod_enemy_mark_interact")
	if mark_interact == 0 or mark_interact ==nil then
		mark_interact = EntityLoad( "mods/mark_enemy/entities/interact_mark_enemy.xml")
		EntityAddChild( player_id, mark_interact)
	end

	--check "markable" entity, and enable or disenable the  InteractableComponent in interact entity.
	local px,py = EntityGetTransform(player_id)
	local enemies = EntityGetInRadiusWithTag( mouse_x,mouse_y, 30,"enemy")
	if (#enemies > 0) or ((math.abs(mouse_x - px) + math.abs(mouse_y - py)) < 20) then
		EntitySetComponentsWithTagEnabled( mark_interact, "enabled_near_enemy", true )
	else
		EntitySetComponentsWithTagEnabled( mark_interact, "enabled_near_enemy", false )
	end
end

function OnPlayerSpawned( player_entity )
	--add the interact entity to player when game begin, and check whether the interact entity has been added to player.
	local mark_interact = EntityGetWithName("mod_enemy_mark_interact")
	if mark_interact == 0 or mark_interact ==nil then
		mark_interact = EntityLoad( "mods/mark_enemy/entities/interact_mark_enemy.xml")
		EntityAddChild( player_entity, mark_interact)
	end
end

local translation = ModTextFileGetContent("data/translations/common.csv") .. ModTextFileGetContent("mods/mark_enemy/translation/common.csv")
ModTextFileSetContent("data/translations/common.csv", translation)

