
AddCSLuaFile( )

if not ConVarExists( "npcg_antlion_startburrow" ) then CreateConVar(	"npcg_antlion_startburrow" , 		"0" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_antlion_eludeburrow" ) then CreateConVar(	"npcg_antlion_eludeburrow" , 		"0" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_antlion_alertrange" ) then CreateConVar(	"npcg_antlion_alertrange" , 			"8192" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_antlion_barktoggle" ) then CreateConVar(	"npcg_antlion_barktoggle" , 			"1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_antlion_cavern" ) then CreateConVar(	"npcg_antlion_cavern" , 				"1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_randomizer_antlion" ) then CreateConVar(	"npcg_randomizer_antlion" , "1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_wakeradius_antlion" ) then CreateConVar(	"npcg_wakeradius_antlion" , "500" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_squad_antlion" ) then CreateConVar(	"npcg_squad_antlion" , 				"1" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_healthoverride_antlion" ) then CreateConVar(	"npcg_healthoverride_antlion" , 	"125" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end
if not ConVarExists( "npcg_healthvariant_antlion" ) then CreateConVar(	"npcg_healthvariant_antlion" , 	"0" , { FCVAR_REPLICATED , FCVAR_ARCHIVE } ) end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Friendly Antlion Soldier Spawner"
ENT.Author = "V92"
ENT.Information = ""
ENT.Category = "NPCGroups"
ENT.Spawnable = false
ENT.AdminOnly = false

if SERVER then

	function ENT:Initialize( )

		self:SetModel( "models/props_c17/oildrum001.mdl" )
		self:DrawShadow( false )
		self:SetNoDraw( true )
		self:SetNotSolid( true )

		if ConVarExists( "npcg_weapondrop" ) and GetConVarNumber( "npcg_weapondrop" ) != 0 then self.weaponNum = 8192 else self.weaponNum = 0 end
		if GetConVarNumber( "npcg_ignorepushing" ) != 0 then self.pushNum = 16384 else self.pushNum = 0 end
		if GetConVarNumber( "npcg_fade_corpse" ) != 0 then self.fadeNum = 512 else self.fadeNum = 0 end
		if GetConVarNumber( "npcg_longvision" ) != 0 then self.longNum = 256 else self.longNum = 0 end
		if GetConVarNumber( "npcg_antlion_eludeburrow" ) != 0 then self.eludeBurrowNum = 65536 else self.eludeBurrowNum = 0 end
		if ConVarExists( "npcg_antlion_startburrow" ) then self.startBurrow = GetConVarNumber( "npcg_antlion_startburrow" ) else self.startBurrow = 0 end
		if ConVarExists( "npcg_wakeradius_antlion" ) then self.wakeRadius = GetConVarNumber( "npcg_wakeradius_antlion" ) else self.wakeRadius = 512 end
		if ConVarExists( "npcg_antlion_alertrange" ) then self.alertRange = GetConVarNumber( "npcg_antlion_alertrange" ) else self.alertRange = 512 end

		self.kvNum = 0
		
		self.ent1 = ents.Create( "npc_antlion" )
		self.ent1:SetPos( self:GetPos( ) )
		self.ent1:SetSkin( math.random( 0 , 3 ) )
		self.ent1:SetKeyValue( "spawnflags" , tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
		self.ent1:SetKeyValue( "startburrowed" , tostring( self.startBurrow ) )
		self.ent1:SetKeyValue( "wakeradius" , tostring( self.wakeRadius ) )
		self.ent1:SetKeyValue( "radius" , tostring( self.alertRange ) )
		self.ent1:Spawn( )
		self.ent1:Activate( )
		self.ent1:SetSchedule( SCHED_IDLE_WANDER )

		if GetConVarNumber( "npcg_squad_antlion" ) != 0 then

			self.ent1:SetKeyValue( "SquadName" , "Antlion" )

		end

		if GetConVarNumber( "npcg_squad_wakeupall" ) != 0 then

			self.ent1:SetKeyValue( "wakesquad" , 1 )

	end
		
		self.ent1:AddRelationship( "player D_LI 200" )
		self.ent1:AddRelationship( "npc_citizen D_LI 200" )
		self.ent1:AddRelationship( "npc_vortigaunt D_LI 200" )

		if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then

			self.ent1:SetAngles( Angle( 0 , 0 , 0 ) )

		else
			self.ent1:SetAngles( Angle( 0 , math.random( 0 , 360 ) , 0 ) )

		end

		timer.Simple( 0 , function( )

			undo.Create( self.PrintName )

			undo.AddEntity( self )

			if self.ent1:IsValid( ) then undo.AddEntity( self.ent1 ) end

			undo.SetCustomUndoText( "Undone " .. self.PrintName )
			undo.SetPlayer( self.Owner )

			undo.Finish( )

		end )

	end

	function ENT:Think( )

		if !self.ent1:IsValid( ) then 	

			self.ent1 = ents.Create( "npc_antlion" )
			self.ent1:SetPos( self:GetPos( ) )
			self.ent1:SetSkin( math.random( 0 , 3 ) )
			self.ent1:SetKeyValue( "spawnflags" , tostring( self.kvNum + self.longNum + self.pushNum + self.fadeNum + self.eludeBurrowNum ) )
			self.ent1:SetKeyValue( "startburrowed" , tostring( self.startBurrow ) )
			self.ent1:SetKeyValue( "wakeradius" , tostring( self.wakeRadius ) )
			self.ent1:SetKeyValue( "radius" , tostring( self.alertRange ) )
			self.ent1:Spawn( )
			self.ent1:Activate( )
			self.ent1:SetSchedule( SCHED_IDLE_WANDER )
			self.ent1:AddRelationship( "player D_LI 200" )
			self.ent1:AddRelationship( "npc_citizen D_LI 200" )
			self.ent1:AddRelationship( "npc_vortigaunt D_LI 200" )

			if GetConVarNumber( "npcg_squad_antlion" ) != 0 then
				self.ent1:SetKeyValue( "SquadName" , "Antlion" )
			end

			if GetConVarNumber( "npcg_squad_wakeupall" ) != 0 then 
				self.ent1:SetKeyValue( "wakesquad" , 1 ) 
			end

			if ConVarExists( "npcg_randomyaw" ) and GetConVarNumber( "npcg_randomyaw" ) == 0 then
				self.ent1:SetAngles( Angle( 0 , 0 , 0 ) ) 
			else
				self.ent1:SetAngles( Angle( 0 , math.random( 0 , 360 ) , 0 ) ) 
		end

	end

end

end
