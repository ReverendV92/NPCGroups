
AddCSLuaFile()

if !ConVarExists( "npcg_antlion_startburrow" ) then CreateConVar(	"npcg_antlion_startburrow", 		"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_antlion_eludeburrow" ) then CreateConVar(	"npcg_antlion_eludeburrow", 		"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_antlion_alertrange" ) then CreateConVar(	"npcg_antlion_alertrange", 			"8192",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_antlion_barktoggle" ) then CreateConVar(	"npcg_antlion_barktoggle", 			"1",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_antlion_cavern" ) then CreateConVar(	"npcg_antlion_cavern", 				"1",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_randomizer_antlion" ) then CreateConVar(	"npcg_randomizer_antlion",			"1",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_wakeradius_antlion" ) then CreateConVar(	"npcg_wakeradius_antlion",			"500",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_squad_antlion" ) then CreateConVar(	"npcg_squad_antlion", 				"1",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthoverride_antlion" ) then CreateConVar(	"npcg_healthoverride_antlion",	 	"125",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end
if !ConVarExists( "npcg_healthvariant_antlion" ) then CreateConVar(	"npcg_healthvariant_antlion",	 	"0",		{	FCVAR_REPLICATED, FCVAR_ARCHIVE }	) end

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Antlion Swarm"
ENT.Author			= "Neotanks/V92"
ENT.Information		= ""
ENT.Category		= "NPCGroups"
ENT.Spawnable		= false
ENT.AdminOnly		= true

if SERVER then
	function ENT:Initialize()
		if ConVarExists("npcg_ignorepushing") and GetConVarNumber("npcg_ignorepushing") != 0 then	self.pushNum = 16384	else	self.pushNum = 0	end
		if ConVarExists("npcg_fade_corpse") and GetConVarNumber("npcg_fade_corpse") != 0 then	self.fadeNum = 512	else	self.fadeNum = 0	end
		if ConVarExists("npcg_longvision") and GetConVarNumber("npcg_longvision") != 0 then	self.longNum = 256	else	self.longNum = 0	end
		if ConVarExists("npcg_antlion_eludeburrow") and GetConVarNumber("npcg_antlion_eludeburrow") != 0 then	self.eludeBurrowNum = 65536	else	self.eludeBurrowNum = 0	end
		if ConVarExists("npcg_antlion_startburrow") then self.startBurrow = GetConVarNumber( "npcg_antlion_startburrow" ) else self.startBurrow = 0 end
		if ConVarExists("npcg_wakeradius_antlion") then self.wakeRadius = GetConVarNumber( "npcg_wakeradius_antlion" ) else self.wakeRadius = 512 end
		if ConVarExists("npcg_antlion_alertrange") then self.alertRange = GetConVarNumber( "npcg_antlion_alertrange" ) else self.alertRange = 512 end
		
		self.kvNum = 0
		
		if IsMounted( "ep2" ) and GetConVarNumber("npcg_squaddies_worker") != 0 then
			self.ent1 = ents.Create("npc_antlion_worker") 
			self.ent1:SetPos(self:GetPos())
			if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent1:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent1:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
			self.ent1:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
			self.ent1:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
			self.ent1:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
			self.ent1:SetKeyValue( "radius", tostring( self.alertRange ) )
			self.ent1:Spawn()
			self.ent1:Activate()
			self.ent1:SetSchedule( SCHED_IDLE_WANDER )
		else
			self.ent1 = ents.Create("npc_antlion") 	
			self.ent1:SetPos(self:GetPos())
			if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent1:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent1:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
			self.ent1:SetSkin( math.random( 0, 3 ) )
			self.ent1:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
			self.ent1:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
			self.ent1:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
			self.ent1:SetKeyValue( "radius", tostring( self.alertRange ) )
			self.ent1:Spawn()
			self.ent1:Activate()
			self.ent1:SetSchedule( SCHED_IDLE_WANDER )
		end
		
		self.ent2 = ents.Create("npc_antlion")
		self.ent2:SetPos(self:GetPos() + self:GetForward() * 100 + self:GetRight() * 100)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent2:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent2:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent2:SetSkin( math.random( 0, 3 ) )
		self.ent2:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent2:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent2:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent2:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent2:Spawn()
		self.ent2:Activate()
		self.ent2:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent3 = ents.Create("npc_antlion")
		self.ent3:SetPos(self:GetPos() + self:GetForward() * 100 + self:GetRight() * -100)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent3:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent3:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent3:SetSkin( math.random( 0, 3 ) )
		self.ent3:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent3:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent3:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent3:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent3:Spawn()
		self.ent3:Activate()
		self.ent3:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent4 = ents.Create("npc_antlion")
		self.ent4:SetPos(self:GetPos() + self:GetForward() * -100 + self:GetRight() * 100)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent4:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent4:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent4:SetSkin( math.random( 0, 3 ) )
		self.ent4:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent4:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent4:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent4:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent4:Spawn()
		self.ent4:Activate()
		self.ent4:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent5 = ents.Create("npc_antlion")
		self.ent5:SetPos(self:GetPos() + self:GetForward() * -100 + self:GetRight() * -100)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent5:SetAngles( Angle( 0 , 0 , 0 ) )
			else
			self.ent5:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
			end
		self.ent5:SetSkin( math.random( 0, 3 ) )
		self.ent5:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent5:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent5:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent5:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent5:Spawn()
		self.ent5:Activate()
		self.ent5:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent6 = ents.Create("npc_antlion")
		self.ent6:SetPos(self:GetPos() + self:GetForward() * 0 + self:GetRight() * 200)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent6:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent6:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent6:SetSkin( math.random( 0, 3 ) )
		self.ent6:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent6:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent6:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent6:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent6:Spawn()
		self.ent6:Activate()
		self.ent6:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent7 = ents.Create("npc_antlion")
		self.ent7:SetPos(self:GetPos() + self:GetForward() * 0 + self:GetRight() * -200)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent7:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent7:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent7:SetSkin( math.random( 0, 3 ) )
		self.ent7:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent7:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent7:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent7:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent7:Spawn()
		self.ent7:Activate()
		self.ent7:SetSchedule( SCHED_IDLE_WANDER )
		
		self.ent8 = ents.Create("npc_antlion")
		self.ent8:SetPos(self:GetPos() + self:GetForward() * -200 + self:GetRight() * 0)
		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
			self.ent8:SetAngles( Angle( 0 , 0 , 0 ) )
		else
			self.ent8:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		end
		self.ent8:SetSkin( math.random( 0, 3 ) )
		self.ent8:SetKeyValue( "spawnflags", tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent8:SetKeyValue( "startburrowed", tostring( self.startBurrow )  )
		self.ent8:SetKeyValue( "wakeradius", tostring( self.wakeRadius ) )
		self.ent8:SetKeyValue( "radius", tostring( self.alertRange ) )
		self.ent8:Spawn()
		self.ent8:Activate()
		self.ent8:SetSchedule( SCHED_IDLE_WANDER )
		
		if GetConVarNumber( "npcg_squad_antlion" ) != 0	then
			self.ent1:SetKeyValue( "SquadName", "Antlion" )
			self.ent2:SetKeyValue( "SquadName", "Antlion" )
			self.ent3:SetKeyValue( "SquadName", "Antlion" )
			self.ent4:SetKeyValue( "SquadName", "Antlion" )
			self.ent5:SetKeyValue( "SquadName", "Antlion" )
			self.ent6:SetKeyValue( "SquadName", "Antlion" )
			self.ent7:SetKeyValue( "SquadName", "Antlion" )
			self.ent8:SetKeyValue( "SquadName", "Antlion" )
		else
			return
		end
		if GetConVarNumber( "npcg_squad_wakeupall" ) != 0	then	
			self.ent1:SetKeyValue( "wakesquad", 1 ) 
			self.ent2:SetKeyValue( "wakesquad", 1 ) 
			self.ent3:SetKeyValue( "wakesquad", 1 ) 
			self.ent4:SetKeyValue( "wakesquad", 1 ) 
			self.ent5:SetKeyValue( "wakesquad", 1 ) 
			self.ent6:SetKeyValue( "wakesquad", 1 ) 
			self.ent7:SetKeyValue( "wakesquad", 1 ) 
			self.ent8:SetKeyValue( "wakesquad", 1 ) 
		end

		timer.Simple(0, function()
			undo.Create( self.PrintName )
				if self.ent1:IsValid() then undo.AddEntity(self.ent1) end
				if self.ent2:IsValid() then undo.AddEntity(self.ent2) end
				if self.ent3:IsValid() then undo.AddEntity(self.ent3) end
				if self.ent4:IsValid() then undo.AddEntity(self.ent4) end
				if self.ent5:IsValid() then undo.AddEntity(self.ent5) end
				if self.ent6:IsValid() then undo.AddEntity(self.ent6) end
				if self.ent7:IsValid() then undo.AddEntity(self.ent7) end
				if self.ent8:IsValid() then undo.AddEntity(self.ent8) end
				undo.SetCustomUndoText("Undone " .. self.PrintName )
				undo.SetPlayer(self.Owner)
			undo.Finish()
			self:Remove()
		end)
	end
end