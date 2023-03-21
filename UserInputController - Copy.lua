slot0 = class("UserInputController", framework.Mediator)
slot0.NAME = "UserInputController"
slot1 = string.format
slot2 = false

function slot3(slot0, slot1)
	return table.concat(slot0, "+") == table.concat(slot1, "+")
end

slot0.ctor = function (slot0)
	slot0.super.ctor(slot0, slot0.NAME)

	slot0._keyboardListener = nil
	slot0._keyboardEvents = {}
	slot0._keyboardAble = true
	slot0._isPressedShift = false
	slot0._isPressedCtrl = false
	slot0._isPressedAlt = false
	slot0._cursorPosition = {
		x = 0,
		y = 0
	}
	slot0._touchListener = nil
	slot0._touching = false

	return 
end
slot0.destory = function (slot0)
	if slot0.instance then
		global.Facade:removeMediator(slot0.NAME)

		slot0.instance = nil
	end

	return 
end
slot0.Inst = function (slot0)
	if not slot0.instance then
		slot0.instance = slot0.new()

		global.Facade:registerMediator(slot0.instance)
	end

	return slot0.instance
end
slot0.onRegister = function (slot0)
	slot0.super.onRegister(slot0)

	return 
end
slot0.listNotificationInterests = function (slot0)
	return {
		global.NoticeTable.Layer_Moved_Moving,
		global.NoticeTable.PlayerBeDamaged,
		global.NoticeTable.PlayerToMove
	}
end
slot0.handleNotification = function (slot0, slot1)
	slot4 = slot1.getBody(slot1)

	if slot1.getName(slot1) == global.NoticeTable.Layer_Moved_Moving then
		slot0.OnMouseMoved(slot0, slot4)
	elseif slot3 == slot2.PlayerBeDamaged then
		slot0.OnPlayerBeDamaged(slot0)
	elseif slot3 == slot2.PlayerToMove then
		slot0.OnPlayerToMove(slot0)
	end

	return 
end
slot0.InitOnEnterLogin = function (slot0)
	slot0.ResetKeyboard(slot0)
	slot0.InitKeyCodeLogin(slot0)

	return 
end
slot0.InitOnEnterRole = function (slot0)
	slot0.ResetKeyboard(slot0)
	slot0.InitKeyCodeLogin(slot0)

	return 
end
slot0.InitOnEnterWorld = function (slot0)
	slot0.ResetKeyboard(slot0)
	slot0.InitKeyCodeWorld(slot0)
	slot0.ResetTouch(slot0)
	slot0.InitTouch(slot0)

	return 
end
slot0.isTouching = function (slot0)
	return slot0._touching
end
slot0.setIsTouching = function (slot0, slot1)
	slot0._touching = slot1

	return 
end
slot0.isKeyboardAble = function (slot0)
	return slot0._keyboardAble
end
slot0.setKeyboardAble = function (slot0, slot1)
	slot0._keyboardAble = slot1

	return 
end
slot0.onEventUserInput = function (slot0)
	global.Facade:sendNotification(global.NoticeTable.UserInputEventNotice)

	return 
end
slot0.IsPressedShift = function (slot0)
	return slot0._isPressedShift
end
slot0.IsPressedCtrl = function (slot0)
	return slot0._isPressedCtrl
end
slot0.IsPressedAlt = function (slot0)
	return slot0._isPressedAlt
end
slot0.ResetKeyboard = function (slot0)
	if not slot0._keyboardListener then
		return 
	end

	cc.Director:getInstance():getEventDispatcher():removeEventListener(slot0._keyboardListener)

	slot0._keyboardEvents = {}
	slot0._keyboardListener = nil
	slot0._keyboardAble = true
	slot0._isPressedShift = false
	slot0._isPressedCtrl = false
	slot0._isPressedAlt = false

	return 
end
slot0.InitKeyboardListener = function (slot0)
	slot1 = {}

	function slot2()
		if not slot0._keyboardAble then
			return 
		end

		global.userInputController:onEventUserInput()

		for slot3, slot4 in ipairs(slot0._keyboardEvents) do
			if slot1(slot2, slot4.keyCode) then
				if slot4.pressedCB then
					slot4.pressedCB()
				end

				if slot4.interval and 0 < slot4.interval and slot4.timerID == nil then
					slot4.timerID = Schedule(function ()
						global.userInputController:onEventUserInput()

						if global.userInputController.onEventUserInput.pressedCB then
							slot0.pressedCB()
						end

						return 
					end, slot4.interval)
				end

				return 
			end
		end
	end

	function slot3(slot0)
		global.userInputController:onEventUserInput()

		for slot4, slot5 in ipairs(slot0._keyboardEvents) do
			if slot5.timerID then
				UnSchedule(slot5.timerID)

				slot5.timerID = nil
			end
		end

		for slot4, slot5 in ipairs(slot0._keyboardEvents) do
			if slot1({
				slot0
			}, slot5.keyCode) then
				if slot5.releaseCB then
					slot5.releaseCB()
				end

				break
			end
		end

		return 
	end

	slot0._keyboardListener = cc.EventListenerKeyboard:create()

	slot0._keyboardListener:registerScriptHandler(slot4, cc.Handler.EVENT_KEYBOARD_PRESSED)
	slot0._keyboardListener:registerScriptHandler(slot5, cc.Handler.EVENT_KEYBOARD_RELEASED)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(slot0._keyboardListener, 1)

	return 
end
slot0.addKeyboardListener = function (slot0, slot1, slot2, slot3, slot4)
	slot4 = slot4 or 1

	if not slot1 then
		print("ERROR++++++++++++++++++++++++, keyCode is empty")

		return 
	end

	if type(slot1) == "number" then
		table.insert({}, slot1)

		slot1 = {}
	end

	table.insert(slot0._keyboardEvents, {
		keyCode = slot1,
		pressedCB = slot2,
		releaseCB = slot3,
		interval = slot4
	})

	return 
end
slot0.rmvKeyboardListener = function (slot0, slot1)
	if type(slot1) == "number" then
		table.insert({}, slot1)

		slot1 = {}
	end

	for slot5, slot6 in pairs(slot0._keyboardEvents) do
		if slot0(slot6.keyCode, slot1) then
			table.remove(slot0._keyboardEvents, slot5)

			return true
		end
	end

	return false
end
slot0.updateKeyboardListener = function (slot0, slot1, slot2, slot3, slot4)
	if not slot1 then
		print("ERROR++++++++++++++++++++++++, keyCode is empty")

		return 
	end

	if type(slot1) == "number" then
		table.insert({}, slot1)

		slot1 = {}
	end

	for slot8, slot9 in pairs(slot0._keyboardEvents) do
		if slot0(slot9.keyCode, slot1) then
			if slot2 then
				slot9.pressedCB = slot2
			end

			if slot3 then
				slot9.releaseCB = slot3
			end

			if slot4 then
				slot9.interval = slot4
			end

			return true
		end
	end

	return false
end
slot0.InitKeyCodeLogin = function (slot0)
	slot0.InitKeyboardListener(slot0)
	global.userInputController:addKeyboardListener(slot2, slot1, nil, 0)
	global.userInputController:addKeyboardListener(cc.KeyCode.KEY_KP_ENTER, function ()
		global.Facade:sendNotification(global.NoticeTable.Layer_Enter_Current)

		return 
	end, nil, 0)

	return 
end
slot0.InitKeyCodeWorld = function (slot0)
	slot0.InitKeyboardListener(slot0)

	if global.OperatingMode ~= global.MMO.OPERATING_MODE_WINDOWS then
		return nil
	end

	for slot4 = 1, 8, 1 do
		slot7 = nil

		slot0.addKeyboardListener(slot0, cc.KeyCode[string.format("KEY_F%s", slot4)], function ()
			if not global.Facade:retrieveProxy(global.ProxyTable.Skill):GetSkillByKey(global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)) then
				return false
			end

			slot3 = slot2.MagicID

			if global.gamePlayerController:GetMainPlayer() and slot4.GetHorseMasterID(slot4) then
				return false
			end

			if slot1.IsOnoffSkill(slot1, slot3) then
				slot1.RequestSkillOnoff(slot1, slot3)

				return 
			end

			global.Facade:sendNotification(global.NoticeTable.UserInputLaunch, {
				skillID = slot3,
				destPos = slot0.getCursorMapPosition(slot0)
			})

			return 
		end, nil, 0.1)
	end

	for slot4 = 1, 8, 1 do
		slot7 = nil

		slot0.addKeyboardListener(slot0, {
			cc.KeyCode.KEY_CTRL,
			cc.KeyCode[string.format("KEY_F%s", slot4)]
		}, function ()
			if not global.Facade:retrieveProxy(global.ProxyTable.Skill):GetSkillByKey(slot0 + 8) then
				return false
			end

			if slot1.IsOnoffSkill(slot1, slot2.MagicID) then
				slot1.RequestSkillOnoff(slot1, slot3)

				return 
			end

			global.Facade:sendNotification(global.NoticeTable.UserInputLaunch, {
				skillID = slot3,
				destPos = slot0.getCursorMapPosition(slot0)
			})

			return 
		end, nil, 0.1)
	end

	slot1 = global.Facade:retrieveProxy(global.ProxyTable.Skill)

	for slot5 = 1, 6, 1 do
		slot6 = 1
		slot7 = nil

		function slot8()
			slot0 = global.Facade:retrieveProxy(global.ProxyTable.QuickUseProxy)

			if slot0.GetQucikUseDataByPos(slot0, slot0) then
				global.Facade:retrieveProxy(global.ProxyTable.ItemUseProxy):UseItem(slot1)
			end

			return 
		end

		slot0.addKeyboardListener(slot0, cc.KeyCode[string.format("KEY_%s", slot5)], function ()
			slot0()

			if slot1 then
				UnSchedule(slot1)

				slot1 = nil
			end

			slot1 = Schedule(Schedule, slot2)

			return 
		end, function ()
			if slot0 then
				UnSchedule(UnSchedule)

				slot0 = nil
			end

			return 
		end)
	end

	slot0.addKeyboardListener(slot0, slot4, slot2, slot3, -1)
	slot0.addKeyboardListener(slot0, slot7, slot5, slot6, -1)
	global.userInputController:addKeyboardListener(slot9, slot8)
	global.userInputController:addKeyboardListener(slot11, slot10)
	global.userInputController:addKeyboardListener(slot13, slot12)
	global.userInputController:addKeyboardListener(slot15, slot14)
	global.userInputController:addKeyboardListener(slot17, slot16)
	global.userInputController:addKeyboardListener(slot19, slot18)
	global.userInputController:addKeyboardListener(slot21, slot20)
	global.userInputController:addKeyboardListener(slot23, slot22)
	global.userInputController:addKeyboardListener(slot25, slot24)
	global.userInputController:addKeyboardListener(slot27, slot26)
	global.userInputController:addKeyboardListener(slot29, slot28)
	global.userInputController:addKeyboardListener(slot32, slot30, slot31)
	global.userInputController:addKeyboardListener(slot34, slot33)
	global.userInputController:addKeyboardListener(slot36, slot35)

	slot37 = global.Facade:retrieveProxy(global.ProxyTable.HeroPropertyProxy)

	global.userInputController:addKeyboardListener(slot38, slot39)
	global.userInputController:addKeyboardListener(slot40, slot41)
	global.userInputController:addKeyboardListener(slot42, slot43)
	global.userInputController:addKeyboardListener(slot44, slot45)
	global.userInputController:addKeyboardListener(slot46, slot47)
	global.userInputController:addKeyboardListener(slot48, slot49)
	global.userInputController:addKeyboardListener(slot50, slot51)
	global.userInputController:addKeyboardListener(slot52, slot53)
	global.userInputController:addKeyboardListener(slot54, slot55)
	global.userInputController:addKeyboardListener(slot56, slot57)
	global.userInputController:addKeyboardListener(slot59, slot58, nil, 0)
	global.userInputController:addKeyboardListener(slot60, slot58, nil, 0)

	function slot61(slot0, slot1)
		if not global.Facade:retrieveMediator("MainPropertyMediator") and slot2._layer._quickUI.ListView_chat then
			return 
		end

		slot7 = slot4.getInnerContainerPosition(slot4)

		if slot4.getInnerContainerSize(slot4).height - slot4.getContentSize(slot4).height <= 0 then
			return 
		end

		slot4.scrollToPercentVertical(slot4, math.min(math.max(0, (slot5.height - slot6.height + slot7.y + ((slot0 and -((slot1 and slot6.height) or 14)) or (slot1 and slot6.height) or 14))/slot10*100), 100), 0.03, false)

		return 
	end

	global.userInputController:addKeyboardListener(slot62, slot63)
	global.userInputController:addKeyboardListener(slot64, slot65)
	global.userInputController:addKeyboardListener(slot66, slot67)
	global.userInputController:addKeyboardListener(cc.KeyCode.KEY_PG_DOWN, function ()
		slot0(false, true)

		return 
	end)

	return 
end
slot0.ResetTouch = function (slot0)
	if not slot0._touchListener then
		return nil
	end

	cc.Director:getInstance():getEventDispatcher():removeEventListener(slot0._touchListener)

	slot0._cursorPosition = {
		x = 0,
		y = 0
	}
	slot0._touchListener = nil
	slot0._touching = false

	return 
end
slot0.InitTouch = function (slot0)
	slot1 = nil

	if slot0 then
		slot4 = cc.Label:createWithTTF("", "fonts/font.ttf", 24)
		slot1 = slot4

		slot4.enableOutline(slot4, cc.Color4B.BLACK, 1)
		slot4.setAnchorPoint(slot4, cc.p(0.5, 1))
		slot4.setPosition(slot4, global.Director:getVisibleOrigin().x + global.Director:getVisibleSize().width/2, global.Director.getVisibleOrigin().y + global.Director.getVisibleSize().height)
		global.sceneGraphCtl:GetUiNormal():addChild(slot4, 9991)
	end

	function slot2(slot0)
		if slot0 then
			if not Screen2World(slot0) then
				return nil
			end

			slot6, slot7 = global.sceneManager:WorldPos2MapPos(slot1)

			slot0:setString(string.format("[Mx%d,My:%d][tx:%d,ty:%d]", slot2, slot3, global.sceneManager:MapPos2WorldPos(slot2, slot3, true).x, global.sceneManager.MapPos2WorldPos(slot2, slot3, true).y))
		end

		return 
	end

	slot0._touchListener = cc.EventListenerTouchOneByOne:create()

	slot0._touchListener:registerScriptHandler(slot3, cc.Handler.EVENT_TOUCH_BEGAN)
	slot0._touchListener:registerScriptHandler(slot4, cc.Handler.EVENT_TOUCH_MOVED)
	slot0._touchListener:registerScriptHandler(slot5, cc.Handler.EVENT_TOUCH_ENDED)
	slot0._touchListener:registerScriptHandler(slot6, cc.Handler.EVENT_TOUCH_CANCELLED)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(slot0._touchListener, global.gameWorldController)

	return 
end
slot0.OnMouseMoved = function (slot0, slot1)
	slot0._cursorPosition = slot1.pos

	return 
end
slot0.GetCursorPos = function (slot0)
	return slot0._cursorPosition
end
slot0.RequestToOutGame = function (slot0, ...)
	function slot1(...)
		if slot0._timerID then
			UnSchedule(slot0._timerID)

			UnSchedule._timerID = nil

			global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
		end

		global.Director:getOpenGLView():endToLua()

		return 
	end

	if slot0._timerID then
		UnSchedule(slot0._timerID)

		slot0._timerID = nil
	end

	if slot0._leaveID then
		UnSchedule(slot0._leaveID)

		slot0._leaveID = nil
	end

	if CHECK_SERVER_OPTION("DelayBQuit") then
		if CHECK_SERVER_OPTION("nBQuitTime") and tonumber(slot2) then
			global.Facade:sendNotification(global.NoticeTable.Main_Add_QuitTimeTips, {
				type = 2,
				time = tonumber(slot2)
			})

			slot0._timerID = Schedule(slot1, tonumber(slot2))
		else
			slot1()
		end
	else
		slot1()
	end

	return 
end
slot0.RequestLeaveRole = function (slot0, ...)
	function slot1(...)
		if slot0._leaveID then
			UnSchedule(slot0._leaveID)

			UnSchedule._leaveID = nil

			global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
		end

		global.Facade:sendNotification(global.NoticeTable.LeaveWorld2Role)

		return 
	end

	if slot0._leaveID then
		UnSchedule(slot0._leaveID)

		slot0._leaveID = nil
	end

	if slot0._timerID then
		UnSchedule(slot0._timerID)

		slot0._timerID = nil
	end

	if CHECK_SERVER_OPTION("boDelaySQuit") then
		if CHECK_SERVER_OPTION("nSQuitTime") and tonumber(slot2) then
			global.Facade:sendNotification(global.NoticeTable.Main_Add_QuitTimeTips, {
				type = 1,
				time = tonumber(slot2)
			})

			slot0._leaveID = Schedule(slot1, tonumber(slot2))
		else
			slot1()
		end
	else
		slot1()
	end

	return 
end
slot0.OnPlayerBeDamaged = function (slot0, ...)
	if slot0._timerID and CHECK_SERVER_OPTION("boBQuitStruckBreak") then
		UnSchedule(slot0._timerID)

		slot0._timerID = nil

		global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
	end

	if slot0._leaveID and CHECK_SERVER_OPTION("boSQuitStruckBreak") then
		UnSchedule(slot0._leaveID)

		slot0._leaveID = nil

		global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
	end

	return 
end
slot0.OnPlayerToMove = function (slot0, ...)
	if slot0._timerID and CHECK_SERVER_OPTION("boBQuitMoveBreak") then
		UnSchedule(slot0._timerID)

		slot0._timerID = nil

		global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
	end

	if slot0._leaveID and CHECK_SERVER_OPTION("boSQuitMoveBreak") then
		UnSchedule(slot0._leaveID)

		slot0._leaveID = nil

		global.Facade:sendNotification(global.NoticeTable.Main_Remove_QuitTimeTips)
	end

	return 
end

return slot0
