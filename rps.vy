#Payment: event({amount: int128, arg2: indexed(address)})

# Rock Paper Scissors smart contract
# Author initiates a game with a move and a bet
# Challenger posts their move with bet amount and winner gets balance
# Costs 1 token to play from each player.


# Game  params
# An author sets the bet amount, it's matched by a player which executes the contract.
# Winner get's all proceeds minus necessary GAS
author_address: public(address)
bet: public(wei_value)
author_move: public(int128)


# Current state of game
challenger_address: public(address)

# Set to true at the end, disallows any change
ended: public(bool)

# Create a simple auction with `_bidding_time`
# seconds bidding time on behalf of the
# beneficiary address `_beneficiary`.
@public
@payable
def __init__(_author_address: address, _bet: wei_value, _move: int128):
    self.author_address = _author_address
    #self.game_start = block.timestamp
    self.bet = msg.value
    self.author_move = _move

# Challenge the author by making a move
# together with this transaction.
# The value will only be refunded if the
# auction is not won.
@public
@payable
def challenge():
    # Check if bidding period is over.
    assert not self.ended

    # Ensure the bet we've received from the challender equals that of the author
    assert self.bet == bet

    # Check if bid is high enough
    assert msg.value > self.highest_bid
    if not self.highest_bid == 0:
        # Sends money back to the previous highest bidder
        send(self.highest_bidder, self.highest_bid)

    self.highest_bidder = msg.sender
    self.highest_bid = msg.value

    winner = get_winner(self.author_address, self.author_move, msg.sender, msg.value)

    # If we get a draw, return funds and void contract
    if winner is None:
        self.ended = True
        selfdestruct(self.seller)


    # Completeion effects
    # End the game, send winner the bet plus the others bet
    self.ended = True
    send(winning_address, self.bet)


@private
def get_winner(player_a, player_a,move, player_b, player_b_move):
    # r = 1
    # p =2
    # s = 3
    # Draw if a == b
    # a wins if a - b == 1 or a - b == -2. Draw if a == b
    if player_a_move == player_b_move:
        return None

    result = player_a_move - player_b_move

    if result == 1 or  result == -2:
        return player_a

    return player_b
