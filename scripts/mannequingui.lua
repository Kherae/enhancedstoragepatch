require("/scripts/shared/gui/denyitem.lua")
require("/scripts/shared/gui/options.lua")

function init()
	widget.setButtonEnabled("equipFunctional",false)
	widget.setButtonEnabled("equipCosmetic",false)
	itemConfig = {}
	acceptTypes = config.getParameter("acceptTypes")

	initOptions("/interface/scripted/mannequin/mannequin")

	self.functionalSlots = {
		head = {slot = 1, validType = "headarmor"},
		chest = {slot = 2, validType = "chestarmor"},
		legs = {slot = 3, validType = "legsarmor"},
		back = {slot = 4, validType = "backarmor"}
	}

	self.cosmeticSlots = {
		headCosmetic = {slot = 1, validType = "headarmor"},
		chestCosmetic = {slot = 2, validType = "chestarmor"},
		legsCosmetic = {slot = 3, validType = "legsarmor"},
		backCosmetic = {slot = 4, validType = "backarmor"}
	}
end


function update(dt)
	--[[if acceptTypes then
		denyInvalidItems(false, false, true)
	end]]
	equipCooldown=math.max(0,(equipCooldown or 1.0) - dt)
	widget.setButtonEnabled("equipFunctional",equipCooldown<=0)
	widget.setButtonEnabled("equipCosmetic",equipCooldown<=0)
end


function swapGender()
	world.sendEntityMessage(pane.containerEntityId(), "swapGender")
end


function equipFunctional()
	equip(self.functionalSlots)
end


function equipCosmetic()
	equip(self.cosmeticSlots)
end


function equip(slotMap)
	if equipCooldown and equipCooldown > 0 then
		return
	end
	widget.setButtonEnabled("equipFunctional",false)
	widget.setButtonEnabled("equipCosmetic",false)
	local contents = widget.itemGridItems("itemGrid")
	for slotName, slotConfig in pairs(slotMap) do
		local item = contents[slotConfig.slot]
		if item == nil or root.itemType(item.name) == slotConfig.validType then
			world.containerSwapItems(pane.containerEntityId(), player.equippedItem(slotName), slotConfig.slot - 1)
			player.setEquippedItem(slotName, item)
		end
	end
	equipCooldown=1.0
end


function interfaceColors()
	interfaceColorsCallback("/interface/scripted/mannequin/mannequin")
end
