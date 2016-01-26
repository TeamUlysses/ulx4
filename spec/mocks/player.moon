export class player
	@Players: {}

	GetAll: (using nil) ->
		players

	@Add: (ply using nil) ->
		table.insert @Players, ply

export class Player extends Entity
	Name: ""

	@Type: () -> "Player"

	new: (name using nil) =>
		@Name = name

	__tostring: () => "Player [#{@Index}][#{@Name}]"

	GetName: (using nil) =>
		@Name
	Name: GetName
	Nick: GetName

	ChatPrint: (msg) =>
