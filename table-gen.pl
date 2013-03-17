# 
# min_num_words-max_num_words;min_num_content;max_num_content 
# 
# 
# 
# 

#!/usr/bin/perl
#use strict;
use warnings;

use Getopt::Std;

my @random_text = qw/Lorem ipsum dolor sit amet consectetur adipisicing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur Excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum/;

my $tab = "    ";

# Process Command Line Arguments
# -c    column information as a quote string in the format "min_num_words-max_num_words,min_num_content-max_num_content;"
# -f    output file, defaults to stdout if no file specified
# -i    filename of file containing column information in the format "min_num_words-max_num_words,min_num_content-max_num_content\n"
# -r    number of rows of data to generate, defaults to 25 rows if not specified
# if no column information specified (via command-line or input file) default will randomly generate column data
our $opt_c = 0;
our $opt_f = 0;
our $opt_i = 0;
our $opt_r = 0;

getopts("c:f:i:r:");

if($opt_i && $opt_c) {
    die "Error: cannot specify -c and -i option\n";
}

my %this_column;
my $column_string;
my @columns;
my $input_file;
my $num_of_rows = 25;

if($opt_c) {
    $column_string = $opt_c;

    while($column_string =~ /(\d)-(\d);(\d)-(\d)/g) {
        %this_column = {
            'min_num_words_header'  => $1,
            'max_num_words_header'  => $2,
            'min_num_words_content' => $3,
            'max_num_words_content' => $4
        };

        push(@columns, %this_column);
    }
}


if($opt_i) {
    $input_file = $opt_i;
    open(IN, $input_file) || die "Cannot open file $input_file: $!";

    while(my $line = <IN>) {
        if($line =~ /(\d)-(\d);(\d)-(\d)/) {
            %this_column = {
                'min_num_words_header'  => $1,
                'max_num_words_header'  => $2,
                'min_num_words_content' => $3,
                'max_num_words_content' => $4
            };

            push(@columns, %this_column);
        }
    }
}

if($opt_f) {
    my $output_file = $opt_f;
    open(OUTPUT, "> ".($output_file || '-')) or die "Error: Could not write to $output_file";
}
else {
    *OUTPUT = *STDOUT;
}

if($opt_r) {
    $num_of_rows = $opt_r;
}

print OUTPUT "$tab<table>\n";

# Column Headers
print OUTPUT "$tab$tab<tr>\n";
foreach(@columns) {
    my $num_words_header = int(rand($_{'max_num_words_header'} - $_{'min_num_words_header'}));
    $num_words_header = $num_words_header + $_{'min_num_words_header'};

    my $header_content = getRandomText($num_words_header);

    print OUTPUT "$tab$tab$tab<th>$header_content</th>\n";
}

# Row Data
for(my $i = 0; $i < $num_of_rows; $i++) {
    
    print OUTPUT "$tab$tab<tr>\n";

    foreach(@columns) {
        my $num_words_content = int(rand($_{'max_num_words_content'} - $_{'min_num_words_content'}));
        $num_words_content = $num_words_content + $_{'min_num_words_content'};

        my $cell_content = getRandomText($num_words_content);
        print OUTPUT "$tab$tab$tab<td>$cell_content</td>\n";
    }

    print OUTPUT "$tab$tab</tr>\n";
}

print OUTPUT "$tab</table>\n";

sub getRandomText
{
    my $num_of_words       = shift;
    my $index = int(rand($#random_text));
    my @words;

    for(my $i = 0; $i < $num_of_words; $i++) {
        $index = $index++;
        if($index == ($#random_text - 1)) {
            $index = 0;
        }
        push(@words, $random_text[$i]);
    }

    return join(' ', @words);
}

sub usage
{



}
