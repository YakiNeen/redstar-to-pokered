VermilionCityScript:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, VermilionCityScript_197cb
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, VermilionCityScript_197c0
	ld hl, VermilionCityScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

VermilionCityScript_197c0:
	call Random
	ld a, [$ffd4]
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionCityScript_197cb:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
	ld a, [wSpriteStateData1 + 9]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_19810
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.asm_19810
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret

CoordsData_19823:
	db $1e,$12
	db $ff

VermilionCityScript4:
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityTextPointers:
	dw VermilionCityText1
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionCityText15
	dw VermilionCityText7
	dw VermilionCityText8
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText11
	dw VermilionCityText12
	dw VermilionCityText13

VermilionCityText1:
	TX_FAR _VermilionCityText1
	db "@"

VermilionCityText2:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_1989e
	ld hl, VermilionCityText_198a7
	call PrintText
	jr .asm_198a4
.asm_1989e
	ld hl, VermilionCityText_198ac
	call PrintText
.asm_198a4
	jp TextScriptEnd

VermilionCityText_198a7:
	TX_FAR _VermilionCityText_198a7
	db "@"

VermilionCityText_198ac:
	TX_FAR _VermilionCityText_198ac
	db "@"

VermilionCityText3:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_198f6
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_RIGHT
	jr z, .asm_198c8
	ld hl, VermilionCityCoords1
	call ArePlayerCoordsInArray
	jr nc, .asm_198d0
.asm_198c8
	ld hl, SSAnneWelcomeText4
	call PrintText
	jr .asm_198fc
.asm_198d0
	ld hl, SSAnneWelcomeText9
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .asm_198e9
	ld hl, SSAnneNoTicketText
	call PrintText
	jr .asm_198fc
.asm_198e9
	ld hl, SSAnneFlashedTicketText
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .asm_198fc
.asm_198f6
	ld hl, SSAnneNotHereText
	call PrintText
.asm_198fc
	jp TextScriptEnd

VermilionCityCoords1:
	db $1d,$13
	db $1f,$13
	db $ff

SSAnneWelcomeText4:
	TX_FAR _SSAnneWelcomeText4
	db "@"

SSAnneWelcomeText9:
	TX_FAR _SSAnneWelcomeText9
	db "@"

SSAnneFlashedTicketText:
	TX_FAR _SSAnneFlashedTicketText
	db "@"

SSAnneNoTicketText:
	TX_FAR _SSAnneNoTicketText
	db "@"

SSAnneNotHereText:
	TX_FAR _SSAnneNotHereText
	db "@"

VermilionCityText4:
	TX_FAR _VermilionCityText4
	db "@"

VermilionCityText5:
	TX_FAR _VermilionCityText5
	TX_ASM
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityText14
	ret

VermilionCityText14:
	TX_FAR _VermilionCityText14
	db "@"

VermilionCityText6:
	TX_FAR _VermilionCityText6
	db "@"

VermilionCityText7:
	TX_FAR _VermilionCityText7
	db "@"

VermilionCityText8:
	TX_FAR _VermilionCityText8
	db "@"

VermilionCityText11:
	TX_FAR _VermilionCityText11
	db "@"

VermilionCityText12:
	TX_FAR _VermilionCityText12
	db "@"

VermilionCityText13:
	TX_FAR _VermilionCityText13
	db "@"

VermilionCityText15:
	TX_ASM
	callba .func_f1a0f
	jp TextScriptEnd

.func_f1a0f:
	ld a, [wPlayerStarter]
	cp SQUIRTLE
	jr z, .starter_squirtle
	CheckEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	jr nz, .asm_f1a69
	ld a, [wObtainedBadges]
	bit 2, a ; THUNDERBADGE
	jr nz, .asm_f1a24
	ld hl, OfficerJennyText1
	call PrintText
	ret

.asm_f1a24
	ld hl, OfficerJennyText2
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_f1a62
	ld a, SQUIRTLE
	ld [wd11e], a
	ld [wcf91], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	lb bc, SQUIRTLE, 10
	call GivePokemon
	ret nc
	ld a, [wAddedToParty]
	and a
	call z, WaitForTextScrollButtonPress
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, OfficerJennyText3
	call PrintText
	SetEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	ret

.asm_f1a62
	ld hl, OfficerJennyText4
	call PrintText
	ret

.asm_f1a69
	ld hl, OfficerJennyText5
	call PrintText
	ret

.starter_squirtle
	CheckEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	jr nz, .got_rare_candy
	ld hl, OfficerJennyText6
	call PrintText
	lb bc, RARE_CANDY, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_SQUIRTLE_FROM_OFFICER_JENNY
	ld hl, OfficerJennyText7
	jr .done
.bag_full
	ld hl, OfficerJennyText8
	jr .done
.got_rare_candy
	ld hl, OfficerJennyText9
.done
	call PrintText
	ret

OfficerJennyText1:
	TX_FAR _OfficerJennyText1
	db "@"

OfficerJennyText2:
	TX_FAR _OfficerJennyText2
	db "@"

OfficerJennyText3:
	TX_FAR _OfficerJennyText3
	db $d
	db "@"

OfficerJennyText4:
	TX_FAR _OfficerJennyText4
	db "@"

OfficerJennyText5:
	TX_FAR _OfficerJennyText5
	db "@"

OfficerJennyText6:
	TX_FAR _OfficerJennyText6
	db "@"

OfficerJennyText7:
	TX_FAR _OfficerJennyText7
	TX_SFX_ITEM_1
	db "@"

OfficerJennyText8:
	TX_FAR _OfficerJennyText8
	db "@"

OfficerJennyText9:
	TX_FAR _OfficerJennyText9
	db "@"
