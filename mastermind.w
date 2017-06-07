% Mastermind using c++11 standard

\parskip 8pt plus 4pt

@* Mastermind. Mastermind written in {CWEB} program and c++.

So the simple solution I have for the computer guessing. Which is really the only hard part of the program. Even then it's fairly simple. Is this.

We have some set $S$ of all possible codes from what we know.

$S$ will initially contain every possible combination of code for the set of colours $C$ and set of positions $P$. That is $S$ will contain the set of permutations with replacement of $C$ objects choose $P$ size with order being important.

The computer will pick at random a guess $g$ where $g \in S$

The players answer $a$ where $a \in S$ will then be checked against the computers guess $g$ by the player who will enter in the number of colours out of position $c_i$ and colours matching positions $p_i$ for each guess $i$. 

$\{c_i, p_i\}$ where $0 \le c_i \le \mid C \mid$ and $0 \le p_i \le \mid P \mid$

The computer will then use this information to remove all impossible/bad codes $B$ where $B \subseteq S$ from $S$ then $f: S \mapsto S \setminus B$

The computer will then have a smaller set $S$ of possible codes and pick one at random $g$. Repeating the process above.

Proposed colours are: Red, Purple, Blue, Green, Yellow, Grey, Aqua, Pink. Further colours if needed should be chosen from the set of console colours under a terminal window in Ubuntu

@ It might be possible to spread the calculations of the program for removing and picking a guess over all guesses.

Say we have a set of previous guesses and answers $G = (g_i, C_i, P_i)$

If we pick a guess at random from our set of possible answers $S$. Then check if the guess is possible against all previous guesses and answers.

If it doesn't match we get the next one. Either random or the next in the set $S$. Any O(1) selection should do.

Now there might be a potential issue with performance. What if we recheck elements in $G$ in a guess? Well we won't because if a code in $S$ is checked and doesn't pass it is removed from $S$ as it is an impossible code. If any element passes and thus is possible it is removed from $S$ and used as a guess $g_i$

Thus no code will ever be checked twice against the same guess $e \in G$ because any code that is checked can be removed immediately by simply removing $g_i$ as it takes place. A simple swap in an array with the last possible code in $S$ and reducing the size by $1$ will remove the guess $g_i$ in $O(n)$

@ Another idea. Instead of picking a random start each guess. I can shuffle $S$ at the beginning. I have to create all possible codes anyway and if I shuffle them I can just go through the list. Skipping over any that aren't possible.

The first guess will always be O(1) with a shuffle of O(n) and build of $S$ of O(n).

Each subsequent guess will only require O(n) with no swaps. Which should reduce the amount of work done between each guess.

If $S$ is ever empty when the computer tries to find another guess to try the player has cheated. Inform them of such.

@c
@<Includes@>@;
@<Globals@>@;
@<Main Function@>@;

@ Well thinking about the problem I'll need to read from stdin and print to stdout. So iostream needs to be included.

I'll also need to read that input into something. Ints are standard but I'd like to have letter inputs for colours and possibly prompted questions.

Do you want to play again y/n?

Who would you like to guess (y)ou or the (c)omputer?

So I'll need to include String.

There's also the possibility of yes, no, YES, NO, YeS, No, yay, nay. At some point I'll need to make a design decision on how/if i'll support those things.

It might be an idea to include if possible a help option. help or ?. As well as a quit at any time option. Exit gracefully if you will. quit, q, etc

Anyway they all need strings so include strings.

Thinking a head it would probably be easiest to use a vector rather than an array for memory management.

Also algorithm is awesome and I'm sure I'll use it since I do for any other code I write in c++ now days. So I'll include algorithm.

Those header files should take care of the core of any program I would want to write. input, output, strings, arrays and algorithms.




@<Includes@>=
#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

@*Main function. Setup variables. Welcome player. Start game.
@<Main Function@>=
int main(@<Main Parameters@>)
{
@<Main Declarations@>@;
@<Main Initialisations@>@;
@<Intro@>@;
@<Game Loop@>@;

return 0;
}

@ I can only think of one global at the moment which is using the standard name space if I so choose.

Oh I found a use. It would be helpful to have a comparison function to tell if something is a possible code for a partition algorithm.

I decided against using a function for checking if a guess is possible. I'll need to use a tweaked partition algorithm

@ No partition algorithm as per the main explaintation. Only a shuffle is required.

@<Globals@>=
using namespace std;

@ Probably won't use these but it doesn't hurt to have them.
@<Main Parameters@>=
int argc, char ** argv

@ Variables needed for main
@<Main Declarations@>=
string input;

@ Initialising main variables
@<Main Initialisations@>=
input = "";

@* Introduction. Tell the player what they are playing, welcome them.
@<Intro@>=

string welcome = "Welcome to Mastermind! Press enter to continue: ";
int count = 1;
for(char&c : welcome)
{
	if(count == 16)
	{
		count = 1;
	}
	cout << @<Colour escape sequence begin@> << count++ << @<Colour escape sequence end@> << c;
}

getline(cin, input);

@<Reset console@>@;

@*Game loop.

Each iteration will require the following.

Knowing the game size. Number of colours and positions.

Who is guessing and who is making the code. Player or computer.

Repeated guessing of a code and answer of the number of colour and position matches.

A conclusion when the code is guessed.

Escape from game if the player doesn't want to play again.

Ideally there should be some sort of in game help and way to exit gracefully at any point.

@<Game Loop@>=

for (bool play_again = true; play_again; )
{
	@<Game loop variables@>
    @<Ask player for game size@>
	@<Ask who is guessing@>
	if(player_guessing)
	{
		cout << "Okay you are guessing!" << endl;
		@<Player guess code loop@>
		@<Congraulate player on winning@>
	}
	else
	{
		cout << "Okay the computer is guessing the code" << endl;
		@<Computer guesses players code loop@>
		if(player_cheated)
		{
			@<Tell player they cheated@>
		}
		else
		{
			@<Computer claims victory@>
		}
	}
	cout << "Would you like to play again? y/n: " << endl;
	@<Ask if player wants to play again@>
}

@ Variables needed for the game loop.

I'll need something for input to read from stdin

The size of the game, $C$ and $P$, number of colours and positions.
@<Game loop variables@>=
bool player_guessing = true;
bool player_cheated = false;
string input;
int @<$C$@> @<Set to@> 0;
int @<$P$@> @<Set to@> 0;
int @<Number of Codes@> @<Set to@> 0;
int @<Number of guesses@> @<Set to@> 0;


@ The game requires the player to enter a size. Number of colours and the number of positions.
@<Prompt player for game size@>=
cout << "Please enter the game size in format 'colours positions'\nwith a maximum of " << @<Colour names@>.size() << " colours. Eg; 6 4: ";
getline(cin, input);

@ The players input will be captured as a string in input. This means we need to extract the integers if there are any or gracefully fail. They might have entered help or quit.
@<Read input into $C$ and $P$@>=
ss.clear();
ss.str(string());
ss << input;
try {
ss >> @<$C$@> >> @<$P$@>;
}
catch(...)
{
	@<$C$@> @<Set to@> 0;
	@<$P$@> @<Set to@> 0;
}


@ We need a string stream for formatted input and output over a string used to read in player input as numbers.
@<Includes@>=
#include <sstream>

@ Need a string stream for formatted text input. This is so we can read in both an integer and string from stdin and then read that into an integer if need be or keep the string to use for a command reference like help or quit.
@<Globals@>=
stringstream ss;

@ Print the colour options for a player to choose from.
 Looks like I'll need a vector or array holding the console colours and colour names as options eg; (R)ed

@<Print colours to choose from@>=

cout << "Match the letter between the brackets () for the colour\nyou wish to guess for each position.\nYou can choose from ";@;
cout << @<Colour escape sequence begin@> << @<Colour codes@>[0] << @<Colour escape sequence end@> << @<Colour with shortcuts@>[0] << @<Reset colour code@>;


for(int i = 1; i < C || (C == 0 && i < 8); i++)
{
	if(i < C - 1 || (C == 0 && i < 7) )
	{
		cout << ", ";
	}
	else
	{
		cout << " and ";
	}
	if(i == 5)
	{
		cout << '\n';
	}
	cout << @<Colour escape sequence begin@> << @<Colour codes@>[i] << @<Colour escape sequence end@> << @<Colour with shortcuts@>[i] << @<Reset colour code@>;
	
}
cout << endl;

@ Ask the player who is guessing the code. The computer or player.

Ask if player is guessing or computer is guessing

Repeatedly ask until player enters correct code for one or the other.

Print help or quit program if help or quit option is entered.

@<Ask who is guessing@>=

@<Print player/computer selection options@>@;
@<Read string input@>@;
while(@<Haven't selected computer or player@>)
{
	@<If help code entered print help@>@;
	@<If quit code entered quit@>@;
	
	@<Print player/computer selection options@>@;
	@<Read string input@>@;
}
@<Set who is guessing@>@;

@
@<Print player/computer selection options@>=
cout << "Who would you like to guess the code? (Y)ou or the (C)omputer? ";
@
@<Haven't selected computer or player@>=
input != "y" && input != "c"

@ If the player enters a y then they are guessing, other wise if they enter a c then the computer is guess.

player guessing should be the variable we store this in. Maybe should have been a macro but oh well.

@<Set who is guessing@>=
player_guessing = input == "y";


@ Game size should be a positive number for both colour and position. Not sure on maximum sizes but it would stand to reason that the number of colours $C$ and positions $P$ should be such that $C^P \le $ something viable.
@<Ask player for game size@>=
@<Prompt player for game size@>@;
@<Read input into $C$ and $P$@>@;
@<While $C < 1 \lor P < 1 \lor C^P > MAX \lor C > Colour Limit$@>@;
{
	@<convert input to lowercase@>@;
	@<If help code entered print help@>@;
	@<If quit code entered quit@>@;
	@<If we did not print help or quit tell the user they entered the wrong size. Give simple contraints@>@;
	@<Prompt player for game size@>@;
	@<Read input into $C$ and $P$@>@;
}

@ Omg this needs to be some sort of macro not the end of asking player for game size. Did I delete something here accidently?
Oh right this is my integer pow function for somewhere down below. $C^P$
@<Set number of codes to size of game $C^P$@>=
@<Number of Codes@> @<Set to@> 1;

for(int i = 0; i < @<$P$@>; i++)
{
	@<Number of Codes@> @<Set to@> @<Number of Codes@> @<Times@> @<$C$@>;
}

@ We'll need cctype for to lower
@<Includes@>=
#include <cctype>

@ Convert input string to lowercase
@<convert input to lowercase@>=
for(auto &c : input)
	c = tolower(c);

@ While constraints on colour and position sizes $C$ and $P$ are not met.
@<While $C < 1 \lor P < 1 \lor C^P > MAX \lor C > Colour Limit$@>=
while(@<$C < 1 \lor P < 1 \lor C^P > MAX \lor C > Colour Limit$@>)

@ Our range check on $C$ and $P$
@<$C < 1 \lor P < 1 \lor C^P > MAX \lor C > Colour Limit$@>=
(@<$C$@> < 1 || @<$P$@> < 1 || pow(@<$C$@>, @<$P$@>) > 20000000 || C > @<Colour names@>.size() )
	
@ Since I need to use a pow function to calculate the number of possible codes I'll need to add math.h

Actual I just need this for a check to make sure $C^P$ isn't greater than the max size I want.

Using the pow in a loop would be bad so I made my own.
@<Includes@>=
#include <math.h>

@
@<If we did not print help or quit tell the user they entered the wrong size. Give simple contraints@>=

@*Player Guesses. This is the game loop for the player guessing the computers code.

The computer will need to generate a random code. $P$ will be an ordered set of a random colour $c$ in the set of all colours $C$. $P = (c_1 \in C, ... , c_P \in C)$

The player will then enter a combination of colours/letters representing their guess.

The computer will then inform the player as to how many colours and positions they correctly guessed.

The game loop will continue until the player guesses the code. That is the positions correct is equal to $P$

The number guesses taken should be counted so the player can be informed of how they went.

@
@<Player guess code loop@>=

int @<Position matches var@> @<Set to@> 0, @<Colour matches var@> @<Set to@> 0, guesses = 0;

vector<int> @<Players Guess@>(@<$P$@>);

vector<int> @<Computers code@>;

@<Generate computers code@>@;

while(@<Position matches var@> != @<Positions@>)
{
	@<Number of guesses@> @<Set to@> @<Number of guesses@> + 1;
	bool valid_guess = true;
	@<Prompt for player guess@>
	@<Read in player guess@>@;
	@<If help code entered print help@>@;
	@<If quit code entered quit@>@;
	if(valid_guess)
	{
		@<Colour and Position Count@>@;
		@<Inform player of number of correct@>@;
	}
	else
	{
		cout << "Invalid guess. Please try again or type ? for help." << endl;
	}
}

@ Well need some headers for generating a random number
@<Includes@>=
#include <random>

@ Generate a random code into answer. Will need to be $answer = (c_1 \in C, ... , c_P \in C)$
@<Generate computers code@>=

@<Setup random number gen@>@;

for(int i = 0; i < @<Positions@>; i++)
{
	@<Computers code@>.push_back(uniform_dist(e1));
}

@ Promt the player for their guess. Possibly some help like my fortran verions
eg; 
           |rgbyp|ac
Enter guess: 

The characters between the || should be the same as $P$ and the colours printed out should be all the colours as their shortcuts. Looping if need be
so |rprp| for $P = 4, C = 2$

or something like
|rp|gb for $P = 2, C = 4$

Each character should be the same colour as the colour it is representing.

@<Prompt for player guess@>=
cout << "           |";
for(int i = 0; i < @<$C$@> || i < @<$P$@>; i++)
{
	if(i == @<$P$@>)
	{
		@<Reset console@>
		cout << "|";
	}
	cout << @<Colour escape sequence begin@> << @<Colour codes@>[i % @<$C$@>] << @<Colour escape sequence end@> << @<Colour string for shortcuts@>[i % @<$C$@>];

}
@<Reset console@>
if(@<$P$@> >= @<$C$@>)
{
	cout << "|";
}

cout << endl;

cout << "Enter guess:";


@ Will need to update this with conversion from characters such as r for red to a number.

Read in players guess, store in players guess.

Set flag if there is a problem.

Read in our input. Go over the input and build a guess from the letters entered. Numbers are used else where. Red is always 0, Purple 1, etc

Maybe an enum somewhere for those colours?

Anyway try and read in. If we run into an error. Which is have left over non whitespace input or not enough input then there was an error and this wasn't a valid guess.

Our program should read until the first non white space. It should check to see if the character it stop at is a valid colour shortcut letter. r red, p purple.

If so add it to the guess in it's proper position.

If not there was a problem with the guess. Flag as invalid guess and gracefully fail.

@<Read in player guess@>=

@<Read string input@>

string::size_type @<Current character index@> @<Set to@> 0;

for(int i = 0; valid_guess && i < @<$P$@> && @<There is another colour to read@>; i++)
{
	@<Set next colour to the index of the next character@>
	
	if(@<There is another colour to read@> && @<Current character corresponds to a colour@>)
	{
		@<Players Guess@>[i] = @<Colour string for shortcuts@>.find_first_of(input[@<Current character index@>]);
		
		@<Current character index@>++;
	}
	else
	{
		valid_guess = false;
	}
}

@ Current index of the character we are looking at. -1 means we haven't looked at any, string::npos means we have moved past the end.

@<Current character index@>=
current_character_index


@ <Current character index> is an index of the first character we haven't checked. We need to find the next character in the input which is not a whitespace character.

We should start at this character then stop when we go beyond the end of the size of the input or find a non whitespace character

@<Set next colour to the index of the next character@>=
@<Current character index@> @<Set to@> input.find_first_not_of(@<Whitespace chars@>, @<Current character index@>);


@ If we have another character to read, which means <Current character index> is still an index in input. Then all is good. This should then evaluate to true

If the index is not a valid position in the string then this should evaluate to false

@<There is another colour to read@>=
(@<Current character index@>!= string::npos)

@ We need to check to see if the character we are looking at represents a colour. r = red, p = purple. something like x might not be mapped to a colour and thus should make this evaluate to false.

If it does map then this should evaluate to true.
@<Current character corresponds to a colour@>=
(@<Colour string for shortcuts@>.find_first_of(input[@<Current character index@>]) != string::npos)

@ White space charactes we should skip over when parsing input
@<Whitespace chars@>=
whitespace_charactes

@ We need to know what white space characters we should skip over when parsing a player guess string. This way they can put tabs and spaces in if they choose and it won't get upset.

If it messed up with their count we don't really care.

Possible future goal. Make it so they can enter in names for the colours. red as red. Maybe even commas. red, red, purple, blue

@<Globals@>=
string @<Whitespace chars@> @<Set to@> " ";

@
@<Inform player of number of correct@>=

cout << "You matched " << @<Colour matches var@> << " colour" << (@<Colour matches var@> @<Equals@> 1 ? "" : "s") << " ";
cout << "and " << @<Position matches var@> << " position" << (@<Position matches var@> @<Equals@> 1 ? "" : "s") << " " << endl;

@ Number of positions in game
@<Positions@>=
@<$P$@>

@ Number of positions in game
@<$P$@>=
P

@ Number of colours in game
@<$C$@>=
C


@ This variable should be the variable used in <Colour and Position count> to count the number of positions
@<Position matches var@>=
position_count

@ This variable should be the variable used in <Colour and Position count> to count the number of colours
@<Colour matches var@>=
colour_count

@ This will be the guess needed for <Colour and position count> variable

Should match one of the variables in colour count macro but not the same as <answer>
@<Players Guess@>=
@<Code Y@>

@ This will be the answer needed for <Colour and position count> variable

Should match one of the variables in colour count macro but not the same as <guess>
@<Computers code@>=
@<Code X@>

@ 
@<Congraulate player on winning@>=

cout << "You guessed my code. It took " << @<Number of guesses@> << " ";
if(@<Number of guesses@> @<Equals@> 1)
{
	cout << "guess." << endl;
}
else
{
	cout << "guesses." << endl;
}
@*Computer guesses.

@ Each turn the computer will need to randomly select possible codes eliminating codes as possible by comparing them to previous guesses with answers until one that is possible is found.

The computer will then display the guess and the user will enter the number of colour and positions matched to their hidden code.

If there are no possible codes left then the computer knows the player cheated.

@<Computer guesses players code loop@>=

@<Declare computer game loop vars@>

cout << "Give me a moment to think of how I am going to beat you..." << endl;

@<Fill $S$ with all possible codes@>

@<Shuffle $S$@>

cout << "Okay I've got my plan!" << endl;

@<Guess iterator@> @<Set to@> @<First in $S$@>;


for(bool @<Code has been guessed@> @<Set to@> false; @<Code has NOT been guessed@> && @<More codes to check@>; )@;
{

	@<Number of guesses@> @<Set to@> @<Number of guesses@> + 1;
	
	@<Setup var to hold guess and answers@>
	
	@<Ask player if code is answer@>
	
	@<Update code guessed@>
	
	@<Add current guess and answer to previous guesses@>
	
	cout << "Give me a moment to think of my next guess..." << endl;
	
	@<Set current guess to next guess@>
	
	@<Code has been guessed@> @<Set to@> (*(@<Previous guesses@>.rbegin())).positions @<Equals@> @<$P$@>;
	
	player_cheated = @<Previous guesses@>.back().positions != @<$P$@>;
}

@ We'll need a structure of some kind to tie a guess code and the colour and position matches the player entered for that guess
@<Globals@>=

struct @<Guess and answer type@>{
	@<Code type@> guess;
	int colours;
	int positions;
};

@ $S$ our set of all possible codes.

Set of previous guesses used to check each guess to see if they are possible.

Some variable that lets us know which code in $S$ we are upto.

@<Declare computer game loop vars@>=

vector<@<Code type@> > @<$S$@>;

vector< @<Guess and answer type@> > @<Previous guesses@>;

vector< @<Code type@> >::iterator @<Guess iterator@>;

@ The index of the current guess in $S$
@<Guess iterator@>=
S_iterator

@ The variable name for the guess and answer type.

Needs to store a guess and the number of positions and answers
@<Guess and answer type@>=
guess_and_answer_type

@ Type of variable a code should be represented by. Should be able to contain any number of positions but doesn't need to change after it has been set.
@<Code type@>=
vector<int>

@ Contrains all possible guesses
@<$S$@>=
S

@ Contains a guess and the colour and position matches
@<Computers guess and players answer@>=
guess_and_answer

@ List of all previous guesses with colour and position matches
@<Previous guesses@>=
previous_guesses

@ This should be the first code in a shuffled $S$. This way we can just stop when we reach the last code in $S$ rather than going back to the beginning. Since $S$ should be shuffled and we only need to check each code once.
@<First in $S$@>=
@<$S$@>.begin()

@ $S$ should contain all possible code values in any order. We will shuffling this so it doesn't matter if they are in some sort of cardinal order.
@<Fill $S$ with all possible codes@>=

vector<int> temp_code;
for(int i = 0; i < @<$P$@>; i++)
{
	temp_code.push_back(0);
}

@<Set number of codes to size of game $C^P$@>@;

for(int i = 0; i < @<Number of Codes@>; i++)
{
	@<$S$@>.push_back(temp_code);
	@<Generate next code@>@;
}

@ The total number of codes in the game
@<Number of Codes@>=
size_of_s

@ Generate the next code in sequence.

Codes are stored in an array. $(0, 0, 0, 0)$ is the first of a $4$ position code of a base $C$ array.

Addition is left to right unlike normal maths.

This when the first index reaches $C$ we need to reduce it to 0 and increment then the highest place.

If that reaches $C$ then reduce to 0 and increment the next and so forth.

We should stop if we go off the end of our vector since we only have so many spaces to store our numbers.

@<Generate next code@>=
vector<int>::iterator current_position = temp_code.begin();

int carry = 1;

*current_position @<Set to@> *current_position + carry;

carry = 0;

while(current_position != temp_code.end() && (*current_position >= @<$C$@> || carry > 0))
{
	*current_position @<Set to@> *current_position + carry;
	
	if(*current_position >= @<$C$@>)
	{
		*current_position = *current_position - @<$C$@>;	
		carry = 1;
		current_position++;
	}
	else
	{
		carry = 0;
	}
}

@ In order to select random codes we'll need to shuffle $S$. This way we don't need to pick a random code to start from since the next code after elimiating a code by using it as a guess or finding it is not possible will be a random one.

This should also prevent cases were long, long stretches of codes are not possible. Making selecting a code lumpy with performance. Possible codes should be evenishly disdributed throught $S$
@<Shuffle $S$@>=

random_device rd;

mt19937 g(rd());

shuffle(@<$S$@>.begin(), @<$S$@>.end(), g);

@ Should be equal to whether the code has been successfully guessed by the computer
@<Code has been guessed@>=
code_guessed

@ Should be equal to the code not being guessed by the computer. That is not <Code has been guessed>.
@<Code has NOT been guessed@>=
!@<Code has been guessed@>

@ We need to know if there are more code to guess. This should return whether our <Current guess> has exhausted the codes in $S$
@<More codes to check@>=
@<Guess iterator@> @<Not equal to@> @<$S$@>.end()

@ Our current guess will need to be the next guess in $S$ that is possible. We will need to sequentially move through random codes in $S$ until we find a possible guess.

If $S$ is in a random order then we can just take the next index in $S$. Which it should be.
@<Set current guess to next guess@>=

@<Guess iterator@>++;
bool @<Possible guess?@> @<Set to@> false;
while(@<Guess iterator@> @<Not equal to@> @<$S$@>.end() && !@<Possible guess?@>)
{
	@<Check if current guess code is possible@>@;
	if(!@<Possible guess?@>)
	{
		@<Guess iterator@>++;
	}
}

@ We need to check our current guess against all previous guesses and answers to see if it is possible. We can stop when we find that it is not possible rather than check against all previous guesses.

Guess iterator will point to one value we are comparing.

The other will come from the previous guesses.

Perhaps Code X for current code in $S$ and Code Y for the current previous guess?

@<Check if current guess code is possible@>=

auto @<Previous guess iterator@> @<Set to@> @<Previous guesses@>.begin();
@<Possible guess?@> @<Set to@> true;@;
@<Code type@> & @<Code X@> @<Set to@> * (@<Guess iterator@>);@;

while(@<Previous guess iterator@> @<Not equal to@> @<Previous guesses@>.end() && @<Possible guess?@>)@;
{
	@<Colour and postion count variables declared@>@;
	@<Code type@> & @<Code Y@> @<Set to@> (* (@<Previous guess iterator@>)).guess;@;
	int & @<Guess colour count@> @<Set to@> (* (@<Previous guess iterator@>)).colours;@;
	int & @<Guess position count@> @<Set to@> (* (@<Previous guess iterator@>)).positions;@;
	@<Check if code possible@>@;
	@<Previous guess iterator@>++;
}

@ The variables needed for <Colour and position count>

Without these we won't be able to compare the results with what our guess code made and eliminate impossible codes.

@<Colour and postion count variables declared@>=
int @<Colour count@> @<Set to@> 0;
int @<Position count@> @<Set to@> 0;

@ Stores the location of the guess we are upto in $S$
@<Previous guess iterator@>=
previous_guess_iterator

@ Is a guess checked by the computer a possible guess variable
@<Possible guess?@>=
is_possible_guess

@ Variable which holds the colour count from a guess previously made. Used in <Check if code possible> to see if a code is possible compared to a previous guess.
@<Guess colour count@>=
guess_colour_count

@ Variable which holds the position count from a guess previously made. Used in <Check if code possible> to see if a code is possible compared to a previous guess.
@<Guess position count@>=
guess_position_count

@ Present guess to player and record their reponse
@<Ask player if code is answer@>=
cout << "Is this your code? ";
for(int i = 0; i < @<$P$@>; i++)
{
	if(i < @<$P$@> - 1)
	{
		if(i > 0)
			cout << ", ";
	}
	else
	{
		cout << " and ";
	}
	int colourindex = @<Computers guess and players answer@>.guess[i];
	string colourname = @<Colour names@>[colourindex];
	string colourcode = @<Colour codes@>[colourindex];
	cout << @<Colour escape sequence begin@> << colourcode << @<Colour escape sequence end@> << colourname;
	@<Reset console@>
	
}
cout << "\nHow many Colours and Positions did I match?\neg; 0 2 for 0 colours and 2 positions.\n?";
@<Read string input@>@;
@<If help code entered print help@>@;
@<If quit code entered quit@>@;

@<Read player answer into guess answer@>

while(@<Invalid player colour and position answer@>)
{
	cout << "Invalid answer. Colours and positions should be >= 0 and sum to atmost " << @<$P$@> << endl;
	cout << "How many codes did I get correct?";
	@<Read string input@>@;
	@<If help code entered print help@>@;
	@<If quit code entered quit@>@;
	@<Read player answer into guess answer@>@;
}


@ This should read an answer the player has given in regards to a computers guess and place it in the appropriate place.

The user is entering a string so the numbers will need to be extracted and cleanly fail if there is an error to allow the user to enter their answer in again.

@<Read player answer into guess answer@>=


ss.clear();
ss.str(string());
ss << input;
try {
	@<Computers guess and players answer@>.colours -1;
	@<Computers guess and players answer@>.positions @<Set to@> -1;
	ss >> @<Computers guess and players answer@>.colours >> @<Computers guess and players answer@>.positions;
}
catch(...)
{
	@<Computers guess and players answer@>.colours -1;
	@<Computers guess and players answer@>.positions @<Set to@> -1;
}


@ User must enter 0 or greater for both the number of colour matches and position matches

Their sum must be less than or equal to the total number of positions

@<Invalid player colour and position answer@>=
(
	@<Computers guess and players answer@>.colours < 0 
	||
	@<Computers guess and players answer@>.positions < 0 
	||
	(@<Computers guess and players answer@>.colours + @<Computers guess and players answer@>.positions) > @<$P$@>
)

@ Check to see if this code is the answer
@<Update code guessed@>=


@ Update list of previous guesses and answers with this guess and answer
@<Add current guess and answer to previous guesses@>=
@<Previous guesses@>.push_back(@<Computers guess and players answer@>);

@ This will need to hold the guess made and the users answer. The guess will to be the guess made, the answer will be the answer the user then inputs.

This will need to be added to our list of previous guesses made.

The computer guess should be pointed to by the guess iterator.

@<Setup var to hold guess and answers@>=
@<Guess and answer type@> @<Computers guess and players answer@>;
@<Computers guess and players answer@>.guess @<Set to@> *(@<Guess iterator@>);
@<Computers guess and players answer@>.colours = -1;
@<Computers guess and players answer@>.positions = -1;

@ 
@<Tell player they cheated@>=

cout << "Hey I think you cheated!" << endl;

@
@<Computer claims victory@>=

cout << "I guessed your code. It took " << @<Number of guesses@> << " ";
if(@<Number of guesses@> @<Equals@> 1)
{
	cout << "guess." << endl;
}
else
{
	cout << "guesses." << endl;
}

@ The number of guesses it took the player or computer to guess the others code
@<Number of guesses@>=
number_of_guesses_taken

@
@<Ask if player wants to play again@>=
@<Read string input@>
while(input != "yes" && input != "y" && input != "no" && input != "n")
{
	@<If help code entered print help@>@;
	@<If quit code entered quit@>@;
	@<Read string input@>
}

play_again = (input == "yes" || input == "y");


@
@<Globals@>=
vector<string> @<Colour codes@>({"160", "93", "38", "40", "220", "245" , "87", "212"});
vector<string> @<Colour names@>({"Red", "Purple", "Blue", "Green", "Yellow", "Grey", "Aqua", "Pink"});
vector<string> @<Colour with shortcuts@>({"(R)ed", "(P)urple", "(B)lue", "(G)reen", "(Y)ellow", "Gr(e)y", "(A)qua", "Pi(n)k"});
vector<string> @<Colour shortcuts@>({"r", "p", "b", "g", "y", "e", "a", "n"});
string @<Colour string for shortcuts@> @<Set to@> "rpbgyean";


@
@<Print how to enter colour/position matches@>=

@*Colour and Position Count.

This one is getting it's own special this is important section.

Okay so we have two guess in the set of all possible codes $g_1 \in S$ and $g_2 \in S$

Let $g_1$ be the answer and $g_2$ be the guess.

If we want to find the number of positions we count the cardinality of the intersection of $g_1$ and $g_2$, $\mid g_1 \bigcap g_2 \mid$

Why? Okay say we line up our guesses one over the other. We then look at the first position in both. Does it match? Yes, good that is one position match. First index of $g_1$ and first position of $g_2$. Then keep repeating until we've checked every matching position.

Note that which one is the answer and which one is the guess is unimportant.

@ Okay assume we have a solution for position as above.

Now if we want to know if a colour $c$ is in a set of colours $C$ then we just see if $c \in C$. Which is reverable. We can check $c$ against all $e \in C$ or every $e \in C$ against $c$

If we want to check multiple colours we can remove matches in $C$ as we find them. So if $c_i \in C$. $C \ c_i \mapsto C$ and keep a count of elements removed from $C$

Note there is no sizes where. The set of all $c_i$ could be any size and $C$ could be any size. They might be the same, one might have more elements or the other might have more elements.

Also if we stop at any point then we have the matches of upto that point. So we could stop at $c_(i - 1)$ and we could have the number of colour matches of $(i - 1)$ elements in $c$. Conversely if we add another element then we get the total matches for $(i + 1)$ as the matches for $i + 1$ is the matches for $i$ colours in $c$ plus $c_i + 1)$

This also means we can pick either element from either set to be our next comparison element since adding one element will be the correct answer for that combination of elements from $c$ and $C$

When we cross off an element in $C$ we are reducing the number of that type of element from $C$. When there are no more left we have a count of 0 and no longer increment our count of matches if that element is $c_i$. If we counted all the elements $e \in C$ and kept a table of how many of each type we started with for each colour. We could do the following. Find the entry for $c_i$. If it is a possitive number, there is still some $e \in C$ that hasn't been removed. Increment count by 1 and decrement the number of that element in $C$ by 1.

Also we can take a mirror image or complement of all operations except for incrementing our colour count and comparison between elements. So instead of incrementing by 1, we decrement by 1. If we decrement by 1, we increment by 1. If our number of elements is $> 0$ becomes if our number of elements is $< 0$

We then have the way to build our initital table from our first set. Which is the count of each element and a colour match count of 0.

Also we can begin with the first positive algorithm. Where we will end up with the negative count of each colour and a 0 colour count. If we apply the negative version (complement of the first positive algorithm) to this table we end up with the count of colour matches. Why? Because if we take the complement of each then we end up with the positive algorithm and positive starting table.

How does this help us?

We can use it for a O(n) pass to calculate the position and colour matches.

As the order of which elements we pick doesn't matter and the complement algorithm works on the complement table and each algorithm produces the correct table for it's complement to count the number of colour matches. We can pick one from one set and then one from the other set.

If we then exclude the position matches which are also colour matches and run that algorithm/count at the same time. We end up with the number of colour matches and position matches.


$x = $ either set

$y = $ the other set

$n = $number of positions

table of colours $A = (C_1, C_2, ..., C_n)$ all set to count of $0$ and where $C_m$ is an element type/colour count.

count count $c = 0$

position count $p = 0$

for $1$ to $n$

$\indent$    if $x_n = y_n$
	
$\indent$$\indent$	    increment position count
		
$\indent$	else

$\indent$$\indent$	    do positive algorithm on $x_i$
	
$\indent$$\indent$		do negative algorithm on $y_i$
		
$\indent$	end if
	
end for
		

Oh for proof. Show if one code has less positions than the other. Then using either will show the matching colours.
	

@		
@<Colour and Position Count@>=

@<Build Colour table@>@;

@<Colour count@> @<Set to@> 0;

@<Position count@> @<Set to@> 0;

int colour = 0; @;

for (int i = 0; i < @<$P$@>; i++)
{
	if(@<Code X@>[i] == @<Code Y@>[i])
	{
		@<Position count@> @<Set to@> @<Position count@> + 1;
	}
	else
	{
		@<Positive count algorithm on X@>@;
		@<Negative count algorithm on Y@>@;
	}
}

@ We need a table for the colours.

Should be initialised to 0 for all colours $C$

@<Build Colour table@>=

vector<int> @<Colour table@>;
for(int i = 0; i < @<$C$@>; i++)
{
	@<Colour table@>.push_back(0);
}

@
@<Colour table@>=
colour_table

@ Code x for colour and position count
@<Code X@>=
code_x


@ Code y for colour and position count
@<Code Y@>=
code_y

@ Number of colour matches found
@<Colour count@>=
colour_count

@ Number of position matches found
@<Position count@>=
position_count

@ Positive algorithm

Increment colour count if there is a positive value for the colour in the colour table

decrement the value for the colour in the colour table

@<Positive count algorithm on X@>=

colour = @<Code X@>[i];
if(@<Colour table@>[colour] > 0)
{
	@<Colour count@> @<Set to@> @<Colour count@> + 1;
}
@<Colour table@>[colour] = @<Colour table@>[colour] - 1;



@ Negative algorithm

Increment colour count if there is a negative value for the colour in the colour table

increment the value for the colour in the colour table

@<Negative count algorithm on Y@>=

colour = @<Code Y@>[i];
if(@<Colour table@>[colour] < 0)
{
	@<Colour count@> @<Set to@> @<Colour count@> + 1;
}
@<Colour table@>[colour] = @<Colour table@>[colour] + 1;

@ This should work out whether a code is possible.

The way this works is to compare <Code X> with <Code Y> and see if the count of colours and positions is the same as given to either one when it was made as a guess.

I should come up with a proof of this here.

@ Okay why does this work. Sort of putting the cart before the horse by using this logic from my fortran version without writing the explaination unlike my colour and position counter.

The logic works like this. If we have some number of colour matches in a previous guess and a possible guess has a different number of colour matches with the previous guess. That means that we are missing at least one colour or have one colour that cannot be from the answer code in our possble guess. We might not know which but we know it is not possible. The same for positions.

@ Actually here's the short and simple explaination and the only one that is needed.

If our possible guess is the answer it should produce the exact same colour and position matches as the player has entered for the previous guess.

If it is anything different then it cannot under any circumstances be the answer.

This works because the operation we are doing for the count of colours and positions between a previous guess and possible guess is the same as what the player is doing when working out the colour and position matches to their secret answer code.

@<Check if code possible@>=

@<Colour and Position Count@>@;

@<Possible guess?@> @<Set to@> @<Colour count@> @<Equals@> @<Guess colour count@> @<And@> @<Position count@> @<Equals@> @<Guess position count@>;


@*Input Output Utilities.

Reading input and processing the input`

@ Read a string from standard input.

Hmm. I might need to rethink this macro. It might need to be specific to the macro it is part of rather than general.

Such as reading into $C$ and $P$ sizes

@<Read string input@>=
getline (cin, input);
@<convert input to lowercase@>@;


@*Console Colour.

Utility macros for handling console colours

@ Beginning half to change the colour of the console sequence

$\backslash$ is $92$ in the ASCII tables 

Full escape sequence is $\backslash$033[38;5;$N$;m]

@<Colour escape sequence begin@>=
"\033[38;5;"

@ End of change colour sequence
@<Colour escape sequence end@>=
"m"

@ Reset the console colour
@<Reset console@>=
cout << "\033[0m";

@ Reset the console colour
@<Reset colour code@>=
"\033[0m"

@ Array to hold the names of eat colour.

Should match the colours in <Colour codes>

@<Colour names@>=
colour_names

@ Array to hold the colour code, that is the int that will display that colour in the console, for each corresponding colour in <Colour names>

@<Colour codes@>=
colour_codes

@ Displays a colour along with the single lowercase char that will identify it from input.

@<Colour with shortcuts@>=
colours_with_shortcuts

@ A string containing the same information as <Colour shortcuts> except as a single string.
@<Colour string for shortcuts@>=
colour_shortcuts_as_string

@ Single character shortcuts for each colour. Index matching other colour related arrays.

@<Colour shortcuts@>=
colour_shortcuts

@*In Game Help.

Macros dealing with the in game help.

When help has been requested

What to display regarding help
	
@ Help. Help for the player. Should print codes for colours, number of positions required, how to enter codes, how to quit.
@<Game Help@>=

@<Print gameplay summary@>
if(player_guessing)
{
@<Print colours to choose from@>@;
}
else
{
@<Print how to enter colour/position matches@>@;
}

@<Print game commands@>@;

@ Check if the player entered the command for help
@<If help code entered print help@>=
if(input == "help" | input == "?")
{
	@<Game Help@>@;
}

@
@<Print game commands@>=
cout << "enter 'quit', 'q' or 'exit' to quit" << endl;


@ Summary of how to play the game.

Tell player how to answer if they picked the code

Tell the player what the computers answers mean
@<Print gameplay summary@>=


@*Quitting.

Identify when the player has requested to quit

Quit game if requested

@ Quit program if player selects quit commands@

Commands that quit program are 'q', 'quit', 'exit'

The assumption is that the input is all lower case

@<If quit code entered quit@>=
if(input == "quit" | input == "q" | input == "exit" )
{
	cout << "Thanks for playing!" << endl;
	return 0;
}


@*Random Numbers.

Macros for random numbers

@ Set up the random number generator to generate $0 \leq n < P$ 
@<Setup random number gen@>=
random_device r;
default_random_engine e1(r());
uniform_int_distribution<int> uniform_dist(0, @<$C$@> - 1);

@*Utilities.

@ Assign value on the right to the variable on the left
@<Set to@>=
 = 
 
@ Comparitor check. Is the value on the left the same as the one on the right?
@<Equals@>=
 == 
 
@ Comparitor check. Is the value on the left different to the one on the right?
@<Not equal to@>=
 != 
 
@ And boolean operator. Left AND right of operator
@<And@>=
 && 
@ Left times right
@<Times@>=
 * 

@*Index.