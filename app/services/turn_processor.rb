class TurnProcessor
  def initialize(game, target)
    @game   = game
    @target = target
    @messages = []
  end

  def run!
    attack_opponent
    game.save!
  rescue MessageGenerator => e
    @messages << e.message
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def player
    Player.new(game.player_1_board)
  end

  def opponent
    Player.new(game.player_2_board)
  end

  def attack_opponent
    result = Shooter.fire!(board: opponent.board, target: target)
    @messages << "Your shot resulted in a #{result}."
    game.player_1_turns += 1
  end

  def ai_attack_back
    result = AiSpaceSelector.new(player.board).fire!
    @messages << "The computer's shot resulted in a #{result}."
    game.player_2_turns += 1
  end
end
